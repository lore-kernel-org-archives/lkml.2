Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab0GHNDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:03:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab0GHNDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:03:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeremy Kerr <jk@ozlabs.org>
Subject: Re: [PATCH 06/18] spufs: use llseek in all file operations
Date: Thu, 8 Jul 2010 15:02:36 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>, linuxppc-dev@ozlabs.org
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278538820-1392-7-git-send-email-arnd@arndb.de> <1278551728.28333.55.camel@pororo.lan>
In-Reply-To: <1278551728.28333.55.camel@pororo.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007081502.37133.arnd@arndb.de>
X-Provags-ID: V02:K0:rwWSMeXXlCM0Y3uuUGWWic9SrJfdY313gMeaKHAFJxH
 /UTSsN5V/irTA8m59fwh6Pg18/LRM4H0FRlEYl9UvAMsEvoN9V
 UYnv/oRsfU/+VuSXKJlIym7/5280C/pY/lWXsbT034DSCjOr16
 LwxLpedCqVya7/jsszWkFgEB/4PzOCunE8nl25qTkEmjxkTPgD
 3TaXpu7SY81KEeLWMTOaQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 July 2010, Jeremy Kerr wrote:
> > @@ -2151,7 +2166,7 @@ static ssize_t spufs_ibox_info_read(struct file *file, char __user *buf,
> >  static const struct file_operations spufs_ibox_info_fops = {
> >       .open = spufs_info_open,
> >       .read = spufs_ibox_info_read,
> > -     .llseek  = generic_file_llseek,
> > +     .llseek = no_llseek,
> >  };
> > 
> >  static ssize_t __spufs_wbox_info_read(struct spu_context *ctx,
> > @@ -2194,7 +2209,7 @@ static ssize_t spufs_wbox_info_read(struct file *file, char __user *buf,
> >  static const struct file_operations spufs_wbox_info_fops = {
> >       .open = spufs_info_open,
> >       .read = spufs_wbox_info_read,
> > -     .llseek  = generic_file_llseek,
> > +     .llseek = no_llseek,
> >  };
> > 
> 
> Why the change in behaviour for the mbox info files?
> 

D'oh, that wasn't intentional. I guess what must have happened is that I first
added generic_file_llseek to all file_operations in spufs and then made up my
mind and chose what I thought was correct in each case, which broke these.
Of course, these *_info_fops should be seekable.

	Arnd
