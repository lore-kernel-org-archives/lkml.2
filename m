Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab2CSIrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:47:23 -0400
Received: from mga12.intel.com ([143.182.124.36]:18435 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758513Ab2CSIrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:47:22 -0400
Subject: Re: EFI Boot Stub Early Console
From: Matt Fleming <matt.fleming@intel.com>
To: Shea Levy <shea@shealevy.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4F65D09B.4050807@shealevy.com>
References: <4F5E46EA.7020602@shealevy.com> <4F5E47E4.2070303@shealevy.com>
	 <4F5E74A0.60001@zytor.com> <4F5E761B.7010608@shealevy.com>
	 <4F5E775D.7080702@zytor.com>  <4F648DD3.3000405@shealevy.com>
	 <1332069701.4041.42.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4F65D09B.4050807@shealevy.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Mon, 19 Mar 2012 08:47:14 +0000
Message-ID: <1332146834.4041.46.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-03-18 at 08:10 -0400, Shea Levy wrote:
> Hi Matt,
> 
> On 3/18/12 7:21 AM, Matt Fleming wrote:
> > I don't think you'll need to use the graphics protocols, you should 
> > just be able to put something together using the 'output_string' 
> > function from the EFI simple text output protocol, e.g. something like 
> > this, https://lkml.org/lkml/2012/3/16/193 
> 
>  From the UEFI 2.3.1 spec:
> 
> > Prior to a call to ExitBootServices(), all of the fields of the EFI 
> > System Table are valid. After an operating system has taken control of 
> > the platform with a call to ExitBootServices(), only the Hdr, 
> > FirmwareVendor, FirmwareRevision, RuntimeServices, 
> > NumberOfTableEntries, and ConfigurationTable fields are valid.
> 
> Doesn't this mean that ConOut can't be used for the earlyprintk, since 
> any bootloader (including the bootstub) will call ExitBootServices() 
> before any printk'ing actually happens?? Or am I misunderstanding the 
> spec somehow? I suppose I could just try it and see what happens...

Oops. Good point, that isn't going to work.

