Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab0GWK63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:58:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60001 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab0GWK62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:58:28 -0400
Date: Fri, 23 Jul 2010 06:58:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-r5 ext3 corruptions
Message-ID: <20100723105824.GA2205@infradead.org>
References: <20100715105745.GI30737@dastard>
 <20100719224512.GD32635@dastard>
 <20100721063222.GW32635@dastard>
 <20100723104313.GA6431@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723104313.GA6431@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 12:43:14PM +0200, Jan Kara wrote:
> changelog below. I'd much rather attribute the metadata corruption to a missing
> barrier option or barrier support in the virtualization stack. But I guess it's
> hard to tell now.

Any recent qemu/kvm stack has perfectly working barrier support.  Xen
is quite broken in that respect, but I hope no one is using that anyway.

But yes, with large write caches ext3 is rather broken due to the lack
of barriers.  Fortunately enough at least the enterprise enable it
anyway these days.

