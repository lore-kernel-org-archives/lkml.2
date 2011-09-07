Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1IGR6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:58:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36737 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755712Ab1IGR6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:58:03 -0400
Date: Wed, 7 Sep 2011 10:57:56 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: Blockers on IIO usage of regmap.
Message-ID: <20110907175756.GH2906@opensource.wolfsonmicro.com>
References: <4E6600A8.4020101@cam.ac.uk>
 <20110906175435.GA2924@opensource.wolfsonmicro.com>
 <Prayer.1.3.4.1109062213100.4243@hermes-2.csi.cam.ac.uk>
 <4E679770.4090008@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E679770.4090008@cam.ac.uk>
X-Cookie: Cold hands, no gloves.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 05:10:24PM +0100, Jonathan Cameron wrote:

Please fix your mailer to word wrap at less than 80 colums, they're
really quite hard to read as a result of this.

> CS -_______________________-
> TX  Ada0...Ada7  Da0....Da7
> RX XXXXXXXXXXXXXXXXXXXXXXXXX
> 
> Reads are 16 bit with either of the two 8 bit register addresses given the same value
> 
> CS -______________________-_____________________-
> TX  Ada0....Ada7 XXXXXXXX
> RX  XXXXXXXXXXXXXXXXXXXXX  Da0...Da7  Db0....Db7  

> Can interpret Da0...Da7 and Db0....Db7 as single 16 bit register and consider this device
> to just have a weird write method and normal read.  Might be easier.  I'll define Ax<n> as
> 16 bit address for the burst read.

This is starting to seem pretty far off the reservation.

> Perhaps the burst mode thing is better handled by just providing a hook to allow data to be pushed
> into regmap (from 'magic' sources), but the weird write read combination looks to me like something
> that makes sense to have in regmap (be it as another bus variant).

Probably not as a bus, it sounds like a marshalling difference rather
than a bus - the buses should really only understand byte streams.  I
don't have any bright ideas on how to deal with this, it's fairly far
away from the problem space I'm worried about.
