Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2IURV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:21:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20317 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2IURVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:21:25 -0400
Date: Fri, 21 Sep 2012 13:10:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] xen: frontend devices should handle missed backend
 CLOSING
Message-ID: <20120921171013.GA9201@phenom.dumpdata.com>
References: <1348243464-15903-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348243464-15903-1-git-send-email-david.vrabel@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 05:04:18PM +0100, David Vrabel wrote:
> The series makes all the Xen frontend drivers handle the backend
> transitioning to CLOSED without the frontend having previously seen
> the backend in the CLOSING state.
> 
> Backends shouldn't do this but some do.  e.g., if the host is
> XenServer and the toolstack decides to do a forced shutdown of a VBD,
> then the blkfront may miss the CLOSING transition and the /dev/xvdX
> device will not be destroyed which prevents it being reused.
> 
> I have seen systems that ended up in this state but it's not clear if
> this was the actual cause.  However, I think in general it's a good
> thing to thing to improve the handling of unexpected state
> transitions.
> 
> Konrad, I've split this into a patch per frontend in case each patch
> should go via a different maintainer.  But if you'd prefer, I can roll
> this up into one patch to via your Xen tree.

I like the split-up. Can you repost them with the different maintainers
CC (scripts/get_maintainers.pl) and with Acked-by from me on them?

> 
> David
