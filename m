Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2AZXbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:31:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab2AZXbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:31:50 -0500
Date: Thu, 26 Jan 2012 15:31:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] thermal_sys: Remove obfuscating used-once macros
Message-Id: <20120126153149.c1d9044f.akpm@linux-foundation.org>
In-Reply-To: <af64842337355cb336a98563bba79007709a6d00.1327447797.git.joe@perches.com>
References: <cover.1327447797.git.joe@perches.com>
	<af64842337355cb336a98563bba79007709a6d00.1327447797.git.joe@perches.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012 15:35:36 -0800
Joe Perches <joe@perches.com> wrote:

> These don't add any value as they are used
> only once and the surrounding code uses similar
> variable.

And they were buggy if passed an expression-with-side-effects.  Geeze
we make this mistake often, and it's C programming 101!  Or maybe 102.

> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -312,22 +312,6 @@ static struct device_attribute trip_point_attrs[] = {
>  	__ATTR(trip_point_11_temp, 0444, trip_point_temp_show, NULL),
>  };
>  
> -#define TRIP_POINT_ATTR_ADD(_dev, _index, result)     \
> -do {    \
> -	result = device_create_file(_dev,	\
> -				&trip_point_attrs[_index * 2]);	\
> -	if (result)	\
> -		break;	\
> -	result = device_create_file(_dev,	\
> -			&trip_point_attrs[_index * 2 + 1]);	\
> -} while (0)
> -
> -#define TRIP_POINT_ATTR_REMOVE(_dev, _index)	\
> -do {	\
> -	device_remove_file(_dev, &trip_point_attrs[_index * 2]);	\
> -	device_remove_file(_dev, &trip_point_attrs[_index * 2 + 1]);	\
> -} while (0)

I don't forsee many tears being shed over the above ;)

