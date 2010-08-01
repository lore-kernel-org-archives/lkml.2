Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0HAKuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 06:50:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56198 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab0HAKuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 06:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=mUaWc4Tmx5Xee+tKUVi2j0togv0Npo3p0onwYrDnWqH7egG6fJPStGQxDj6E+zLYlc
         VO5wcTGy1SlIuvxW0FsM77OHuTCGoDXJLFtSTc+l5ou/JHC6i1GNFkE0HTGP7bVjW4mK
         8yWfB1LcPYnECZ859RllaYJ2+2LUC7iqbuHbU=
Date: Sun, 1 Aug 2010 12:49:41 +0200
From: Dan Carpenter <error27@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Li Yang <leoli@freescale.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>, linux-usb@vger.kernel.org,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] usb: fsl_udc_core: check return value of
	create_proc_read_entry()
Message-ID: <20100801104941.GI26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Vasiliy Kulikov <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org, Li Yang <leoli@freescale.com>,
	David Brownell <dbrownell@users.sourceforge.net>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Dinh Nguyen <Dinh.Nguyen@freescale.com>,
	Anton Vorontsov <avorontsov@ru.mvista.com>,
	linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
	linux-kernel@vger.kernel.org
References: <1280597900-8405-1-git-send-email-segooon@gmail.com> <20100731191743.GF26313@bicker> <20100801061934.GB2650@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801061934.GB2650@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 10:19:34AM +0400, Vasiliy Kulikov wrote:
> On Sat, Jul 31, 2010 at 21:17 +0200, Dan Carpenter wrote:
> > On Sat, Jul 31, 2010 at 09:38:20PM +0400, Kulikov Vasiliy wrote:
> > > create_proc_read_entry() may fail, if so return -ENOMEM.
> > > 
> > 
> > It can fail, but also we return NULL if procfs is disabled.  I haven't
> > looked at it very carefully, would this patch break the module if procfs
> > was disabled?
> Probably you are right, but many drivers in tree compare return value
> with NULL. Some of them interpret this as error, some of them simply
> call pr_warn("Hmm, I cannot create file in proc, strange..."). Maybe
> there is more simplier way to check it without #ifdefs?
> 

If the allocation fails, there is already a warning so no need to add
another.

These things are one time allocation, normally near boot up when memory
is plentifull.  The places that do check should be audited to make sure
there isn't an unneeded dependency on PROC_FS.  I would just leave the
rest.

regards,
dan carpenter

