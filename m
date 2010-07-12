Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0GLPMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:12:21 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:24809 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958Ab0GLPMS (ORCPT
	<rfc822;groupwise-jlee@novell.com:3:2>);
	Mon, 12 Jul 2010 11:12:18 -0400
Message-Id: <4C3BBD6D020000230001CD30@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 12 Jul 2010 09:12:13 -0600
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <dri-devel@lists.sourceforge.net>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
 detect
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattew, 

於 一，2010-07-12 於 03:27 +0100，Matthew Garrett 提到：
> On Sun, Jul 11, 2010 at 08:12:57PM -0600, Joey Lee wrote:
> 
> > He tested the drm blacklist patch can works fine on his computer, it's
> > also works on VESA mode because the acpi _BCM, _BQC direct change
> > brightness by opregion.
> > 

Sorry, I write a wrong information, the MSI poulsbo netbook change
brightness by ec command in _BCM, _BQC, not opregion.

> > What can we do for this situtation? I mean if the BIOS have opregion
> > implementation but there have no opensource drm driver or native video
> > driver support opregion on Linux?
> 
> The cleanest way would be to implement a stub backlight control driver 
> for the chip - there should be enough information in the source of the 
> poulsbo drm to do that. 

M... Follow your suggestion, I am tracing the i915 drm driver and
Poulsbo drm driver from here:

http://sourceforge.net/mailarchive/message.php?msg_name=49C2ADA8.2090405%40shipmail.org

I am not sure fully understood your suggestion... Did you mean we can
extract some parts from Poulsbo drm driver and put it to a stub
backlight control driver for Poulsbo? Where can we put the stub driver?
Do we still put it in i915 drm? 

On the other hand, the Poulsbo is a old and stop ship chip, do we still
want to add a special driver for it?

> The main problem with the blacklist approach is 
> that there's no guarantee that all poulsbo systems will have a working 
> acpi method, and I /think/ there's a couple more PCI IDs that ought to 
> be covered in any case. On the other hand doing it properly does involve 
> writing rather a lot more code, and the fact that Intel have shown 
> absolutely no interest in making their hardware work means that the 
> quick hack might be the most reasonable thing to do.
> 

Thank's for your remind, I fully agreed cann't guarantee all poulsbo
systems have working acpi method. But, I am sure the MSI U110/U115 have
workable acpi backlight method.
Do you think it's good to put the special DMI detection in msi-laptop
driver to enable the the acpi backlight control by call
acpi_video_register in acpi video? But will cause msi-laptop driver
dependency to acpi video driver.

Need your kindly suggestion!


Thank's a lot!
Joey Lee

