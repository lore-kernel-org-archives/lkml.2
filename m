Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1IBNIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 09:08:54 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:52028 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab1IBNIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 09:08:50 -0400
Date: Fri, 2 Sep 2011 09:08:35 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110902130835.GB4110@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Andi Kleen <andi@firstfloor.org>,
	Christoph Hellwig <hch@infradead.org>,
	Daniel Ehrenberg <dehrenberg@google.com>,
	linux-kernel@vger.kernel.org
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
 <20110830053231.GA1627@infradead.org>
 <CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com>
 <20110831052627.GA5338@infradead.org>
 <m2pqjlo6e5.fsf@firstfloor.org>
 <20110901041848.GO32358@dastard>
 <20110901043947.GB7761@one.firstfloor.org>
 <20110901065415.GP32358@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901065415.GP32358@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 04:54:15PM +1000, Dave Chinner wrote:
> Apples to oranges - there's orders of magnitude of difference in the
> number of operations that the different stacks do. Allocation in XFS
> when it does not block can still take milliseconds of CPU time; in
> comparison, the networking stack is expected to process thousands of
> packets in that same time frame.  IOWs, the scale of processing per
> item of work is -vastly- different - that's why working in process
> context matters a great deal to the networking stack but not to
> allocation in XFS.

That may be true for hard drives, but PCIe attached flash can support
millions of IOP's per second --- i.e., at least hundreds of IOP's in
milliseconds.  Yes, these devices are expensive, but so are the
thousand-disk RAID arrays that some people attach via XFS.  :-)

There are people in the ext4 development community interested in
looking at such devices.  We've made some improvements, we (and by
this I mean the whole kernel) are a long, long way from supporting
such beasts properly....

							- Ted
