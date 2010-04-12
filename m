Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab0DLJZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 05:25:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54886 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab0DLJZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 05:25:05 -0400
Message-ID: <4BC2E654.7050002@cn.fujitsu.com>
Date: Mon, 12 Apr 2010 17:22:28 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] KVM MMU: fix kvm_mmu_zap_page() and its calling path
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D345.100@cn.fujitsu.com> <4BC2D8D6.6030306@redhat.com> <4BC2DFA0.6000609@cn.fujitsu.com> <4BC2E2FF.9020005@redhat.com>
In-Reply-To: <4BC2E2FF.9020005@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

Avi Kivity wrote:

> hlist_for_each_entry_safe() is supposed to be be safe against removal of
> the element that is pointed to by the iteration cursor.

If we destroyed the next point, hlist_for_each_entry_safe() is unsafe.

List hlist_for_each_entry_safe()'s code:

|#define hlist_for_each_entry_safe(tpos, pos, n, head, member) 		 \
|	for (pos = (head)->first;					 \
|	     pos && ({ n = pos->next; 1; }) && 				 \
|		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
|	     pos = n)

if n is destroyed:
'pos = n, n = pos->next'
then it access n again, it's unsafe/illegal for us.

Xiao
