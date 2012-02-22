Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2BVOAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:00:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43184 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615Ab2BVOAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:00:49 -0500
Date: Wed, 22 Feb 2012 14:00:47 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Append device name in the root debugfs dir
Message-ID: <20120222140047.GB10237@opensource.wolfsonmicro.com>
References: <1329918783-22610-1-git-send-email-dp@opensource.wolfsonmicro.com> <20120222135709.GA14766@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222135709.GA14766@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 01:57:09PM +0000, Mark Brown wrote:
> On Wed, Feb 22, 2012 at 01:53:03PM +0000, Dimitris Papastamos wrote:
> 
> >  void regmap_debugfs_init(struct regmap *map)
> >  {
> > -	map->debugfs = debugfs_create_dir(dev_name(map->dev),
> > -					  regmap_debugfs_root);
> > +	char name[64];
> 
> That's a magic number, where did it come from?

I can try to use something like NAME_MAX I suppose.

> > +
> > +	snprintf(name, sizeof(name), "%s-%s",
> > +		 dev_name(map->dev), map->dev->driver->name);
> > +
> > +	map->debugfs = debugfs_create_dir(name, regmap_debugfs_root);
> 
> No, keep the directory name the same and add a new file.

Right, that was what I had initially implemented but seemed a bit of
overkill, but yea I can do that.

Thanks,
Dimitris
