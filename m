Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab0DLMZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:25:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58598 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab0DLMZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:25:33 -0400
Message-ID: <4BC310A0.3090005@cn.fujitsu.com>
Date: Mon, 12 Apr 2010 20:22:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] KVM MMU: fix kvm_mmu_zap_page() and its calling path
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D345.100@cn.fujitsu.com> <4BC2D8D6.6030306@redhat.com> <4BC2DFA0.6000609@cn.fujitsu.com> <4BC2E2FF.9020005@redhat.com> <4BC2E654.7050002@cn.fujitsu.com> <4BC2F536.70808@redhat.com>
In-Reply-To: <4BC2F536.70808@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 04/12/2010 12:22 PM, Xiao Guangrong wrote:
>> Hi Avi,
>>
>> Avi Kivity wrote:

> But kvm_mmu_zap_page() will only destroy sp == tpos == pos; n points at
> pos->next already, so it's safe.
> 

kvm_mmu_zap_page(sp) not only zaps sp but also zaps all sp's unsync children
pages, if n is just sp's unsyc child, just at the same hlist and just behind sp,
it will crash. :-)
