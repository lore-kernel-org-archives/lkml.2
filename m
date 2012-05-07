Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab2EGPse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:48:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35530 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab2EGPsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:48:32 -0400
Date: Mon, 7 May 2012 08:48:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] Input: tl6040-vibra: Device Tree support
Message-ID: <20120507154826.GB10222@core.coreip.homeip.net>
References: <1336133113-12224-1-git-send-email-peter.ujfalusi@ti.com>
 <20120507070233.GB22074@core.coreip.homeip.net>
 <4FA7A8B9.4040208@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA7A8B9.4040208@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 01:49:29PM +0300, Peter Ujfalusi wrote:
> Hi Dmitry,
> 
> On 05/07/2012 10:02 AM, Dmitry Torokhov wrote:
> > Hi Peter,
> > 
> > On Fri, May 04, 2012 at 03:05:13PM +0300, Peter Ujfalusi wrote:
> >> +	if (pdata) {
> >> +		info->vibldrv_res = pdata->vibldrv_res;
> >> +		info->vibrdrv_res = pdata->vibrdrv_res;
> >> +		info->viblmotor_res = pdata->viblmotor_res;
> >> +		info->vibrmotor_res = pdata->vibrmotor_res;
> >> +		vddvibl_uV = pdata->vddvibl_uV;
> >> +		vddvibr_uV = pdata->vddvibr_uV;
> >> +	} else {
> >> +		of_property_read_u32(node, "vibldrv_res", &info->vibldrv_res);
> >> +		of_property_read_u32(node, "vibrdrv_res", &info->vibrdrv_res);
> >> +		of_property_read_u32(node, "viblmotor_res",
> >> +				     &info->viblmotor_res);
> >> +		of_property_read_u32(node, "vibrmotor_res",
> >> +				     &info->vibrmotor_res);
> > 
> > Since these 4 appear to be mandatory properties don't we need to
> > validate they are actually present in DT?
> 
> If the property does not exist in the DT blob the variable will not be
> updated - it will remain 0.
> I have kept the validity check for the resistance values. This will
> catch the case when something is missing from the DT blob.
> 
> I just did not wanted to complicate the code with additional checks
> since the end result would be the same.

Ah, indeed, I missed that we still validate the values.

Applied, thanks Peter.

-- 
Dmitry
