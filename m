Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab0JHIXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:23:40 -0400
Received: from verein.lst.de ([213.95.11.210]:48279 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab0JHIXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:23:38 -0400
Date: Fri, 8 Oct 2010 10:22:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Daniel Phillips <phillips@phunq.net>
Cc: Cong Meng <mcpacino@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: introduce dm-snap-mv
Message-ID: <20101008082231.GA2054@lst.de>
References: <20101006083150.GA15758@zhongling> <201010071431.14937.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010071431.14937.phillips@phunq.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 02:31:14PM -0700, Daniel Phillips wrote:
> Hi Meng,
> 
> The patch looks sensible, however the question is: why do you want to
> do this?  Would it not be better to generalize your metadata format to
> accomodate the device's native blocksize?

Even if it uses fixed 4k sectors it should just read them in smaller
chunks OR even better stop using buffer heads and just read them
manually using submit_bio.  BHs really shouldn't be used outside of
filesystems, and even there they slowly are on their way out.

