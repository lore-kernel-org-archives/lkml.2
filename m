Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1HCQT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:19:58 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:60606 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab1HCQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:19:51 -0400
X-Greylist: delayed 3373 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Aug 2011 12:19:51 EDT
Date: Wed, 3 Aug 2011 11:23:17 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: Martyn Welch <martyn.welch@ge.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110803152317.GA21903@flamenco.cs.columbia.edu>
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-6-git-send-email-manohar.vanga@cern.ch>
 <4E39555C.30507@ge.com>
 <20110803140630.GA29460@becoht-mvanga>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803140630.GA29460@becoht-mvanga>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 16:06:30 +0200, Manohar Vanga wrote:
> Hey Martyn,
> 
> > Can we not do this inside vme_master_request, vme_slave_request, etc?
> > 
> > I.e. Add reference count when resources are given out.
> > 
> > This would then be done in the vme_*_free routines.
> 
> I agree this would be much better. I will change this and resend :)

To me it seems better to keep this as is, to be
used by .probe and .release methods, in the same way
usb_get_dev() and usb_put_dev() are used by usb drivers.

Hiding refcounts under the resource accessors will just
complicate things unnecessarily. Modifying refcounts
should always be explicit unless there's a very good
reason against it.

		Emilio 
