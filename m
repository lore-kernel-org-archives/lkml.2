Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab0HCQAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:00:06 -0400
Received: from mx3.sophos.com ([74.202.89.160]:43359 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab0HCQAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:00:04 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Avi Kivity <avi@redhat.com>
Subject: Re: 2.6.35 hangs on early boot in KVM
Date: Tue, 3 Aug 2010 16:59:58 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <201008031028.57263.tvrtko.ursulin@sophos.com> <201008031557.04613.tvrtko.ursulin@sophos.com> <201008031617.21418.tvrtko.ursulin@sophos.com>
In-Reply-To: <201008031617.21418.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Message-ID: <201008031659.58736.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 03/08/2010 17:00:00,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 03/08/2010 17:00:00,
	Serialize complete at 03/08/2010 17:00:00
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 Aug 2010 16:17:20 Tvrtko Ursulin wrote:
> On Tuesday 03 Aug 2010 15:57:03 Tvrtko Ursulin wrote:
> > On Tuesday 03 Aug 2010 15:51:08 Avi Kivity wrote:
> > >   On 08/03/2010 12:28 PM, Tvrtko Ursulin wrote:
> > > > I have basically built 2.6.35 with make oldconfig from a working
> > > > 2.6.34. Latter works fine in kvm while 2.6.35 hangs very early. I see
> > > > nothing after grub (have early printk and verbose bootup enabled),
> > > > just a blinking VGA cursor and CPU at 100%.
> > >
> > > Please copy kvm@vger.kernel.org on kvm issues.
> > >
> > > > CONFIG_PRINTK_TIME=y
> > >
> > > Try disabling this as a workaround.
> >
> > I am in the middle of a bisect run with five builds left to go, currently
> > I have:
> >
> > bad 537b60d17894b7c19a6060feae40299d7109d6e7
> > good 93c9d7f60c0cb7715890b1f9e159da6f4d1f5a65
>
> Bisect is looking good, narrowed it to ten revisions, but I am not sure to
> make it to the end today:
>
> bad cb41838bbc4403f7270a94b93a9a0d9fc9c2e7ea
> good 41d59102e146a4423a490b8eca68a5860af4fe1c

Bisect points the finger to "x86, ioapic: In mpparse use mp_register_ioapic"
(cf7500c0ea133d66f8449d86392d83f840102632), so I am copying Eric. No idea
whether this commit is solely to blame or it is a combined interaction with
KVM, but I am sure you guys will know.

If you want me to test something else please shout.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
