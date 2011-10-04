Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1JDHA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:00:28 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:47055 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab1JDHA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:00:27 -0400
Date: Tue, 4 Oct 2011 07:59:53 +0100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Mingming Cao <cmm@us.ibm.com>, David Miller <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v4] crc32c: Implement CRC32c with slicing-by-8 algorithm
Message-ID: <20111004065953.GA16606@gondor.apana.org.au>
References: <20110930192956.4176.29905.stgit@elm3c44.beaverton.ibm.com> <OF54094699.6F5CF2B6-ONC125791C.004C901C-C125791C.004D1A61@transmode.se> <20111003153634.GA12447@tux1.beaverton.ibm.com> <OFA190E2A9.231A7DD6-ONC125791E.006F1765-C125791E.00705758@transmode.se> <20111003203513.GA10346@gondor.apana.org.au> <20111004005510.GB12447@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004005510.GB12447@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 05:55:10PM -0700, Darrick J. Wong wrote:
>
> So what I think I'm hearing is...
> 
> 1. Apply Bob's slice-by-8 algorithm patch to regular crc32.
> 2. Adapt crc32's build code to generate crc32c as well.
> 3. Remove crypto/crc32c.c's implementation and have it wrap the code generated
>    by #2.
> 4. Retain the current libcrc32c.  I guess if you don't configure CRYPTO and
>    CRYPTO_CRC32C then it could also just reference the generated crc32c functions
>    directly.
> 
> Is this a satisfactory way to move forward?

All good except that you don't really have to touch libcrc32c
at all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
