Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab2AaUJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 15:09:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53028 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab2AaUI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 15:08:59 -0500
Date: Tue, 31 Jan 2012 13:08:52 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Mark Grosen <mgrosen@ti.com>
Subject: Re: [PATCH 2/2] remoteproc: s/big switch/lookup table/
Message-ID: <20120131200852.GC22611@ponder.secretlab.ca>
References: <1328028762-28352-1-git-send-email-ohad@wizery.com>
 <1328028762-28352-2-git-send-email-ohad@wizery.com>
 <4F282BB2.6080604@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F282BB2.6080604@fastmail.fm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 05:58:10PM +0000, Jack Stone wrote:
> On 31/01/12 16:52, Ohad Ben-Cohen wrote:
> > +/*
> > + * A lookup table for resource handlers. Always keep in sync with
> > + * enum fw_resource_type.
> > + */
> > +static rproc_handle_resource_t rproc_handle_rsc[] = {
> > +	rproc_handle_carveout,	/* RSC_CARVEOUT */
> > +	rproc_handle_devmem,	/* RSC_DEVMEM */
> > +	rproc_handle_trace,	/* RSC_TRACE */
> > +	rproc_handle_vring,	/* RSC_VRING */
> > +	NULL, /* RSC_VIRTIO_DEV is handled early upon registration */
> > +};
> > +
> 
> You could change this to
> 
> [RSC_CARVEOUT] = rproc_handle_carveout,
> 
> Then you would be safe against renumbering and would only need to worry
> about addition (which your RSC_LAST check copes with).

Yes, that is the right thing to do.  Then the compiler can catch ordering
issues for you.

g.

