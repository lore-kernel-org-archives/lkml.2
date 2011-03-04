Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab1CDA74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 19:59:56 -0500
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:61381 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758930Ab1CDA7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 19:59:55 -0500
X-AuditID: 1209190d-b7cacae000000a14-4b-4d70398a0f11
Subject: Re: [PATCH] Make /proc/slabinfo 0400
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <1299191400.2071.203.camel@dan>
Date: Thu, 3 Mar 2011 19:50:43 -0500
Cc: Matt Mackall <mpm@selenic.com>, cl@linux-foundation.org,
        penberg@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <2DD7330B-2FED-4E58-A76D-93794A877A00@mit.edu>
References: <1299174652.2071.12.camel@dan>  <1299185882.3062.233.camel@calx> <1299186986.2071.90.camel@dan>  <1299188667.3062.259.camel@calx> <1299191400.2071.203.camel@dan>
To: Dan Rosenberg <drosenberg@vsecurity.com>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 3, 2011, at 5:30 PM, Dan Rosenberg wrote:

> I appreciate your input on this, you've made very reasonable points.
> I'm just not convinced that those few real users are being substantially
> inconvenienced, even if there's only a small benefit for the larger
> population of users who are at risk for attacks.  Perhaps others could
> contribute their opinions to the discussion.

Being able to monitor /proc/slabinfo is incredibly useful for finding various
kernel problems.  We can see if some part of the kernel is out of balance,
and we can also find memory leaks.   I once saved a school system's Linux
deployment because their systems were crashing once a week, and becoming
progressively more unreliable before they crashed, and the school board
was about to pull the plug.

Turned out the "virus scanner" was a piece of garbage that slowly leaked
memory over time, and since it was proprietary code that was loaded as 
a kernel module, it showed up in /proc/slabinfo.   If it had been protected
it would have been much harder for me to get access to such debugging
data.

I wonder if there is some other change we could make to the slab allocator
that would make it harder for exploit writers without having to protect the
/proc/slabinfo file.  For example, could we randomly select different free 
objects in a page instead of filling them in sequentially?

-- Ted

