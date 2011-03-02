Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1CBObN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:31:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:44413 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab1CBObK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:31:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,253,1297065600"; 
   d="scan'208";a="663044210"
Date: Wed, 2 Mar 2011 15:31:08 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Daniel Willerud <daniel.willerud@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: ab8500: New ab8500_gpadc APIs and reentrance
Message-ID: <20110302143107.GL16181@sortiz-mobl>
References: <1298377440-13032-1-git-send-email-daniel.willerud@stericsson.com>
 <20110302113448.GH16181@sortiz-mobl>
 <AANLkTinTP5UKWeu1eGvAA08YKJzz8=iskEPyPVSFzeCM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinTP5UKWeu1eGvAA08YKJzz8=iskEPyPVSFzeCM@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Mar 02, 2011 at 03:12:31PM +0100, Linus Walleij wrote:
> 2011/3/2 Samuel Ortiz <sameo@linux.intel.com>:
> 
> >> +/**
> >> + * ab8500_gpadc_get() - returns a reference to the primary AB8500 GPADC
> >> + * (i.e. the first GPADC in the instance list)
> >> + */
> >> +struct ab8500_gpadc *ab8500_gpadc_get(void)
> >> +{
> >> +     struct ab8500_gpadc *gpadc;
> >> +     gpadc = list_first_entry(&ab8500_gpadc_list, struct ab8500_gpadc, node);
> >> +
> >> +     return gpadc;
> >> +}
> 
> > This seems really arbitrary. We argued with Mattias about it, and giving
> > drivers access to your ADCs means they should somehow have a pointer back to
> > the right ADC. That's not the case here, and while it will just work fine
> > whenever you have one ADC on your board, you'll probably be relying on some
> > sort of device probe order otherwise.
> 
> I guess the solution is to rewrite that function to take a parameter
> then, such as:
> 
> struct ab8500_gpadc *ab8500_gpadc_get(char *name)
> 
> If name is then just a strcmpm(dev_name(gpadc->dev), name)
> the client use will be something like:
> 
> struct ab8500_gpadc *gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
> 
> For the first GPDC in the system (unless .init_name is specified
> by the ab8500-core when creating the device).
> 
> Fair enough?
That's an original solution. It really is hacking around the device model, but
at least it's nicer than the original proposal. So, fair enough, yes.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
