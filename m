Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0DVGPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:15:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53640 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab0DVGPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:15:14 -0400
Message-ID: <4BCFE8B7.1040004@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 14:12:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/10] KVM MMU: allow more shadow pages become asynchronous
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, shadow page can become asynchronous only if one
shadow page for a gfn, this rule is too strict, in fact, we can
let all last mapping page(i.e, it's the pte page) become unsync
and sync them at invlpg or flush tlb time.
Address this thinking, a gfn may have many shadow pages, for
performance reason, when one sp need be synced, just write
protect sp->gfn and sync this sp but we keep other shadow pages
asynchronous, i.e, sp only can be synced just at their own invlpg
and flush TLB time.

patch 1 ~ 6 are bugfix/cleanup/optimization for current code
patch 7 ~ 10 implement this idea

