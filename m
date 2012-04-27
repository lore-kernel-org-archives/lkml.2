Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab2D0CkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 22:40:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55818 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110Ab2D0CkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 22:40:18 -0400
Date: Thu, 26 Apr 2012 19:40:12 -0700
From: Gerard Snitselaar <dev@snitselaar.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, ldewangan@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd/tps65910: fix section mismatch in linux-next
Message-ID: <20120427024012.GA9480@cantor.Home>
Reply-To: Gerard Snitselaar <dev@snitselaar.org>
Mail-Followup-To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	sameo@linux.intel.com, ldewangan@nvidia.com,
	linux-kernel@vger.kernel.org
References: <1335280435-2457-1-git-send-email-dev@snitselaar.org>
 <20120426213449.GB9415@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120426213449.GB9415@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Apr 26 12, Mark Brown wrote:
> On Tue, Apr 24, 2012 at 08:13:55AM -0700, Gerard Snitselaar wrote:
> 
> > -static int tps65910_i2c_probe(struct i2c_client *i2c,
> > +static int __init tps65910_i2c_probe(struct i2c_client *i2c,
> >  			    const struct i2c_device_id *id)
> 
> I sent a separate fix for this earlier on - __init is the wrong
> annotation here, a device init function should be marked __devinit.

I missed your patch when I did a search initially. Does it also change the annotation of tps65910_sleepinit() to __devinit ? If all devices are supposed to have their init functions annotated __devinit is the comment in correct in init.h which says the __dev* annotations are used for HOTPLUG? Is this power management chip hotpluggable?
