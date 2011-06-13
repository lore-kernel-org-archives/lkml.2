Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab1FMSdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:33:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39955 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab1FMSdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:33:15 -0400
Date: Mon, 13 Jun 2011 19:33:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110613183301.GA25644@srcf.ucam.org>
References: <20110610164706.GB25774@srcf.ucam.org>
 <4DF259B2.9070403@gmail.com>
 <20110610175429.GA28500@srcf.ucam.org>
 <4DF29E7E.50908@gmail.com>
 <20110613164712.GA23343@srcf.ucam.org>
 <4DF64E6A.70700@gmail.com>
 <20110613180006.GA24902@srcf.ucam.org>
 <4DF65372.7090307@gmail.com>
 <20110613181750.GA25372@srcf.ucam.org>
 <4DF655B5.8040903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF655B5.8040903@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, that's odd. These are 0x01800000-0x01900000, which should lie inside 
the kernel data range (01580279-01aa4cff : Kernel data). We should be 
skipping that region. How are we touching that reange at all? Can you 
add a printk to reserve_boot_services to see what it actually ends up 
reserving?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
