Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2J3T2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:28:23 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:34554 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab2J3T2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:28:19 -0400
Subject: Re: [PATCH V3 07/10] Secure boot: Add a dummy kernel parameter
 that will switch on Secure Boot mode
From: joeyli <jlee@suse.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg@redhat.com>, tiwai@suse.de
In-Reply-To: <20121030174848.GD6627@hansolo.jdub.homelinux.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <1348152065-31353-8-git-send-email-mjg@redhat.com>
	 <20120920163237.GA11077@kroah.com>
	 <20120925130818.GE18546@hansolo.jdub.homelinux.org>
	 <1351501206.21227.47.camel@linux-s257.site>
	 <20121030174848.GD6627@hansolo.jdub.homelinux.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Oct 2012 03:27:42 +0800
Message-ID: <1351625262.21227.56.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2012-10-30 於 13:48 -0400，Josh Boyer 提到：
> On Mon, Oct 29, 2012 at 05:00:06PM +0800, joeyli wrote:
> > Hi Josh, 
> > Tahashi has a good idea for use strtobool to allow
> > 'secureboot_enable=yes' works. Please consider the following change.
> > 
> > 
> > Thanks a lot!
> > Joey Lee
> > 
> > >From f6841a476f3d332fe7b04cb716e0b518cccd5055 Mon Sep 17 00:00:00 2001
> > From: Lee, Chun-Yi <jlee@suse.com>
> > Date: Mon, 29 Oct 2012 16:36:57 +0800
> > Subject: [PATCH] efi: more user-friendly secureboot_enable parameter
> > 
> > From: Takashi Iwai <tiwai@suse.de>
> > 
> > Use strtobool can allow 'secureboot_enable=yes', it's more user-friendly.
> > 
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  kernel/cred.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/cred.c b/kernel/cred.c
> > index 3f5be65..70897a2 100644
> > --- a/kernel/cred.c
> > +++ b/kernel/cred.c
> > @@ -633,9 +633,10 @@ void __init secureboot_enable()
> >  /* Dummy Secure Boot enable option to fake out UEFI SB=1 */
> >  static int __init secureboot_enable_opt(char *str)
> >  {
> > -	int sb_enable = !!simple_strtol(str, NULL, 0);
> > -	if (sb_enable)
> > +	bool sb_enable;
> > +	if (!strtobool(str, &sb_enable) && sb_enable)
> >  		secureboot_enable();
> > +
> >  	return 1;
> >  }
> >  __setup("secureboot_enable=", secureboot_enable_opt);
> 
> This seems like a good change to me.  If you don't mind, I'll rework the
> existing patch to do this since it hasn't been accepted upstream yet and
> give Takashi-san and you appropriate credit in the commit log.
> 
> josh
> 

Thanks for your review and feel free add to your reworked patch.

Joey Lee


