Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab2GANbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:31:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab2GANbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:31:51 -0400
Message-ID: <4FF0513F.3090909@redhat.com>
Date: Sun, 01 Jul 2012 16:31:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, mtosatti@redhat.com,
        agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] KVM: MMU: Avoid handling same rmap_pde in kvm_handle_hva_range()
References: <20120628105733.ccd9abb3.yoshikawa.takuya@oss.ntt.co.jp> <20120628110235.7410445e.yoshikawa.takuya@oss.ntt.co.jp> <4FEC9A2B.6000104@redhat.com> <20120629104629.b369cd40.yoshikawa.takuya@oss.ntt.co.jp> <4FEFFF11.4000309@redhat.com> <20120701221857.f3b9ee04e590ff7f1a0a335a@gmail.com>
In-Reply-To: <20120701221857.f3b9ee04e590ff7f1a0a335a@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 04:18 PM, Takuya Yoshikawa wrote:
> On Sun, 01 Jul 2012 10:41:05 +0300
> Avi Kivity <avi@redhat.com> wrote:
> 
>> >> > Note: in the new code we could not use trace_kvm_age_page(), so we just
>> >> > dropped the point from kvm_handle_hva_range().
>> >> > 
>> >> 
>> >> Can't it be pushed to handler()?
>> > 
>> > Yes, but it will be changed to print rmap, not hva and gfn.
>> > I will do in the next version.
>> 
>> We should try to avoid changing the tracepoint ABI.  If we pass the
>> memslot to handler(), we should be able to reconstruct the gfn and hva.
> 
> That's not enough because we only know rmapp in the handler: we also need
> level or something.  I agree that passing memslot for keeping the ABI is
> good, but how about two more arguments?

I don't see a problem with that.  But it would be good to move all the
address transformations into tp_fast_assign so we only perform them if
the tracepoint is active.

> BTW, trace_kvm_age_page() is tracing every handler, not just kvm_age_rmapp().
> Is this intentional?

No, it's a bug.  Pushing the trace into the handler will fix it though.

> If we trace in the caller, in kvm_age_hva(), we know hva, but not gfn.

gfn is useful to correlate to later events with the same gfn.

-- 
error compiling committee.c: too many arguments to function


