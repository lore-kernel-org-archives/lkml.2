Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0LHTRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:17:45 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:33799 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab0LHTRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:17:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Vcr1NKfBydM+1vkX7bbrzMGZpLDANU6Vr6afg4DO1t2BY/Yd2Bcdz/PbLYM50kAYLL
         GFHUVEMDOL9fo8Yl6NKBAjMEhwyLDGflIfmttPJkfh1yBswDvpx/GQAeisHTyJfm1efg
         RzGO60aMS3jn/UQOLx7Hvs6TNVNlf6i4loC4o=
Date: Wed, 8 Dec 2010 21:17:36 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Hanno =?iso-8859-1?Q?B=F6ck?= <hanno@hboeck.de>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] acpi: const-ify functions
Message-ID: <20101208191736.GA6694@core2.telecom.by>
References: <201012081925.10292.hanno@hboeck.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201012081925.10292.hanno@hboeck.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 07:25:10PM +0100, Hanno Böck wrote:
> Will const a couple of functions and variables. This is extracted
> from grsecurity (with only a slight modification to limit a line
> to 80 chars).

Why don't they do it themselves? :^)

> Patch is against linux-acpi-2.6 git.
> 
> Similar patches have been sent in the past but not applied,
> supposedly because they weren't sent to subsystem maintainers.
> (I may continue to send similar extracts to other subsystems)
> 
> ---
> Signed-off-by: Hanno Boeck <hanno@hboeck.de>

Signed-off-by should be before --- -- it must make into changelog.

> diff -Naurp linux-acpi-1//drivers/acpi/battery.c linux-acpi-2/drivers/acpi/battery.c
> --- linux-acpi-1//drivers/acpi/battery.c	2010-12-08 18:42:26.187000005 +0100
> +++ linux-acpi-2/drivers/acpi/battery.c	2010-12-08 18:42:53.595000204 +0100
> @@ -851,7 +851,7 @@ DECLARE_FILE_FUNCTIONS(alarm);
>  	}
>  
>  static struct battery_file {
> -	struct file_operations ops;
> +	const struct file_operations ops;

Whoa, does this work?

>  	mode_t mode;
>  	const char *name;
>  } acpi_battery_file[] = {

It maybe better to call proc_create_date() by hand (and even handle
errors gracefully?
