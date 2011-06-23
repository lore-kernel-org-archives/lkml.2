Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab1FWKtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 06:49:09 -0400
Received: from openfortress.nl ([213.189.19.244]:35157 "EHLO fame.vanrein.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759157Ab1FWKtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 06:49:07 -0400
Date: Thu, 23 Jun 2011 10:49:03 +0000
From: Rick van Rein <rick@vanrein.org>
To: Rick van Rein <rick@vanrein.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Stefan Assmann <sassmann@kpanic.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, rdunlap@xenotime.net, Nancy Yuen <yuenn@google.com>,
        Michael Ditto <mditto@google.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-ID: <20110623104903.GA14754@phantom.vanrein.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <4E023142.1080605@zytor.com> <4E0250F2.2010607@kpanic.de> <4E0251AB.8090702@zytor.com> <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110622110034.89ee399c.akpm@linux-foundation.org> <4E024E31.50901@kpanic.de> <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <4E023142.1080605@zytor.com> <20110623103320.GB2910@phantom.vanrein.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623103320.GB2910@phantom.vanrein.org>
X-My-Coolest-Hack: http://rick.vanrein.org/linux/badram -> Exploit broken RAM
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My last email may have assumed that you knew all about BadRAM; this
is probably worth an expansion:

> If you plug 10 DIMMs into your machine, and each has a faulty row
> somewhere, then you will get into trouble if you stick to 5 patterns.

With "trouble" I mean that a 6th pattern would be merged with the
nearest of the already-found 5 patterns.  It may be that this leads
to a pattern that covers more addresses than strictly needed.  This
is how I can guarantee that there are never more than 5 patterns,
and so never more than the cmdline can take.  No cut-offs are made.

> But if you happen to run into a faulty DIMM from time to time, the
> patterns should be your way out.

...without needing to be more general than really required.  Of course,
if all your PCs ran on 10 DIMMs, you could expand the number of
patterns to a comfortably higher number, but what I've seen with the
various cases I've supported, this has never been necessary.

> > that would mean running in a known-bad configuration,
> > and even a hard crash would be better.
> 
> ...which is so sensible that it was of course taken into account in
> the BadRAM design!

Meaning, that is why patterns are merged if the exceed the rather high
number of 5 patterns.  Rather waste those extra pages than running
into a known fault.

This high number of patterns is not at all common, however, making it
safe to assume that the figure is high enough, in spite of leaving
space on even LILO's cmdline to support adding several other tweaks.


-Rick
