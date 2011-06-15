Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab1FOT7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:59:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:50637 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab1FOT73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:59:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,371,1304319600"; 
   d="scan'208";a="13972925"
Date: Wed, 15 Jun 2011 12:59:28 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: device plugged into xhci port not detected after a resume
Message-ID: <20110615195928.GD5382@xanatos>
References: <4DF85A1F.1080001@gmail.com>
 <20110615165842.GB5382@xanatos>
 <4DF8EE62.3060407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF8EE62.3060407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 07:39:46PM +0200, Maarten Lankhorst wrote:
> Op 15-06-11 18:58, Sarah Sharp schreef:
> > Does hibernate work, either with no devices plugged in, or the mouse
> > plugged in?  If it does work, the host controller may not be able to
> > handle the context save and restore during suspend/resume, and we may
> > need to unconditionally tell the USB core that the host lost power
> > across suspend.
> Yeah, manually overriding the resume function works. Tested with
> 
> -	if ((temp & STS_SRE) || hibernated) {
> +	if ((temp & STS_SRE) || hibernated || 1) {

Can you send me the lspci -vvv for this device?  I'll cook up a proper
patch with a new quirk for it.

Sarah Sharp
