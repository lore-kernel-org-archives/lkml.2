Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab0HDEdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:33:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40793 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab0HDEdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:33:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=te8KwE9cuINQ5sthmrzxqvUjl0zdAExb8wAeWZ9eccoazYyPbk9htGIpZHz7rGHo5M
         wEo+cTBiN52U7kU05DogswSofMTfFtI+M6FIRcyatgwGVKOk5wvgstrViV00wFTb3kw8
         YWDB0jt9VjNGO3WhIcmcDcDv3VZOy8XHwhphg=
Date: Tue, 3 Aug 2010 21:32:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.37? ] drivers/input: Use pr_<level>
Message-ID: <20100804043256.GB25256@core.coreip.homeip.net>
References: <1280860850.2963.24.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280860850.2963.24.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, Aug 03, 2010 at 11:40:50AM -0700, Joe Perches wrote:
> Remove prefixes from printks and convert to pr_fmt/pr_<level>.
> 
> Always make output prefix match module name.
> There are some existing uses that do not.  For instance:
> spaceorb used "input: " once, probably a copy/paste error,
> newtonkbd as well.  Synaptics used "serio: ", etc.
> 
> A few miscellaneous typos corrected.
> Converted a few uses of usb macros err to pr_err.
> 
> Compiled x86 only, some files not compile tested
> 

Thanks for doing this, however instead of using pr_xxx() I'd like
drivers that are integrated in driver model (serio, usb, gameport, etc,
i.e. when we have 'struct device' available, exept for psmouse) to use
drv_xxx() instead.

>  
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index 8c32440..e02c2a7 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -23,6 +23,8 @@
>   * Trademarks are the property of their respective owners.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +

That would make synaptics messages to come as "psmouse", right? I think
we shoudl use

	#define pr_fmt(fmt) "synaptics: " fmt

here and in the rest of specialized PS/2 protocol handlers.

Thanks.

-- 
Dmitry
