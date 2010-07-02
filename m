Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab0GBHgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:36:05 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:35689 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805Ab0GBHgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:36:03 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201007020735.o627Z2E1025678@mercury.physics.adelaide.edu.au>
Subject: Re: [PATCH v2] fujitsu-laptop: remove unnecessary input_free_device
To: axel.lin@gmail.com (Axel Lin)
Date: Fri, 2 Jul 2010 17:05:02 +0930 (CST)
Cc: linux-kernel@vger.kernel.org (linux-kernel),
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       mjg@redhat.com (Matthew Garrett), len.brown@intel.com (Len Brown),
       akpm@linux-foundation.org (Andrew Morton),
       stefani@seibold.net (Stefani Seibold), ak@linux.intel.com (Andi Kleen),
       platform-driver-x86@vger.kernel.org
In-Reply-To: <1278055248.12339.5.camel@mola> from "Axel Lin" at Jul 02, 2010 03:20:48 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
 
> input_free_device should only be used if input_register_device()
> was not called yet or if it failed.
> This patch removes unnecessary input_free_device calls.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/fujitsu-laptop.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index e325aeb..4346d26 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -725,6 +725,7 @@ static int acpi_fujitsu_add(struct acpi_device *device)
>  
>  err_unregister_input_dev:
>  	input_unregister_device(input);
> +	input = NULL;
>  err_free_input_dev:
>  	input_free_device(input);
>  err_stop:
> @@ -738,8 +739,6 @@ static int acpi_fujitsu_remove(struct acpi_device *device, int type)
>  
>  	input_unregister_device(input);
>  
> -	input_free_device(input);
> -
>  	fujitsu->acpi_handle = NULL;
>  
>  	return 0;
> @@ -930,6 +929,7 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
>  
>  err_unregister_input_dev:
>  	input_unregister_device(input);
> +	input = NULL;
>  err_free_input_dev:
>  	input_free_device(input);
>  err_free_fifo:
> @@ -953,8 +953,6 @@ static int acpi_fujitsu_hotkey_remove(struct acpi_device *device, int type)
>  
>  	input_unregister_device(input);
>  
> -	input_free_device(input);
> -
>  	kfifo_free(&fujitsu_hotkey->fifo);
>  
>  	fujitsu_hotkey->acpi_handle = NULL;
> -- 
> 1.5.4.3
> 
> 
> 


-- 
* Jonathan Woithe    jwoithe@physics.adelaide.edu.au                        *
*                    http://www.physics.adelaide.edu.au/~jwoithe            *
***-----------------------------------------------------------------------***
** "Time is an illusion; lunchtime doubly so"                              **
*  "...you wouldn't recognize a subtle plan if it painted itself purple and *
*   danced naked on a harpsichord singing 'subtle plans are here again'"    *
