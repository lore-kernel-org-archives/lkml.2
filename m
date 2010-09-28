Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0I1X2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 19:28:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59952 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab0I1X2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 19:28:48 -0400
Message-ID: <4CA27A01.1080606@zytor.com>
Date: Tue, 28 Sep 2010 16:28:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [RFC][PATCH] PM / Hibernate / x86: Change RESTORE_MAGIC on x86_64
References: <201009290112.11363.rjw@sisk.pl>
In-Reply-To: <201009290112.11363.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 04:12 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> On x86_64 the configuration and version of the kernel that
> hibernates and creates a system image may be different from the
> configuration and version of the boot kernel that loads the image.
> So long as both these kernels are built with the same value of
> RESTORE_MAGIC, the image created by one of them should be
> successfully loaded and restored by the other one.
> 
> It wasn't necessary to modify RESTORE_MAGIC in the past, but now
> that we are adding compression to the in-kernel hibernate code,
> change the value of RESTORE_MAGIC so that earlier kernels don't
> try to load compressed images they can't handle.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/x86/power/hibernate_64.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/power/hibernate_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/power/hibernate_64.c
> +++ linux-2.6/arch/x86/power/hibernate_64.c
> @@ -137,7 +137,7 @@ struct restore_data_record {
>  	unsigned long magic;
>  };
>  
> -#define RESTORE_MAGIC	0x0123456789ABCDEFUL
> +#define RESTORE_MAGIC	0x0123456789ABCDF0UL
>  

Two issues with this:

a) shouldn't we only set this when the image is actually compressed?

b) using systematic magics like this is pessimal in terms of collision
avoidance.  It's much better to use a true random number.

Hence, I propose:

: anacreon 95 ; ranpwd -xc 16
0x4ddedd3236f1e6e1

	-hpa
