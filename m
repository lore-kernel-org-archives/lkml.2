Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab2A1T0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 14:26:01 -0500
Received: from quartz.orcorp.ca ([139.142.54.143]:50287 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2A1TZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 14:25:59 -0500
Date: Sat, 28 Jan 2012 12:25:53 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Hugh Dickins <hughd@google.com>
Cc: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC G-U-P experts] IB/umem: Modernize our
 get_user_pages() parameters
Message-ID: <20120128192553.GA16231@obsidianresearch.com>
References: <1327557574-6125-1-git-send-email-roland@kernel.org>
 <alpine.LSU.2.00.1201261133230.1369@eggly.anvils>
 <CAG4TOxNEV2VY9wOE86p9RnKGqpruB32ci9Wq3yBt8O2zc7f05w@mail.gmail.com>
 <CAL1RGDVBR49QrAbkZ0Wa9Gh98HTwjtsQbFQ4Ws3Ra7rEjT1Mng@mail.gmail.com>
 <alpine.LSU.2.00.1201271819260.3402@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1201271819260.3402@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 06:31:07PM -0800, Hugh Dickins wrote:

> My first impression is that that's not what you want at all: that will
> not do a preliminary COW of anonymous page to be written into by the
> driver when the user only wants VM_READ access.  But perhaps I'm
> worrying about the second order while you're sticking to first order.

IMHO, in this instance, the RDMA driver should not violate the
mprotect flags of the page, ie if you ask to register memory for
RDMA WRITE that the process cannot write to, that should be denied.

I know accessing system memory (eg obtained via mmap on
/sys/bus/pci/devices/0000:00:02.0/resource0) has been asked for in the
past, and IIRC, the problem was that some of the common code, (GUP?)
errored on these maps. I don't know if Roland's case is similar.

The main point (at least before) was to have a uniform userspace API
for memory registration that worked on any address range mapped into
the process no matter where it came from. Currently the API just calls
GUP unconditionally...

Jason
