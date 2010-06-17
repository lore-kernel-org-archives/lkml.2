Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab0FQMga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 08:36:30 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42765 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0FQMg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 08:36:28 -0400
Date: Thu, 17 Jun 2010 14:36:37 +0200
From: Borislav Petkov <bp@amd64.org>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] get rid of "cut here" from bug output
Message-ID: <20100617123637.GA3492@kryptos.osrc.amd.com>
References: <20100617122156.GK5483@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617122156.GK5483@bicker>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>
Date: Thu, Jun 17, 2010 at 02:21:56PM +0200

> It's annoying to have chunks of dmesg output instead just the whole
> output.  A lot of times the very interesting information is before
> the bug happens.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 3b16cd9..2db532a 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -373,7 +373,7 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
>  {
>  	const char *board;
>  
> -	printk(KERN_WARNING "------------[ cut here ]------------\n");
> +	printk(KERN_WARNING "-----[ paste whole dmesg to bugzilla ]-----\n");

Good idea, we end up requesting the whole dmesg most of the time anyway.
However not all bugs are reported through bugzilla, and, frankly
bugzilla is kinda sucky when it comes down to communicating with the bug
reporter. How about the more generic "send whole dmesg when reporting"
instead?

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
