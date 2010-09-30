Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0I3N0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:26:18 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48346 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab0I3N0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:26:16 -0400
Date: Thu, 30 Sep 2010 14:25:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: lenb@kernel.org, rui.zhang@intel.com, melchior+kernel@cmu.edu,
        jerone.young@canonical.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patrol@sinus.cz,
        "Lee, Chun-Yi" <jlee@novell.com>
Subject: Re: [PATCH] DMI to disable Vista compatibility on MSI GX723
	Notebook
Message-ID: <20100930132552.GA11064@srcf.ucam.org>
References: <1285843451-24932-1-git-send-email-jlee@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285843451-24932-1-git-send-email-jlee@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 06:44:11PM +0800, Lee, Chun-Yi wrote:
> The brightness control hotkey don't work with Vista compatibility
> , because MSI GX723 included a infinite while loop in DSDT when
> brightness control hotkey pressed.
> MSI GX723 used Nvida video card, the infinite while loop must be a
> workaround with Nvidia's Vista driver.

While this would work, it seems likely that the expected behaviour is 
for the graphics driver to call the NVIF method. We don't do that as 
yet, but when we do I'm worried about it potentially resulting in this 
system being in an unexpected state (NVIF is used, but we don't claim to 
be Vista). Can you add a comment indicating that it should be reverted 
once nouveau grows support?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
