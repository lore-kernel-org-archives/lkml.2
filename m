Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2BQUTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:19:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab2BQUTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:19:05 -0500
Date: Fri, 17 Feb 2012 15:18:42 -0500
From: Don Zickus <dzickus@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, torvalds@linux-foundation.org,
        kexec@lists.infradead.org, vgoyal@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org,
        "d.hatayama" <d.hatayama@jp.fujitsu.com>
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
Message-ID: <20120217201842.GP9751@redhat.com>
References: <CAE9FiQVLnyRB+pAqi22C5mCbHOOVKxsBhQKaB6P0p9f2LBL8bA@mail.gmail.com>
 <m1zkcmyjyd.fsf@fess.ebiederm.org>
 <CAE9FiQVj12UCGbOe4wZfx-L8tdab-1si-RA=vBnNeZ7cUNqyyg@mail.gmail.com>
 <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com>
 <20120216172735.GX9751@redhat.com>
 <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com>
 <20120216215603.GH9751@redhat.com>
 <m1y5s2ku36.fsf@fess.ebiederm.org>
 <m1fwe9bpk2.fsf@fess.ebiederm.org>
 <CABOkKT21zhyMwMmbR9WTipk5e=y_qMZ8ByG=njatjKbFLZW+xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABOkKT21zhyMwMmbR9WTipk5e=y_qMZ8ByG=njatjKbFLZW+xQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 12:49:16AM +0900, HATAYAMA Daisuke wrote:
> A few days ago I investigted the case where system is reseted due to
> triple fault caused by the NMI after idt is disabled in
> machine_kexec. I didn't see the reset when trigering the kdump with
> NMI since the NMI is masked until next iret instruction executed as
> described in 6.7.2. Handling Multiple NMIs of Intel Manual Vol.3A.
> The NMI mask remains untill the first iret execution on the 2nd
> kernel: just the return path of the first kernel_thread invocation for
> init process. The exact path is:

hmm.  So even though the local apic was disabled you still got an NMI?
That could have been from an external NMI.  I forget how that is wired up,
if it goes through the IOAPIC to the Local APIC or directly to the NMI pin
on the cpu.

> 
>   switch_to
>   -> ret_from_fork
>      -> int_ret_from_sys_call
>         -> retint_restore_args
>            -> irq_return
> 
> At that phase idt is already set up and kdump works.
> 
> From the discussion I interpret kdump doesn't assume this behaviour,
> right?

probably not.

> 
> BTW, does anyone know the detail of the NMI mask? I couldn't figure
> out about it from the Intel spec more than ``certain hardware
> conditions''... I expect those who look at here are x86 NMI experts.

I don't understand the question.

Cheers,
Don
