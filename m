Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0D0DVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 23:21:55 -0400
Received: from usul.saidi.cx ([204.11.33.34]:42450 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753019Ab0D0DVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 23:21:54 -0400
X-Greylist: delayed 2494 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2010 23:21:54 EDT
Date: Mon, 26 Apr 2010 19:40:02 -0700
From: Philip Langdale <philipl@overt.org>
To: Len Brown <lenb@kernel.org>
Cc: Jeff Garrett <jeff@jgarrett.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
Message-ID: <20100426194002.586fbaa5@fido5>
In-Reply-To: <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain>
References: <20100126084740.GA5265@jgarrett.org>
	<87y6jkee1b.fsf@basil.nowhere.org>
	<20100205160900.GA2736@jgarrett.org>
	<alpine.LFD.2.00.1002051238280.4050@localhost.localdomain>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Feb 2010 12:45:21 -0500 (EST)
Len Brown <lenb@kernel.org> wrote:

> Jeff,
> What do you see if you apply just the patch below?
> 
> Also, in addition to "powertop -d" to show what the kernel requests,
> please run turbostat to show what the hardware actually did:
> 
> http://userweb.kernel.org/~lenb/acpi/utils/pmtools-latest/turbostat/turbostat.c
> 
> eg.
> # turbostat -d -v sleep 5
> 
> thanks,
> -Len Brown, Intel Open Source Technology Center
> ---

To resurrect this thread...

I have a giga-byte GA-P55M-UD4 motherboard and I have this same problem
as well. Len's patch "works" in that I see C6 being used, but it also
cripples the system - if I do a make -j16 kernel build, I see most jobs
serialized onto one or two cores. Without the patch, I see the
full utilization of all 8 hyper-threads as expected.

Now, gigabyte have already b0rked these boards up by using the UHCI
controllers on the PCH instead of the rate matching hubs. Maybe that's
directly the cause of BM activity - maybe they screwed something else
up - is it possible for BIOS/ACPI mistakes to lead to this behaviour?

Jeff - is your board gigabyte too?

--phil

> diff --git a/drivers/acpi/processor_idle.c
> b/drivers/acpi/processor_idle.c index 7c0441f..f528625 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -763,7 +763,7 @@ static const struct file_operations
> acpi_processor_power_fops = { static int acpi_idle_bm_check(void)
>  {
>  	u32 bm_status = 0;
> -
> +return bm_status;
>  	acpi_read_bit_register(ACPI_BITREG_BUS_MASTER_STATUS,
> &bm_status); if (bm_status)
>  		acpi_write_bit_register(ACPI_BITREG_BUS_MASTER_STATUS,
> 1);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 




--phil
