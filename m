Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab0KRXyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:54:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46566 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab0KRXyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:54:00 -0500
To: Mark Lord <kernel@teksavvy.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <matthew@wil.cx>, Josef Bacik <josef@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
	<20101118130630.GJ6178@parisc-linux.org>
	<20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
	<20101118141957.GK6178@parisc-linux.org>
	<20101118142918.GA18510@infradead.org>
	<1290100750.3041.72.camel@mulgrave.site>
	<x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
	<1290102098.3041.77.camel@mulgrave.site>
	<AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
	<4CE59E57.2090009@teksavvy.com>
Date: Thu, 18 Nov 2010 18:52:19 -0500
In-Reply-To: <4CE59E57.2090009@teksavvy.com> (Mark Lord's message of "Thu, 18
	Nov 2010 16:44:55 -0500")
Message-ID: <yq1r5eiw5os.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mark" == Mark Lord <kernel@teksavvy.com> writes:

>> 2) FITRIM doesn't leverage the fact the a TRIM command can handle
>> multiple ranges per TRIM command payload.  I haven't seen any FITRIM
>> vs. wiper.sh benchmarks, so I don't know what impact that has in
>> practice.  Mark Lord thought that this lacking feature would cause
>> FITRIM to take minutes or hours with some hardware.  Especially early
>> generation SSDs.

Mark> If FITRIM is still issuing single-range-at-a-time TRIMs, then I'd
Mark> call that a BUG that needs fixing.  Doing TRIM like that causes
Mark> tons of unnecessary ERASE cycles, shortening the SSD lifetime.  It
Mark> really needs to batch them into groups of (up to) 64 ranges at a
Mark> time (64 ranges fits into a single 512-byte parameter block).

We don't support coalescing discontiguous requests into one command. But
we will issue contiguous TRIM requests as big as the payload can
handle. That's just short of two gigs per command given a 512-byte
block.

I spent quite a bit of time trying to make coalescing work in the
spring. It got very big and unwieldy. When we discussed it at the
filesystem summit the consensus was that it was too intrusive to the I/O
stack, elevators, etc.

I have previously posted a list of reasons why it is hard to support
given how our I/O stack works. I can dig them out if there's interest.

-- 
Martin K. Petersen	Oracle Linux Engineering
