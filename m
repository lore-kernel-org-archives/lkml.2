Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0JASAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:00:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:48268 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab0JASAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:00:00 -0400
Subject: Re: Introduce support for little endian PowerPC
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1285935283.2463.78.camel@pasglop>
Date: Fri, 1 Oct 2010 12:59:31 -0500
Cc: Josh Boyer <jwboyer@gmail.com>, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BBD78246-343E-4A96-9E55-3E40AD628C0B@kernel.crashing.org>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com> <2C5357FA-F87F-457E-B5C1-0DCC5A842DE7@kernel.crashing.org> <AANLkTinSDMvBb7rnnfwYMkEVOgDUqRetZg86rh-UmSAg@mail.gmail.com> <1285935283.2463.78.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 1, 2010, at 7:14 AM, Benjamin Herrenschmidt wrote:

> On Fri, 2010-10-01 at 07:30 -0400, Josh Boyer wrote:
>> 
>>> From a community aspect is anyone actually going to use this?  Is
>> this going to be the equivalent of voyager on x86?  I've got nothing
>> against some of the endian clean ups this introduces.  However the
>> changes to misc_32.S are a bit ugly from a readability point of view.
>> Just seems like this is likely to bit-rot pretty quickly.
>> 
>> I'm with Kumar on this one.  Why would we want to support this?  I
>> can't say I would be very willing to help anyone run in LE mode, let
>> alone have it randomly selectable. 
> 
> There's some good reasons on the field ... sadly.
> 
> At this stage this is mostly an experiment, which went pretty well in
> the sense that it's actually quite easy and a lot of the "fixes" are
> actually reasonable cleanups to carry.
> 
> Now, the main reasons in practice are anything touching graphics.
> 
> There's quite a few IP cores out there for SoCs that don't have HW
> swappers, and -tons- of more or less ugly code that can't deal with non
> native pixel ordering (hell, even Xorg isn't good at it, we really only
> support cards that have HW swappers today).
> 
> There's an even bigger pile of application code that deals with graphics
> without any regard for endianness and is essentially unfixable.
> 
> So it becomes a matter of potential customers that will take it if it
> does LE and won't if it doesn't ...
> 
> Now, I don't have a problem supporting that as the maintainer, as I
> said, from a kernel standpoint, it's all quite easy to deal with. Some
> of the most gory aspects in misc_32.S could probably be done in a way
> that is slightly more readable, but the approach is actually good, I
> think, to have macros to represent the high/low parts of register pairs.
> 
> So at this stage, I'd say, let's not dismiss it just because we all come
> from a long education of hating LE for the sake of it :-)
> 
> It makes -some- sense, even if it's not necessarily on the markets
> targeted by FSL today for example. At least from the kernel POV, it
> doesn't seem to me to be a significant support burden at all.
> 
> Cheers,
> Ben.

I'm not against it, and I agree some of the patches seem like good clean up.  I'm concerned about this bit rotting pretty quickly.

- k

