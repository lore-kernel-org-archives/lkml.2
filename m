Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1LUSY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:24:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44111 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1LUSYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:24:53 -0500
MIME-Version: 1.0
In-Reply-To: <20111221145928.GP5650@redhat.com>
References: <1318533267-18880-2-git-send-email-dzickus@redhat.com>
	<tip-3603a2512f9e69dc87914ba922eb4a0812b21cd6@git.kernel.org>
	<CAE9FiQWX_2bV1phLCUrEpiPSfo24xWEv3Y+DZnwmi9JJgJHbmQ@mail.gmail.com>
	<20111221145928.GP5650@redhat.com>
Date: Wed, 21 Dec 2011 10:24:53 -0800
X-Google-Sender-Auth: 7uEP1kz8d-b3I_ZQNhHvg9o4x5s
Message-ID: <CAE9FiQUW5tf5-Fbn0a_8s58P+7rXbG6iWPaDeHOuhxw4TZE+hQ@mail.gmail.com>
Subject: Re: [tip:x86/debug] x86, reboot: Use NMI instead of REBOOT_VECTOR to
 stop cpus
From: Yinghai Lu <yinghai@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 6:59 AM, Don Zickus <dzickus@redhat.com> wrote:
> On Tue, Dec 20, 2011 at 02:38:39PM -0800, Yinghai Lu wrote:
>> > @@ -230,7 +285,7 @@ struct smp_ops smp_ops = {
>> >        .smp_prepare_cpus       = native_smp_prepare_cpus,
>> >        .smp_cpus_done          = native_smp_cpus_done,
>> >
>> > -       .stop_other_cpus        = native_stop_other_cpus,
>> > +       .stop_other_cpus        = native_nmi_stop_other_cpus,
>> >        .smp_send_reschedule    = native_smp_send_reschedule,
>> >
>> >        .cpu_up                 = native_cpu_up,
>>
>> this broke kexec on our intel nehalem, westmere and sandbridge platforms.
>> system get reset while try to kexec second kernel.
>
>
> Hmm. Ok.  Does the reboot path work correctly?

Yes.

> Vivek showed me that the
> kexec and reboot paths do the same shutdowns.  Perhaps the second kernel
> has trouble dealing with cpus spinning in an NMI context and can't
> properly reset them.

not sure.
when use nonmi_ipi in first kernel, it will work well.

Thanks

Yinghai
