Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab1IAWUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:20:20 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56181 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082Ab1IAWUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:20:18 -0400
Date: Thu, 1 Sep 2011 15:18:54 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Bob Pearson <rpearson@systemfabricworks.com>
Cc: "'Andreas Dilger'" <adilger.kernel@dilger.ca>,
        "'Herbert Xu'" <herbert@gondor.hengli.com.au>,
        "'Theodore Tso'" <tytso@mit.edu>,
        "'David Miller'" <davem@davemloft.net>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Mingming Cao'" <cmm@us.ibm.com>,
        "'linux-crypto'" <linux-crypto@vger.kernel.org>,
        "'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Message-ID: <20110901221854.GA12086@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110901003317.32645.16843.stgit@elm3c44.beaverton.ibm.com> <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com> <03ac01cc6869$9cd23b60$d676b220$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03ac01cc6869$9cd23b60$d676b220$@systemfabricworks.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 12:40:08AM -0500, Bob Pearson wrote:
> Hi Darrick,
> 
> The same code in crc32.c was helpful to measure performance and help code
> tuning as well as indicate correctness. Otherwise the code in crypto may be
> enough to test all the corner cases. If this survives the review I wonder if
> there is a way to combine crc32 and crc32c together somehow. I like yours
> because you can load/unload and not need the memory permanently.

I suspect it would be pretty easy to adapt the Makefile to generate the
relevant .c and .h files; in particular it could be useful to use the crypto
framework for crc32 on the off chance anyone wants to provide hwaccel for that
too.

That said, merging libcrc32c-test vectors with the existing one (sorry, I
didn't realize that existed) shouldn't be too difficult.

--D
