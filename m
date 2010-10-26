Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab0JZPuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:50:39 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62106 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab0JZPuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kmcnP3L0o86lW6TmytIrDtZd1xaAuEcrhiHDqlMaV+njFuC8b956HIr6Y8T8oSRC+U
         OklTBgiWAd06lvqwgtod7D2kqZ/paIM3akRpQ7WdmGy3GfqPZaUVJGVYtS9Ztg0tNCwg
         VmGgtFreLw74iRh+R/6Z+p4YrLCxlAlShjqg8=
Date: Tue, 26 Oct 2010 08:50:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] drivers/input/serio/i8042: Use pr_<level>, pr_fmt.
  Fix dbg and __FILE__ use
Message-ID: <20101026155028.GA13097@core.coreip.homeip.net>
References: <cover.1288059486.git.joe@perches.com>
 <63a8deabb7c8167128d0415998692d15279ecb8c.1288059486.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63a8deabb7c8167128d0415998692d15279ecb8c.1288059486.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Mon, Oct 25, 2010 at 07:44:24PM -0700, Joe Perches wrote:
> Standardized message logging prefixes.
> Removed \n from dbg macro, added \n to each dbg call site.

Did you test it? It looks for call like:

> +             dbg("%02x <- i8042 (flush, %s)\n",
> +                 data, str & I8042_STR_AUXDATA ? "aux" : "kbd");

the result will be:

printk(KERN_DEBUG "i8042: %02x <- i8042 (flush, %s)\n [%d]", ...)

which is not exactly what you want...

>  
> @@ -1268,7 +1262,7 @@ static void __init i8042_register_ports(void)
>  
>  	for (i = 0; i < I8042_NUM_PORTS; i++) {
>  		if (i8042_ports[i].serio) {
> -			printk(KERN_INFO "serio: %s at %#lx,%#lx irq %d\n",
> +			pr_info("%s at %#lx,%#lx irq %d\n",
>  				i8042_ports[i].serio->name,
>  				(unsigned long) I8042_DATA_REG,
>  				(unsigned long) I8042_COMMAND_REG,

Not quite equivalent conversion, right now every port is registered with
message "serio: XXX at YYY". I would be OK with having driver prefix
going in front but I'd like to keep word serio in (like "i8042: serio
XXX at YYY").

Thanks.

-- 
Dmitry
