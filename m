Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0KGU7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 15:59:40 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:45176 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752603Ab0KGU7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 15:59:38 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 1/9] Add yaffs Kconfig and Makefile
Date: Mon, 8 Nov 2010 09:59:35 +1300
User-Agent: KMail/1.9.10
Cc: cdhmanning@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-2-git-send-email-cdhmanning@gmail.com> <10039.1289008258@localhost>
In-Reply-To: <10039.1289008258@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011080959.35220.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 November 2010 14:50:58 Valdis.Kletnieks@vt.edu wrote:
> On Thu, 04 Nov 2010 05:53:16 +1300, cdhmanning@gmail.com said:
> > From: Charles Manning <cdhmanning@gmail.com>
> >
> > Adding yaffs2 file system.
> >
> > +config YAFFS_DOES_ECC
> > +	bool "Lets Yaffs do its own ECC"
> > +	depends on YAFFS_FS && YAFFS_YAFFS1 && !YAFFS_9BYTE_TAGS
> > +	default n
> > +	help
> > +	  This enables Yaffs to use its own ECC functions instead of using
> > +	  the ones from the generic MTD-NAND driver.
> > +
> > +	  If unsure, say N.
>
> Why does this exist at all? Are there any cases where the Yaffs ECC is
> better than the MTD versions? If so, why aren't we fixing the MTD versions?

Good point. I'll look into this further.

This came into existence when mtd had various issues that were easier to 
address in yaffs space than mtd space.

>
> > +config YAFFS_DISABLE_TAGS_ECC
> > +	bool "Disable YAFFS from doing ECC on tags by default"
> > +	depends on YAFFS_FS && YAFFS_YAFFS2
> > +	default n
> > +	help
> > +	  This defaults Yaffs to using its own ECC calculations on tags instead
> > of +	  just relying on the MTD.
> > +	  This behavior can also be overridden with tags_ecc_on and
> > +	  tags_ecc_off mount options.
> > +
> > +	  If unsure, say N.
>
> Similarly here - why would somebody want this?

This is quite a different issue.
Most hamming code ecc schemes only do ecc on the data area and not on the 
oob/spare area where yaffs stores tags,but some do.

This config controls which way the ECC on the tags is handled.

>
> > +config YAFFS_EMPTY_LOST_AND_FOUND
> > +	bool "Empty lost and found on boot"
> > +	depends on YAFFS_FS
> > +	default n
> > +	help
> > +	  If this is enabled then the contents of lost and found is
> > +	  automatically dumped at mount.
>
> Wow.. Just.. wow.   

What does that mean?

> Under what use case is this a good idea for a config 
> option as opposed to a mount option?

It is both.

Providing a config option provides the system integrator with flexibility in 
how they set things up.

-- Charles
