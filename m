Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab0KRR1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:27:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549Ab0KRR1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:27:19 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        tytso@mit.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
	<20101118130630.GJ6178@parisc-linux.org>
	<20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
	<20101118141957.GK6178@parisc-linux.org>
	<20101118142918.GA18510@infradead.org>
	<1290100750.3041.72.camel@mulgrave.site>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 18 Nov 2010 12:22:46 -0500
In-Reply-To: <1290100750.3041.72.camel@mulgrave.site> (James Bottomley's
	message of "Thu, 18 Nov 2010 11:19:10 -0600")
Message-ID: <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@suse.de> writes:

> Not stepping into the debate: I'm happy to see punch go to the mapping
> data and FITRIM pick it up later.
>
> However, I think it's time to question whether we actually still want to
> allow online discard at all.  Most of the benchmarks show it to be a net

Define online discard, please.

> lose to almost everything (either SSD or Thinly Provisioned arrays), so
> it's become an "enable this to degrade performance" option with no
> upside.

Some SSDs very much require TRIMming to perform well as they age.  If
you're suggesting that we move from doing discards in journal commits to
a batched discard, like the one Lukas implemented, then I think that's
fine.  If we need to reintroduce the finer-grained discards due to some
hardware changes in the future, we can always do that.

Cheers,
Jeff
