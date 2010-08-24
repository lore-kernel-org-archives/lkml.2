Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab0HXNTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:19:50 -0400
Received: from fieldses.org ([174.143.236.118]:38875 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab0HXNTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:19:49 -0400
Date: Tue, 24 Aug 2010 09:19:19 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        Neil Brown <neilb@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, adilger@sun.com, corbet@lwn.net,
        hooanon05@yahoo.co.jp, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
Message-ID: <20100824131919.GA25706@fieldses.org>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20100820083057.GA10039@infradead.org>
 <20100820195303.20b17210@notabene>
 <20100820115135.GQ31363@ZenIV.linux.org.uk>
 <20100821100900.4b15fe08@notabene>
 <20100821083024.GB3448@amd>
 <m3zkwgqp3c.fsf@linux.vnet.ibm.com>
 <20100824072155.GA3948@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824072155.GA3948@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 05:21:55PM +1000, Nick Piggin wrote:
> Right. Is this a really important goal, I'm wondering? Is it realistic
> (ie. to be able to remove the nfs server from the kernel)?

I think so.

The hardest part is if you want to export a filesystem that also has
non-nfs users--in the kernel it's much easier to maintain consistency
between local users of the filesystem and nfs clients.

If the server has no local users, then userspace may turn out to be
easier.

In that case you might ask why the server needs a real filesystem to
export at all--in theory it could maintain all its data on its own.  But
I suspect if you try that you find you're reinventing a lot of wheels.

--b.
