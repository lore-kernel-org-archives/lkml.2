Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab1AEP3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:29:08 -0500
Received: from kanga.kvack.org ([205.233.56.17]:54919 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab1AEP3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:29:07 -0500
X-Greylist: delayed 1698 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jan 2011 10:29:07 EST
Date: Wed, 5 Jan 2011 10:00:48 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: [PATCH 21/32] fs/aio: aio_wq isn't used in memory reclaim path
Message-ID: <20110105150048.GA32455@kvack.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org> <1294062595-30097-22-git-send-email-tj@kernel.org> <x49d3ocacij.fsf@segfault.boston.devel.redhat.com> <20110105112802.GA7669@mtj.dyndns.org> <x49d3obqu9a.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49d3obqu9a.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 09:50:57AM -0500, Jeff Moyer wrote:
> > Yeap.  Do you agree that the concurrency limit is necessary?  If not,
> > we can just put everything onto system_wq.
> 
> I'm not sure whether it's strictly necessary (there may very well be a
> need for this in the usb gadgetfs code), but keeping it the same at
> least seems safe.

Limiting concurrency on aio requests is exactly the opposite of what the 
usb gadgetfs requires.  It's similarly bad for filesystem aio when there's 
a mix of small and large requests in flight.

		-ben
