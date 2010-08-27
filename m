Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0H0GR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 02:17:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46739 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab0H0GR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 02:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=kv6l4tCKwUdJv6n5z5pGv5GwPSWwzEfOIrv32bA7uwu5Lu6QwpAAd7rDX1h2fsMJIf
         68MARqMEaFsXBI144MOUvTaZiMY44vUZYoNCsv0uP79nrJICrjI4huahKpGrNDma7mxm
         BevGJaK9C57UsVEmh/vEAbLc9apgxGy3V3kKU=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] UCB1400: Pass ucb1400-gpio data through ac97 bus
Date: Fri, 27 Aug 2010 08:17:12 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, dtor@mail.ru,
        adobriyan@gmail.com, tj@kernel.org, Eric Miao <eric.y.miao@gmail.com>
References: <1281327394-6716-1-git-send-email-marek.vasut@gmail.com> <201008270750.38118.marek.vasut@gmail.com> <20100826231419.fff73529.akpm@linux-foundation.org>
In-Reply-To: <20100826231419.fff73529.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008270817.12179.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Pá 27. srpna 2010 08:14:19 Andrew Morton napsal(a):
> On Fri, 27 Aug 2010 07:50:37 +0200 Marek Vasut <marek.vasut@gmail.com> wrote:
> > Dne P__ 27. srpna 2010 01:07:36 Andrew Morton napsal(a):
> > > On Mon, 9 Aug 2010 06:43:14 +0200
> > > 
> > > Marek Vasut <marek.vasut@gmail.com> wrote:
> > > > Dne Po 9. srpna 2010 06:16:34 Marek Vasut napsal(a):
> > > > > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> > > 
> > > Please don't send unchangelogged patches.
> > 
> > Unchangelogged? What do you mean ?
> 
> Patches which don't have any changelog.  This patch was sent with no
> covering explanation.
> 
> > > The title tells us what the patch does but provides no hint as to why
> > > it does it.
> 
> As I indicated.  The title tells us what the patch does but didn't tell
> us *why* it does it.  Apparently it is preparatory work for some other
> patch?

Ah, stupid me, I see, just checked the patch.

The point is, some time ago (about one year ago ... but certainly after the 
ucb1400 was split into multiple chunks and ucb1400-gpio was added), there was no 
way to pass platform data to devices attached to ac97 bus. That's why there was 
that function "ucb1400_gpio_set_data()".

That's not true anymore, we can just pass the pdata through the ac97 bus to the 
mfd part of ucb1400 driver (ucb1400-core), which then registers the gpio part of 
ucb1400. This patch actually makes it possible to pass the pdata through the 
ac97 bus instead.

> 
> > > > > ---
> > > > > 
> > > > >  drivers/gpio/ucb1400_gpio.c |   19 ++++++-------------
> > > > >  drivers/mfd/ucb1400_core.c  |    5 +++++
> > > > >  include/linux/ucb1400.h     |   19 ++++++-------------
> > > > >  3 files changed, 17 insertions(+), 26 deletions(-)
> > > > 
> > > > Ah right, guys, if possible, let this go through Eric Miao's tree (as
> > > > I have changes that depend on this). Thanks!
> > > 
> > > He's probably unaware of the patch.  Let's cc him.
> > 
> > I have this one in my tree and I sent it to Eric as a part of larger
> > patchset.
> 
> Recently, I assume - it wasn't in this morning's linux-next.

It was sent to linux-arm-kernel as most of the patches were for linux-arm . I 
sent this one especially on it's own to reduce useless traffic. I'll remember 
this next time.

Cheers
