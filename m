Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab1CBLfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:35:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:8190 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab1CBLfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:35:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,252,1297065600"; 
   d="scan'208";a="608181120"
Date: Wed, 2 Mar 2011 12:34:48 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Willerud <daniel.willerud@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: ab8500: New ab8500_gpadc APIs and reentrance
Message-ID: <20110302113448.GH16181@sortiz-mobl>
References: <1298377440-13032-1-git-send-email-daniel.willerud@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298377440-13032-1-git-send-email-daniel.willerud@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Feb 22, 2011 at 01:24:00PM +0100, Daniel Willerud wrote:
> Added ab8500_gpadc_get() API: A client do not need to be a ab8500 sub-device
> Added ab8500_gpadc_convert() API
> Added support for multiple ab8500-gpadc instances, driver is now reentrant
> 
> Corrected regulator naming according to ste-next
This patch is fixing/improving several things at the same time, please split
it up.

Also, one additional comment:

> +/**
> + * ab8500_gpadc_get() - returns a reference to the primary AB8500 GPADC
> + * (i.e. the first GPADC in the instance list)
> + */
> +struct ab8500_gpadc *ab8500_gpadc_get(void)
> +{
> +	struct ab8500_gpadc *gpadc;
> +	gpadc = list_first_entry(&ab8500_gpadc_list, struct ab8500_gpadc, node);
> +
> +	return gpadc;
> +}
This seems really arbitrary. We argued with Mattias about it, and giving
drivers access to your ADCs means they should somehow have a pointer back to
the right ADC. That's not the case here, and while it will just work fine
whenever you have one ADC on your board, you'll probably be relying on some
sort of device probe order otherwise.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
