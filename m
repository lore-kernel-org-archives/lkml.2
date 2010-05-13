Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab0EMHwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:52:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48225 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab0EMHwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YCpQC6eP1IlkYG2k+31yWO1DVaUh7G2nyWtkJqEevgBJZcQxynOuWiVEf33UwUcjcf
         luvBUmlebDgnToSt6dv+coJAgsQC9f8Bqq59XDkC9/3JGYzytZgYrltxyWSlhjmncbrS
         bsb51bXG8K8S9565q4NIOa4z5IY+pJDyAnw64=
Date: Thu, 13 May 2010 00:52:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: mjg@redhat.com, mzxreary@0pointer.de, rpurdie@linux.intel.com,
       jlee@novell.com, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 4/4] msi-laptop: Add i8042 filter to sync sw state with
 BIOS when function key pressed
Message-ID: <20100513075217.GC30110@core.coreip.homeip.net>
References: <20100512141149.GB20564@kroah.com>
 <1273683490-27090-4-git-send-email-gregkh@suse.de>
 <20100512173359.GA16431@core.coreip.homeip.net>
 <20100512185647.GC28990@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512185647.GC28990@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 11:56:47AM -0700, Greg KH wrote:
>  static int __init msi_init(void)
> @@ -819,6 +875,7 @@ static void __exit msi_cleanup(void)
>  	platform_driver_unregister(&msipf_driver);
>  	backlight_device_unregister(msibl_device);
>  
> +	i8042_remove_filter(msi_laptop_i8042_filter);

You also need cancel_delayed_work_sync() here. Sorry for not noticing
this before.

>  	rfkill_cleanup();
>  
>  	/* Enable automatic brightness control again */

-- 
Dmitry
