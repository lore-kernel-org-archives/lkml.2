Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab0HXOW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:22:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41455 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0HXOW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:22:26 -0400
Date: Tue, 24 Aug 2010 15:22:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Joey Lee <jlee@novell.com>
Cc: trenn@suse.de, gregkh@suse.de, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis.Jansen@web.de
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
	detect
Message-ID: <20100824142219.GB16200@srcf.ucam.org>
References: <4C7426DB020000230001F3A8@novprvlin0050.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7426DB020000230001F3A8@novprvlin0050.provo.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erm. Sorry about that - I just realised that there's actually a fairly 
significant problem with it :) Right now you'll perform the register 
call unconditionally on module load. You need to make sure that there's 
actually Poulsbo hardware in the system, either by registering as a 
proper PCI driver and calling acpi_video_register in your probe function 
(and unregister in your remove function) or walking the PCI device list 
looking for a psb device.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
