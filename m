Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab2FTHmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:42:52 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:3620 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2FTHmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:42:51 -0400
Date: Wed, 20 Jun 2012 09:42:27 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: ben-linux@fluff.org, seth.heasley@intel.com, ben@decadent.org.uk,
        David.Woodhouse@intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, bleung@chromium.org
Subject: Re: [PATCH 2/3 v2] i2c: i801: enable irq for i801 smbus
 transactions
Message-ID: <20120620094227.541223db@endymion.delvare>
In-Reply-To: <1325847502-17841-3-git-send-email-djkurtz@chromium.org>
References: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
	<1325847502-17841-3-git-send-email-djkurtz@chromium.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more note on this...

On Fri,  6 Jan 2012 18:58:21 +0800, Daniel Kurtz wrote:
> Add a new 'feature' to i2c-i801 to enable using i801 interrupts.
> When the feature is enabled, then an isr is installed for the device's
> pci irq.

What if bit 1 of host configuration register (SMB_SMI_EN) is set? My
understanding is that our ISR will never be called in that case, so we
should stick to polled mode? We do check it already but it's only
informative at the moment:

	if (temp & SMBHSTCFG_SMB_SMI_EN)
		dev_dbg(&dev->dev, "SMBus using interrupt SMI#\n");
	else
		dev_dbg(&dev->dev, "SMBus using PCI Interrupt\n");

-- 
Jean Delvare
