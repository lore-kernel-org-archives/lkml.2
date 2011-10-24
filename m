Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab1JXUTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:19:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33878 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab1JXUTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:19:17 -0400
Date: Mon, 24 Oct 2011 13:19:07 -0700
From: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg KH <gregkh@suse.de>, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC 3/4] lib: devres: add convenience function to remap a
 resource
Message-ID: <20111024201907.GD24914@google.com>
References: <1319445729-14841-1-git-send-email-w.sang@pengutronix.de>
 <1319445729-14841-4-git-send-email-w.sang@pengutronix.de>
 <20111024154307.GB24914@google.com>
 <20111024200933.GB6326@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024200933.GB6326@pengutronix.de>
1;2305;0cTo: Wolfram Sang <w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 10:09:33PM +0200, Wolfram Sang wrote:
> > So, for library functions, it's nice if the function doesn't hold any
> > extra resource on error return.  devres has grouping to support this.
> > You just need to wrap allocations inside a group and remove it on
> > success and release on error.  ie.
> > 
> > 	if (!devres_open_group(dev, NULL, GFP_KERNEL))
> > 		return NULL;
> > 	if (alloc_resource(0) < 0)
> > 		goto fail;
> > 	if (alloc_resource(1) < 0)
> > 		goto fail;
> > 	devres_remove_group(dev, NULL);
> > 	return 0;
> > fail:
> > 	devres_release_group(dev, NULL);
> > 	return 0;
> 
> I am not sure I got what you mean here, but wouldn't it be easier to simply
> call devm_release_mem_region() when devm_ioremap comes back with a NULL
> pointer?

Oh, yeah, that would work too. :)

Thanks.

-- 
tejun
