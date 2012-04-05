Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2DEUfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 16:35:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab2DEUfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 16:35:15 -0400
Date: Thu, 5 Apr 2012 13:31:53 -0700
From: Mel Gorman <mgorman@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stuart Foster <smf.linux@ntlworld.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [ 101/175] mm: vmscan: forcibly scan highmem if there are too
 many buffer_heads pinning highmem
Message-ID: <20120405202435.GA11562@suse.de>
References: <20120330194845.531765417@linuxfoundation.org>
 <1333422093.443.32.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1333422093.443.32.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the slow response. I was at LSF/MM and still at Collaboration
Summit and not keeping up with mail.

On Tue, Apr 03, 2012 at 04:01:33AM +0100, Ben Hutchings wrote:

> On Fri, 2012-03-30 at 12:50 -0700, Greg KH wrote:
> > 3.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Mel Gorman <mel@csn.ul.ie>
> > 
> > commit cc715d99e529d470dde2f33a6614f255adea71f3 upstream.
> > 
> > Stuart Foster reported on bugzilla that copying large amounts of data
> > from NTFS caused an OOM kill on 32-bit X86 with 16G of memory.  Andrew
> > Morton correctly identified that the problem was NTFS was using 512
> > blocks meaning each page had 8 buffer_heads in low memory pinning it.
> 
> I notice that this was not applied to 3.0.26 or 3.2.14.
> 

True.

> [...]
> > Addresses https://bugzilla.kernel.org/show_bug.cgi?id=42578
> [...]
> 
> but this bug was reported against 3.1.9, so the fix is presumably needed
> for 3.2 at least.
> 
> Presumably the upstream change doesn't apply cleanly and would need to
> be backported.  Is anyone planning to do that?
> 

It probably does not apply cleanly and considering how the bug is
triggered I was not treating it as a high priority. Nikola Ciprich
(added to cc) had said that he might try backporting it and I would
review the result. I have not heard anything since. I can take a look at
backporting it next week if it is considered a common problem.

-- 
Mel Gorman
SUSE Labs
