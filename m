Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0CTQYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 12:24:38 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62620 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab0CTQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 12:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=NCGBZVqtBX2hpog9e1qV+F074XsNzsdHBY8fQyJc7b3s3nvpMJYSXajaOPlRDsSuVh
         qWaCFmrghFMrld6Kr2m99wArQdRo/VQ2UuHr0YDaCgGBhLbYMbNP789rg1+dF50AI0Oj
         w//Ssk49p018M1a4h2rV/PFzkpNqbfXpLrgZY=
Date: Sat, 20 Mar 2010 19:24:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       harvey.harrison@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: reg.c Coding style fixes.
Message-ID: <20100320162426.GB28881@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
	penberg@cs.helsinki.fi, pavel@ucw.cz, harvey.harrison@gmail.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1269098051-6594-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269098051-6594-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 04:14:11PM +0100, Lars Lindley wrote:
> I fixed all problems reported by checkpatch.pl except some
> (a lot of) long lines and some printk:s.
> I removed "commented away" code and version comments.
> 

	[snip]

> -		msleep(10); // Modify 20051221.1.b
> -		Wb35Reg_WriteSync( pHwData, 0x03d4, 0xb8 );// REG_ON RF_RSTN on, and
> -		msleep(10); // Modify 20051221.1.b

	You removed this msleep().

> -
> +	if (pHwData->phy_type <= RF_MAXIM_V1)
> +		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xffffff38);
> +	else {
> +		Wb35Reg_WriteSync(pHwData, 0x03f4, 0xFF5807FF);
> +		Wb35Reg_WriteSync(pHwData, 0x03d4, 0x80); /* regulator on only */
> +		msleep(10);
> +		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xb8); /* REG_ON RF_RSTN on, and msleep(10); */

In the new version it's commented out.                                             ^^^^^^^^^^^^

I used a program to try verify that only white space changed.
http://lkml.indiana.edu/hypermail/linux/kernel/1003.1/01012.html

Then when it failed I grovelled through to find what changed.

Actually my tool complained about removed parenthesis as well.  I think 
this patch only removes one set of parenthesis.  Please don't do that.  
With a patch this size, it's nice to be able to use tools to verify that 
it doesn't change anything, instead of checking it by hand. Tabs, spaces
and newlines only, please.

Obviously in the next patch you can send the one liner that remove the
parenthesis.  We can eyeball one liners quite quickly.

regards,
dan carpenter
