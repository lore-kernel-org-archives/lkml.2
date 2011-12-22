Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1LVURW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:17:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab1LVURS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:17:18 -0500
Date: Thu, 22 Dec 2011 15:16:47 -0500
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86, reboot: Use NMI instead of REBOOT_VECTOR to
 stop cpus
Message-ID: <20111222201642.GZ5650@redhat.com>
References: <1318533267-18880-2-git-send-email-dzickus@redhat.com>
 <tip-3603a2512f9e69dc87914ba922eb4a0812b21cd6@git.kernel.org>
 <CAE9FiQWX_2bV1phLCUrEpiPSfo24xWEv3Y+DZnwmi9JJgJHbmQ@mail.gmail.com>
 <20111221145928.GP5650@redhat.com>
 <CAE9FiQUW5tf5-Fbn0a_8s58P+7rXbG6iWPaDeHOuhxw4TZE+hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQUW5tf5-Fbn0a_8s58P+7rXbG6iWPaDeHOuhxw4TZE+hQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 10:24:53AM -0800, Yinghai Lu wrote:
> On Wed, Dec 21, 2011 at 6:59 AM, Don Zickus <dzickus@redhat.com> wrote:
> > On Tue, Dec 20, 2011 at 02:38:39PM -0800, Yinghai Lu wrote:
> >> > @@ -230,7 +285,7 @@ struct smp_ops smp_ops = {
> >> >        .smp_prepare_cpus       = native_smp_prepare_cpus,
> >> >        .smp_cpus_done          = native_smp_cpus_done,
> >> >
> >> > -       .stop_other_cpus        = native_stop_other_cpus,
> >> > +       .stop_other_cpus        = native_nmi_stop_other_cpus,
> >> >        .smp_send_reschedule    = native_smp_send_reschedule,
> >> >
> >> >        .cpu_up                 = native_cpu_up,
> >>
> >> this broke kexec on our intel nehalem, westmere and sandbridge platforms.
> >> system get reset while try to kexec second kernel.
> >
> >
> > Hmm. Ok.  Does the reboot path work correctly?
> 
> Yes.
> 
> > Vivek showed me that the
> > kexec and reboot paths do the same shutdowns.  Perhaps the second kernel
> > has trouble dealing with cpus spinning in an NMI context and can't
> > properly reset them.
> 
> not sure.
> when use nonmi_ipi in first kernel, it will work well.

Ok.  I tried taking the cpus out of NMI context and putting them into irq
context with irq_work_queue() but that didn't seem to work.  It seems to
be hanging in the new kernel somewhere.  I'll have to wait until I get
back into the office next year to debug with early_printk and a vga
console.

Cheers,
Don
