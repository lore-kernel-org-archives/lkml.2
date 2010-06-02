Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab0FBVej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:34:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42421 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632Ab0FBVei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:34:38 -0400
Date: Wed, 2 Jun 2010 22:34:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Islam Amer <pharon@gmail.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
       akpm@linux-foundation.org, Rezwanul_Kabir@dell.com
Subject: Re: Dell Studio 1555 eject key does not work ( small patch to fix
	included )
Message-ID: <20100602213429.GA14866@srcf.ucam.org>
References: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rez,

Any thoughts on this?

On Thu, Jun 03, 2010 at 01:14:09AM +0400, Islam Amer wrote
> Hello,
> 
> Pressing the eject key on my Dell Studio 1555 does not work and dmesg produces
> this message :
> dell-wmi: Unknown key 0 pressed
> 
> Adding a debugging printk in dell-wmi.c after line 222 like this :
> 
> printk(KERN_INFO "dell:wmi 0x%x , 0x%x \n", buffer_entry[1], buffer_entry[2]);
> 
> dmesg now shows :
> 
> dell:wmi 0x0 , 0xe009
> dell-wmi: Unknown key 0 pressed
> 
> So for some reason buffer_entry[1] is used although it is empty.
> 
> Falling back to buffer_entry[2] in case buffer_entry[1] is 0x0 makes
> the button work.
> 
> I suspect it might be better to fix the "dell_new_hk_type" logic though
> 
> I had submitted this as
> https://bugzilla.kernel.org/show_bug.cgi?id=16075 but repeating the
> information and patch
> here as per Andrew Morton's suggestion.
> 
> 
> Thanks.
> 
> --- linux-sidux-2.6-2.6.34/drivers/platform/x86/dell-wmi.c.orig	2010-06-03
> 01:02:17.418824168 +0400
> +++ linux-sidux-2.6-2.6.34/drivers/platform/x86/dell-wmi.c	2010-06-03
> 01:01:40.641833249 +0400
> @@ -221,7 +221,7 @@ static void dell_wmi_notify(u32 value, v
>  			return;
>  		}
> 
> -		if (dell_new_hk_type)
> +		if (dell_new_hk_type || buffer_entry[1] == 0x0)
>  			reported_key = (int)buffer_entry[2];
>  		else
>  			reported_key = (int)buffer_entry[1] & 0xffff;
> 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
