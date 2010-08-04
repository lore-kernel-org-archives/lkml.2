Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab0HDJTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:19:55 -0400
Received: from mx1.sophos.com ([195.166.81.52]:40415 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0HDJTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:19:53 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: 2.6.35 hangs on early boot in KVM
Date: Wed, 4 Aug 2010 10:19:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <201008031028.57263.tvrtko.ursulin@sophos.com> <4C592D60.5050309@kernel.org> <201008041016.09176.tvrtko.ursulin@sophos.com>
In-Reply-To: <201008041016.09176.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Message-ID: <201008041019.48819.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2010 10:19:49,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2010 10:19:50,
	Serialize complete at 04/08/2010 10:19:50
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 Aug 2010 10:16:08 Tvrtko Ursulin wrote:
> On Wednesday 04 Aug 2010 10:05:36 Yinghai Lu wrote:
> > On 08/04/2010 01:18 AM, Tvrtko Ursulin wrote:
> > > On Tuesday 03 Aug 2010 21:57:48 Yinghai Lu wrote:
> > >> On Tue, Aug 3, 2010 at 8:59 AM, Tvrtko Ursulin
> > >>
> > >> <tvrtko.ursulin@sophos.com> wrote:
> > >>> On Tuesday 03 Aug 2010 16:17:20 Tvrtko Ursulin wrote:
> > >>>> On Tuesday 03 Aug 2010 15:57:03 Tvrtko Ursulin wrote:
> > >>>>> On Tuesday 03 Aug 2010 15:51:08 Avi Kivity wrote:
> > >>>>>>   On 08/03/2010 12:28 PM, Tvrtko Ursulin wrote:
> > >>>>>>> I have basically built 2.6.35 with make oldconfig from a working
> > >>>>>>> 2.6.34. Latter works fine in kvm while 2.6.35 hangs very early. I
> > >>>>>>> see nothing after grub (have early printk and verbose bootup
> > >>>>>>> enabled), just a blinking VGA cursor and CPU at 100%.
> > >>>>>>
> > >>>>>> Please copy kvm@vger.kernel.org on kvm issues.
> > >>>>>>
> > >>>>>>> CONFIG_PRINTK_TIME=y
> > >>>>>>
> > >>>>>> Try disabling this as a workaround.
> > >>>>>
> > >>>>> I am in the middle of a bisect run with five builds left to go,
> > >>>>> currently I have:
> > >>>>>
> > >>>>> bad 537b60d17894b7c19a6060feae40299d7109d6e7
> > >>>>> good 93c9d7f60c0cb7715890b1f9e159da6f4d1f5a65
> > >>>>
> > >>>> Bisect is looking good, narrowed it to ten revisions, but I am not
> > >>>> sure to make it to the end today:
> > >>>>
> > >>>> bad cb41838bbc4403f7270a94b93a9a0d9fc9c2e7ea
> > >>>> good 41d59102e146a4423a490b8eca68a5860af4fe1c
> > >>>
> > >>> Bisect points the finger to "x86, ioapic: In mpparse use
> > >>> mp_register_ioapic" (cf7500c0ea133d66f8449d86392d83f840102632), so I
> > >>> am copying Eric. No idea whether this commit is solely to blame or
> > >>> it is a combined interaction with KVM, but I am sure you guys will
> > >>> know.
> > >>>
> > >>> If you want me to test something else please shout.
> > >>
> > >> please try attached patch, to see if it help.
> > >
> > > No luck (no visible difference, no output on VGA or serial console).
> > > (Btw there is a typo in pin_2_irq_leagcy so that you do not push it
> > > directly).
> >
> > can you try current tip with
> > earlyprintk=ttyS0,115200 or console=uart8250,io,0x3f8,115200?
>
> Not the tip but 2.6.35 with earlyprintk=ttyS0,115200:

Correction, crash log was from 2.6.35 plus your smp_mptable_2.patch.

Tvrtko




Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
