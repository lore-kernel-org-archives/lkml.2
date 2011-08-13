Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022Ab1HMIzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 04:55:08 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:44051 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1HMIzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 04:55:05 -0400
Date: Sat, 13 Aug 2011 04:54:54 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: martyn.welch@ge.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110813085454.GA3409@flamenco.cs.columbia.edu>
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
 <1313145051-13397-4-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313145051-13397-4-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 12:30:49 +0200, Manohar Vanga wrote:
> This patch adds functions that allow for reference counting
> bridge modules. The patch introduces the functions
> 'vme_bridge_get()' and 'vme_bridge_put()'.
(snip)
> +int vme_bridge_get(unsigned int bus_id)
(snip)
> +void vme_bridge_put(struct vme_bridge *bridge)

Note the input parameter imbalance; in fact this is serious
(see my email on patch 5) because _get() needs to acquire
vme_buses_lock, whereas _put() doesn't. Since a caller with
bridge has bridge->num, but the opposite doesn't hold (num
doesn't give you the bridge without acquiring vme_buses_lock),
it seems reasonable to me to take the bus_id as the input for
both functions, because the requirements on the caller are lower.

But the locking needs to be handled with care, see my reply
to patch 5.

		Emilio

