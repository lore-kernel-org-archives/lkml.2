Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966615Ab2EOTu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:50:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965947Ab2EOTu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:50:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 03/03] ARM: Undelete KZM9D mach-type
Date: Tue, 15 May 2012 19:50:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        horms@verge.net.au, olof@lixom.net,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
References: <20120514105424.8596.38355.sendpatchset@w520> <201205150832.10069.arnd@arndb.de> <CANqRtoTnLGj2YmOFRSMn09LXsk_wmwWgZg6VQxh55EtKOEEbWQ@mail.gmail.com>
In-Reply-To: <CANqRtoTnLGj2YmOFRSMn09LXsk_wmwWgZg6VQxh55EtKOEEbWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205151950.51941.arnd@arndb.de>
X-Provags-ID: V02:K0:ZPJZ/nshBWGh4sHn93gPW5YJAcOplXHfNECp89WVuCF
 XTTUf4zc9/7EQfAvbvEoLbTOKqLBSzDjcdqjajCzyTgFCt8AkG
 jxiryVYxofD7Myk6MRmpu+FQ2txUMNzww1SDY5EEay7PCCD8z6
 iXxvFsbeBAsiXX/93KNtd0cTzL/lmxE6ZOi6vivVJEmqRJi6f3
 UtkVB/OWvpjWuLnfVtXZLxI569FhhRXBHQUjwSwbF3Ys7sy9xa
 WTh040rxE19hGcvxam86ib3RWuiAznQo5GpQ4473GcJtvp6GTA
 DjxK6QLEREf9IzQI1NYlIZ9PWrKxAK4CFSWbi/5DY1h48p/TqJ
 rCHTHvEWf8AKoSQ8Phqk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2012, Magnus Damm wrote:
> On Tue, May 15, 2012 at 5:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 14 May 2012, Magnus Damm wrote:
> >> On Tue, May 15, 2012 at 6:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > On Monday 14 May 2012, Magnus Damm wrote:

> > This is different from what most other maintainers are doing: Generally
> > the migration to DT is done in small changes over multiple releases,
> > adding stuff to the dts file when it gets removed from the static
> > initialization. This is necessary in particular because there are no
> > bindings for DMA controllers yet, and until recently we had no
> > general bindings  for pinctrl and clock at all, so nobody could
> > put those into the device tree.
> 
> I understand. I guess in the EMEV2 case we can simply just add the
> drivers with DT support upstream. We have the luxury of no DMA code
> upstream for EMEV2 so I hope we can get it right directly. Perhaps I'm
> aiming too high. =)

It can work, the spear platforms have recently been converted from
no DT support at all to completely being DT based, and the cortex-a9
based spear13xx platform that was added now was DT-only from the
start.

> > We still see the DT bindings as work in progress at this moment,
> > at least on most platforms, so we don't yet expect them to be final.
> > Once we get to that point, the plan is that the DT maintainers
> > make a separate package with dts files outside of the kernel and
> > try much harder to keep that stable across kernel versions.
> 
> I see. I am a bit concerned with customers using DT in platform with
> long support cycles like for automotive purpose for instance. As you
> can tell by me being cautious when introducing DT support I'd really
> like to avoid getting DT support code for the kernel written out of
> tree and shipped to customers. Perhaps there is not so much I can do
> about that regardless, but if possible I'd like to make it possible
> for the "out of tree people" to still do their own thing, but with
> platform devices instead of DT because we don't have the same binary
> compatibility issue there.

ok, I see.

> > I'll leave that up to you. Please make KZM9D use DT_MACHINE_START,
> > and do what fits your needs best for the generic EMEV2 machine
> > description. One possible alternative that I can see here is to
> > move the KZM9D support into the main EMEV2 file but keep the
> > specific "compatible" property for that, to ensure that we don't
> > get other boards to rely on generic EMEV2 implementation specifics
> > that you don't want to expose in DT yet.
> 
> Ok. I will convert the code to use DT_MACHINE_START. Thanks!
> 
> So do you have any preference how to deal with SMP and the iotable?
> Are you ok with the ioremap vs iotable code as-is in V2? I assume so!

Yes, that looks all good.

> > It's definitely technically possible to do it, but it could either be
> > that nobody has bothered to do the implementation, or that we had good
> > reasons against it and decided not to allow this.
> 
> Yeah, it seems like a rather small piece of code that would help our
> situation quite a bit. So I imagine that others may be in a similar
> position which makes mei wonder why it hasn't been done already.

It also came up in the discussion about making multiplatform kernels
DT-only, where someone asked about the same thing. So now that Grant
has clarified that it's actually what we plan to do anyway, I guess
you could start working on it if you're interested.

	Arnd
