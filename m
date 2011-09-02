Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab1IBNLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 09:11:09 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34135
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806Ab1IBNLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 09:11:05 -0400
Date: Fri, 2 Sep 2011 09:10:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Approaches to making io_submit not block
Message-ID: <20110902131057.GA7779@infradead.org>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
 <20110830053231.GA1627@infradead.org>
 <CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com>
 <20110831052627.GA5338@infradead.org>
 <m2pqjlo6e5.fsf@firstfloor.org>
 <20110901041848.GO32358@dastard>
 <20110901043947.GB7761@one.firstfloor.org>
 <20110901065415.GP32358@dastard>
 <20110902130835.GB4110@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902130835.GB4110@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 09:08:35AM -0400, Ted Ts'o wrote:
> That may be true for hard drives, but PCIe attached flash can support
> millions of IOP's per second --- i.e., at least hundreds of IOP's in
> milliseconds.  Yes, these devices are expensive, but so are the
> thousand-disk RAID arrays that some people attach via XFS.  :-)

reading / writing to the devices is different from allocator calls.

You reall do not want to do an allocator call for each of these device.

