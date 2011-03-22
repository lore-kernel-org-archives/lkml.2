Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1CVQ0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:26:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:47739 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab1CVQ0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:26:30 -0400
Date: Tue, 22 Mar 2011 09:23:05 -0700
From: Greg KH <gregkh@suse.de>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, david@woodhou.se
Subject: Re: [PATCH 0/7] char/mei: Intel MEI Driver
Message-ID: <20110322162305.GA14737@suse.de>
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 12:51:25PM +0200, Oren Weil wrote:
> ﻿Intel MEI Driver
> =======================
> The Intel Management Engine (Intel ME) is an isolated and 
> protected computing resources (Coprocessor) residing inside 
> Intel chipsets. The Intel ME provides support for computer/IT 
> management features.
> The Feature set depends on Intel chipset SKU. 
> 
> The Intel Management Engine Interface (Intel MEI, previous known 
> as HECI) is interface between the Host and Intel ME. 
> This interface is exposed to the host as PCI device. 
> The Intel MEI Driver is in charge of the communication channel 
> between host application and ME feature.
> 
> Each ME feature (ME Client) is addressed by GUID/UUID 
> and each feature defines its own protocol. 
> The protocol is message based with header and payload up to
> 512 bytes.
> 
> The driver exposes character device called /dev/mei.

Why not use a misc device node instead of claiming your own major
number?  That would solve your sysfs code solution for you as well
(enabling you to delete it all.)

>  drivers/char/mei/Makefile      |   19 +

How about putting it under drivers/misc/mei/ instead?  That's where
other monitoring drivers like this are at (ibmasm for example.)

Are you wanting this version reviewed for inclusion in .40?  If you
don't feel the code is ready for the main kernel tree, do you want it in
staging for the .40 release?

thanks,

greg k-h
