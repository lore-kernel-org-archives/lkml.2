Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1CDGqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 01:46:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53990 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1CDGqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 01:46:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nRTf90nT18M5p66AfV1u5yIyd/fD9D5ui2clC6w40IlKLr/fDW57TReT2OZHOz7k1F
         Uub292H9wL5YCQEH9Ks/vo9JG2IQpqpKV2NEWlyggwszaEuLWOaRaKAixzduYaHF4/4S
         pUiy1+KaUiaxU9s+s6HutNaSdpqMuz1nCP4Io=
Date: Fri, 4 Mar 2011 07:42:51 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, richard.cochran@omicron.at,
        johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 2/3] ptp: add a software clock based on
 clock_monotonic_raw
Message-ID: <20110304064251.GC3824@riccoc20.at.omicron.at>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
 <1299173174-348-3-git-send-email-torbenh@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299173174-348-3-git-send-email-torbenh@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 06:26:13PM +0100, Torben Hohn wrote:
> +config PTP_1588_CLOCK_SOFTWARE
> +	tristate "software PTP clock"
> +	depends on PTP_1588_CLOCK
> +	help
> +	  This driver adds a software PTP clock. 

As John said, this needs a longer description. You can look back at
my V6 as an example.

  https://lkml.org/lkml/2010/9/23/220

> +static int ptp_ixp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)

Once again, please rename.

Better yet, why not just use the V6 example instead?  If we are going
to have a testing driver, then I would want the simulated ancillary
code as well.

> +
> +static struct ptp_clock_info ptp_ixp_caps = {
> +	.owner		= THIS_MODULE,
> +	.name		= "software timer",
> +	.max_adj	= 66666655,

You should calculate the actual limit of adjustment and use it here.

Thanks,

Richard



