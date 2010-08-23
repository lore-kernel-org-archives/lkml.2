Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0HWTxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:53:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48300 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab0HWTxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:53:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DVbH+6aQIm37lbIgEBmJACJ0xQ9H3s+U0NvXGcCLiQPRMKH6ROTat3uMvNgJdvy24P
         heE1maLTt1Zts+CcZigeVVwDGnDEUQJPTVmBdpfeorQnjWlFuaO5EJ1mASnD49xGWy+a
         NIcxjtLQaBnTKyNg+96kbUSSdv8qTSidjG8IU=
MIME-Version: 1.0
In-Reply-To: <4C725B75.9000106@redhat.com>
References: <20100820011054.GA11297@tpepper-t61p.dolavim.us>
	<4C724BDB.8020604@redhat.com>
	<4C724D13.6000807@redhat.com>
	<AANLkTi=7HdLqm-g1F+ezhDN4n+vPo2jAo2cgn-M6_wMJ@mail.gmail.com>
	<4C725B75.9000106@redhat.com>
Date: Mon, 23 Aug 2010 12:53:00 -0700
X-Google-Sender-Auth: wKCf-A6uIqjFBgEb3P7BVNSFsOQ
Message-ID: <AANLkTindpNLN+xeDPhuFWrktqZZafgQ+gK_F1sF5Gwh8@mail.gmail.com>
Subject: Re: [PATCH 0/4 v2] kvm: rework KVM mmu_shrink() code
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 4:28 AM, Avi Kivity <avi@redhat.com> wrote:
>  On 08/23/2010 02:11 PM, Xiaotian Feng wrote:
>>
>> On Mon, Aug 23, 2010 at 6:27 PM, Avi Kivity<avi@redhat.com>  wrote:
>>>
>>>  On 08/23/2010 01:22 PM, Avi Kivity wrote:
>>>>
>>>> I see a lot of soft lockups with this patchset:
>>>
>>> This is running the emulator.flat test case, with shadow paging.  This
>>> test
>>> triggers a lot (millions) of mmu mode switches.
>>>
>> Does following patch fix your issue?
>>
>
> It does indeed!

Thanks Xiaotian Feng!

Avi: here's also a minor whitespace fixup on top of the previous.

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
         index f83b941..0c56484 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1696,8 +1696,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm,
unsigned in
                        page = container_of(kvm->arch.active_mmu_pages.prev,
                                            struct kvm_mmu_page, link);
-                       kvm_mmu_prepare_zap_page(kvm, page,
-                                                              &invalid_list);
+                       kvm_mmu_prepare_zap_page(kvm, page, &invalid_list);
                        kvm_mmu_commit_zap_page(kvm, &invalid_list);
                }
                goal_nr_mmu_pages = kvm->arch.n_used_mmu_pages;



Tim
