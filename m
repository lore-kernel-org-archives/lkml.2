Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2BVN5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:57:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43158 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab2BVN5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:57:14 -0500
Date: Wed, 22 Feb 2012 13:57:10 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] regmap: Add support for writing to regmap
	`registers'
Message-ID: <20120222135710.GA10237@opensource.wolfsonmicro.com>
References: <1329914630-17624-1-git-send-email-dp@opensource.wolfsonmicro.com> <20120222125551.GB7340@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222125551.GB7340@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 12:55:52PM +0000, Mark Brown wrote:
> On Wed, Feb 22, 2012 at 12:43:50PM +0000, Dimitris Papastamos wrote:
> > To enable writing to the regmap `registers' file, users will
> > need to modify the source directly and #define REGMAP_ALLOW_WRITE_DEBUGFS.
> > The reason for this is that it is dangerous to expose this
> > functionality in general where clients could potentially be PMICs.
> >
> >  static const struct file_operations regmap_map_fops = {
> >  	.open = regmap_open_file,
> >  	.read = regmap_map_read_file,
> > +#ifdef REGMAP_ALLOW_WRITE_DEBUGFS
> > +	.write = regmap_map_write_file,
> > +#endif
> 
> It's also a bit more idiomatic to have an #else #define function NULL in
> the main ifdef for stuff like this; I'll fix that up as well.

Oops yea, that makes sense.

Thanks,
Dimitris
