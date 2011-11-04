Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab1KDOIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:08:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35633 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab1KDOIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:08:16 -0400
MIME-Version: 1.0
Message-ID: <904b5bd7-efef-49fe-8413-966f0a554d1e@default>
Date: Fri, 4 Nov 2011 07:01:23 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Neo Jia <cyclonusj@gmail.com>, levinsasha928@gmail.com,
        JeremyFitzhardinge <jeremy@goop.org>, linux-mm@kvack.org,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Chris Mason <chris.mason@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, ngupta@vflare.org,
        LKML <linux-kernel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [GIT PULL] mm: frontswap (SUMMARY)
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4EB3F047.0073,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and Linux --

I thought I'd try to summarize for you the current status
resulting from the 100+ emails stemming from the original
git-pull request.

EXECUTIVE SUMMARY (djm bias noted)

Frontswap is part 2 of 2 of transcendent memory; cleancache
(merged at 3.0) is part 1.  Frontswap consists primarily of
a handful of hooks in the swap subsystem, which end
in a frontswap_ops function vector.  If no "backend"
registers the vector, all hooks become no-ops.  Current
in-tree users are Xen, and "zcache" (in staging), but
two other users, RAMster and KVM, are under development
in public git trees.

Xen is by far the most mature user for frontswap.  If you
count Xen as a valid user, you should IMHO seriously consider
the commit-set, as-is, as ready to merge (even for 3.2),
especially since shipping distros already include it.
If one disregards Xen, there's a lot more work to be done
to prove frontswap should be merged.

RESPONDED TO SUPPORT FRONTSWAP

Jan Beulich (Novell): frontswap in OpenSuse for two years
Brian King (IBM): wants frontswap/zcache for Linux on Power
Sasha Levin (*): actively developing KVM+tmem, wants frontswap
Neo Jia (*): actively developing KVM+tmem, wants frontswap
Nitin Gupta (UMass): zcache co-designer, better than zram
Seth Jennings (IBM): actively improving zcache
Ed Tomlinson (* user): wants frontswap instead of zram
Kurt Hackel (Oracle): shipping Oracle VM product supports frontswap
Avi Miller (Oracle): Beta of next Oracle kernel supports frontswap

Note: Oracle, as a company, has committed to support frontswap.

* affiliation unspecified (but not Oracle ;-)

LAST KNOWN POSITION OF AD HOC ARCHITECTURE REVIEW GROUP

Andrea: zcache still needs a lot of work, has ideas for
  future related swap improvements, "now that you cleared the
  fact there is no API/ABI in [zcache] to worry about, frankly,
  I'm a lot more happy  now", "don't want to stifle innovation
  by saying no to something that makes sense and is free to
  evolve", "this overall sounds very positive (or at least
  better than neutral) to me"... I also think Andrea's
  last remaining issue (need batching for KVM) now has a viable
  solution that works with no frontswap commit-set changes,
  but Andrea has not confirmed

Rik: list of concerns, but I think all were discussed and
  resolved later in the thread (except possibly wanting to
  see more non-Xen benchmarks), no final response from Rik

James: wants more benchmarks especially for zcache, thinks
  ABI should be proven to be useful to KVM before
  frontswap gets merged

Hannes: Nacked, but I think raised issues were later
 discussed and resolved in the thread, with no further
 response from Hannes

 (If anyone quoted here feels misquoted/missummarized,
please feel free to respond.)
