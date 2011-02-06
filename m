Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1BFU7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:59:20 -0500
Received: from lobo.ruivo.org ([173.14.175.98]:36245 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab1BFU7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:59:19 -0500
Date: Sun, 6 Feb 2011 12:23:17 -0500
From: Aristeu Rozanski <aris@cathedrallabs.org>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH] uinput strnlen bugfix
Message-ID: <20110206172317.GI22170@cathedrallabs.org>
References: <AANLkTi=vBv_a+X3MrgyDevss9H92vBJ51eON_qyMJW4=@mail.gmail.com>
 <20110206165524.GG22170@cathedrallabs.org>
 <AANLkTimZq3-zuiA940dK7AmszBW-TEHP0JHz7FGHSmgu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimZq3-zuiA940dK7AmszBW-TEHP0JHz7FGHSmgu@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 05:57:19PM +0100, David Herrmann wrote:
> On Sun, Feb 6, 2011 at 5:55 PM, Aristeu Rozanski <aris@cathedrallabs.org> wrote:
> > and where's the patch? :^)
> >
> > --
> > Aristeu
> >
> 
> ah, embarrasing.., sorry.
> I attached the patchfile.
> 
> David

> --- old/drivers/input/misc/uinput.c	2011-02-06 17:40:24.951454656 +0100
> +++ new/drivers/input/misc/uinput.c	2011-02-06 17:41:16.747454654 +0100
> @@ -372,8 +372,8 @@
>  
>  	udev->ff_effects_max = user_dev->ff_effects_max;
>  
> -	size = strnlen(user_dev->name, UINPUT_MAX_NAME_SIZE) + 1;
> -	if (!size) {
> +	size = strnlen(user_dev->name, UINPUT_MAX_NAME_SIZE);
> +	if (!size++) {
>  		retval = -EINVAL;
>  		goto exit;
>  	}
Acked-by: Aristeu Rozanski <aris@ruivo.org>

-- 
Aristeu

