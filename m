Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965183Ab2J3RtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:49:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965014Ab2J3Rs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:48:57 -0400
Date: Tue, 30 Oct 2012 13:48:48 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: joeyli <jlee@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg@redhat.com>, tiwai@suse.de
Subject: Re: [PATCH V3 07/10] Secure boot: Add a dummy kernel parameter that
 will switch on Secure Boot mode
Message-ID: <20121030174848.GD6627@hansolo.jdub.homelinux.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <1348152065-31353-8-git-send-email-mjg@redhat.com>
 <20120920163237.GA11077@kroah.com>
 <20120925130818.GE18546@hansolo.jdub.homelinux.org>
 <1351501206.21227.47.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351501206.21227.47.camel@linux-s257.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 05:00:06PM +0800, joeyli wrote:
> Hi Josh, 
> Tahashi has a good idea for use strtobool to allow
> 'secureboot_enable=yes' works. Please consider the following change.
> 
> 
> Thanks a lot!
> Joey Lee
> 
> >From f6841a476f3d332fe7b04cb716e0b518cccd5055 Mon Sep 17 00:00:00 2001
> From: Lee, Chun-Yi <jlee@suse.com>
> Date: Mon, 29 Oct 2012 16:36:57 +0800
> Subject: [PATCH] efi: more user-friendly secureboot_enable parameter
> 
> From: Takashi Iwai <tiwai@suse.de>
> 
> Use strtobool can allow 'secureboot_enable=yes', it's more user-friendly.
> 
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  kernel/cred.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 3f5be65..70897a2 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -633,9 +633,10 @@ void __init secureboot_enable()
>  /* Dummy Secure Boot enable option to fake out UEFI SB=1 */
>  static int __init secureboot_enable_opt(char *str)
>  {
> -	int sb_enable = !!simple_strtol(str, NULL, 0);
> -	if (sb_enable)
> +	bool sb_enable;
> +	if (!strtobool(str, &sb_enable) && sb_enable)
>  		secureboot_enable();
> +
>  	return 1;
>  }
>  __setup("secureboot_enable=", secureboot_enable_opt);

This seems like a good change to me.  If you don't mind, I'll rework the
existing patch to do this since it hasn't been accepted upstream yet and
give Takashi-san and you appropriate credit in the commit log.

josh
