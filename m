Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1LMDqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 22:46:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53136 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1LMDqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 22:46:07 -0500
Date: Tue, 13 Dec 2011 03:45:58 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Ted Phelps <phelps@gnusto.com>,
        Peter <pab1612@gmail.com>, Lukas Hejtmanek <xhejtman@fi.muni.cz>,
        Andrew Lutomirski <luto@mit.edu>
Subject: Re: [PATCH 2/2] drm/i915: By default, enable RC6 on IVB and SNB
 when reasonable
Message-ID: <20111213034558.GA26750@srcf.ucam.org>
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
 <1323474829-2501-1-git-send-email-keithp@keithp.com>
 <1323474829-2501-3-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323474829-2501-3-git-send-email-keithp@keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 03:53:49PM -0800, Keith Packard wrote:
> RC6 should always work on IVB, and should work on SNB whenever IO
> remapping is disabled. RC6 never works on Ironlake. Make the default
> value for the parameter follow these guidelines. Setting the value
> to either 0 or 1 will force the specified behavior.

I still don't like this. We're in a situation where we clearly have to 
disable one feature or the other on SNB - but we're disabling the one 
that's going to be useful to a large number of people, and leaving the 
niche feature enabled. If we're going to merge this then let's turn off 
iommu on SNB by default.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
