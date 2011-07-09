Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1GIV1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 17:27:42 -0400
Received: from mta21.charter.net ([216.33.127.81]:38986 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab1GIV1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 17:27:36 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=XYJHFtupD_QA:10 a=B7rPy8_l0dAA:10 a=0xc6OLWX_2kA:10
 a=mi-m0cxnIk0A:10 a=lDGNyK2vIvEA:10 a=kj9zAlcOel0A:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=3irmpWwzXnPmkWqKh2gA:9 a=CjuIK1q_8ugA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Date: Sat, 9 Jul 2011 16:28:44 -0500
From: Greg Dietsche <greg@gregd.org>
To: Jose Alonso <joalonsof@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dell-laptop - using buffer without mutex_lock
Message-ID: <20110709212844.GA13698@farmergreg.com>
Reply-To: Greg Dietsche <greg@gregd.org>
References: <1310162490.9760.5.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310162490.9760.5.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jose,

On Fri, Jul 08, 2011 at 07:01:27PM -0300, Jose Alonso wrote:
> Using buffer->output[1] without mutex_lock()
> 
> --- linux-3.0-rc6/drivers/platform/x86/dell-laptop.c.ORIG
> 2011-07-04 19:56:24.000000000 -0300
> +++ linux-3.0-rc6/drivers/platform/x86/dell-laptop.c    2011-07-08
> 18:27:02.420791868 -0300
> @@ -560,11 +560,11 @@
>         else
>                 dell_send_request(buffer, 0, 1);
> 
> +       ret = buffer->output[1];
> +
>  out:
>         release_buffer();
> -       if (ret)
> -               return ret;
> -       return buffer->output[1];
> +       return ret;
>  }
> 
>  static const struct backlight_ops dell_ops = {
> 
> 
> --

You should run this patch through scripts/checkpatch.pl as it
reports a few style issues for your patch including a missing
signed-off-by line and some spaces that should be converted to tabs.

Greg

