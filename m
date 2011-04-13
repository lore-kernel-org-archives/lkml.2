Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1DMNX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:23:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47641 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1DMNX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:23:57 -0400
Date: Wed, 13 Apr 2011 14:23:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.jf.intel.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] gma500: backlight warning
Message-ID: <20110413132347.GA27007@srcf.ucam.org>
References: <20110413093519.28527.36552.stgit@localhost.localdomain>
 <20110413093555.28527.30662.stgit@localhost.localdomain>
 <20110413131714.GA17918@srcf.ucam.org>
 <20110413142022.56ebe93f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413142022.56ebe93f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 02:20:22PM +0100, Alan Cox wrote:
> On Wed, 13 Apr 2011 14:17:14 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > On Wed, Apr 13, 2011 at 10:36:19AM +0100, Alan Cox wrote:
> > >  	props.max_brightness = 100;
> > > +	props.type = BACKLIGHT_PLATFORM;
> > 
> > No, this should be BACKLIGHT_RAW - it's hitting the control registers 
> > directly rather than going via a platform interface.
> 
> Ah ok - I figured it *was* the platform backlight. I'll send Greg a new
> version of that changeset.

Platform is intended for cases where the platform (ie, the specific 
instance of a GMA500-based system) provides its own mechanism, rather 
than falling through to the raw register access. The idea is that 
platform interfaces may keep track of other platform-level policy such 
as ALS. Opregion potentially mitigates these problems, but I've still 
seen some cases where the distinction matters.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
