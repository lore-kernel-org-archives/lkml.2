Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab0GHL5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 07:57:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58332 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0GHL5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 07:57:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/7] block: push down BKL into .locked_ioctl
Date: Thu, 8 Jul 2010 13:56:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <1278514289-21054-3-git-send-email-arnd@arndb.de> <4C358DFF.9090401@kernel.dk>
In-Reply-To: <4C358DFF.9090401@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007081356.38771.arnd@arndb.de>
X-Provags-ID: V02:K0:uBmncqxokNMmoGTuiFG4zsy4WP0rOFbFq4J+U6oaroP
 lq3NIeBUpwnu2BHO3RR+b6WvVkXsWNFb5d5Euo84cbKifXjtsH
 t0NX6pROFZ94t2NUTs3tUU5YUMIZTjaxKmwI/OnVwnTdfLQBjF
 Y4ME0fOxzdxuhPRyQB9fgwEjFUoX7+ngSxAWNlJwCnm7UfKs7M
 lZSGfK5Mbqg6RS4A4WcTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 July 2010, Jens Axboe wrote:
> On 2010-07-07 16:51, Arnd Bergmann wrote:
> > As a preparation for the removal of the big kernel
> > lock in the block layer, this removes the BKL
> > from the common ioctl handling code, moving it
> > into every single driver still using it.
> >
> > diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
> > index ad3ddef..fc593fb 100644
> > --- a/drivers/message/i2o/i2o_block.c
> > +++ b/drivers/message/i2o/i2o_block.c
> > @@ -941,8 +930,7 @@ static const struct block_device_operations i2o_block_fops = {
> >       .owner = THIS_MODULE,
> >       .open = i2o_block_open,
> >       .release = i2o_block_release,
> > -     .ioctl = i2o_block_ioctl,
> > -     .compat_ioctl = i2o_block_ioctl,
> > +     .locked_ioctl = i2o_block_ioctl,
> >       .getgeo = i2o_block_getgeo,
> >       .media_changed = i2o_block_media_changed
> >  };
> 
> Hmm?

This is the result of a git-rebase gone wrong on my side. The entire first
patch gets reverted as part of the second patch, which is not what I indented.

Sorry about the confusion. Please just apply patch 1/7 again on top of the series
to fix it up, or fold that patch into this one (block: push down BKL into
.locked_ioctl) to make it not change i2o_block.c any more.

	Arnd
