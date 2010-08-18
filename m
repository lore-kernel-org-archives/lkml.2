Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab0HRVs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 17:48:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab0HRVsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 17:48:25 -0400
Date: Wed, 18 Aug 2010 17:48:18 -0400
From: Dave Jones <davej@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: apw@canonical.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: add memset checks to checkpatch.pl
Message-ID: <20100818214818.GA31094@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Joe Perches <joe@perches.com>, apw@canonical.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20100818204016.GA29640@redhat.com>
 <1282167133.6724.165.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282167133.6724.165.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 02:32:13PM -0700, Joe Perches wrote:
 > On Wed, 2010-08-18 at 16:40 -0400, Dave Jones wrote:
 > > Occasionally someone goofs the argument order to memset.
 > > This patch makes checkpatch catch those.
 > > 
 > > I made memset with size of 0 an error, because it's never correct,
 > > whereas memset with a size of 1 isn't technically an incorrect
 > > thing to do so I left it as a warning. It may still be better to replace
 > > it with a single variable assignment in the false positive cases.
 > 
 > Maybe something like allows more flexible checking?
 > 
 > 	if ($line =~ /\bmemset\s*\(\s*($Lval)\s*,\s*($Lval)\s*,\s*($Lval)\s*\)/) {
 > 		my $memset_addr = $1;
 > 		my $memset_val = $2;
 > 		my $memset_size = $3;
 > 		if ($memset_size =~ /(0x|)0$/i) {
 > 			ERROR("memset uses second argument as constant byte value, not third.\n" . $herecurr);
 > 		elsif ($memset_size =~ /(0x|)1/i) {
 > 			WARN("single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . $herecurr);
 > 		}
 > 	}

I'm all for improving my shoddy perl where possible, but this doesn't seem to actually
catch any of the test cases I wrote.  (it's also missing a } )

	Dave

