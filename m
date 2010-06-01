Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0FATBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:01:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59465 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab0FATBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:01:22 -0400
Date: Tue, 1 Jun 2010 20:01:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: Eric Paris <eparis@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v3] fs: allow protected cross-uid sticky symlinks
Message-ID: <20100601190102.GT31073@ZenIV.linux.org.uk>
References: <20100601185248.GB4098@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601185248.GB4098@outflux.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 11:52:48AM -0700, Kees Cook wrote:
> A long-standing class of security issues is the symlink-based
> time-of-check-time-of-use race, most commonly seen in world-writable
> directories like /tmp. The common method of exploitation of this flaw
> is to cross privilege boundaries when following a given symlink (i.e. a
> root process follows a symlink belonging to another user).  For a likely
> incomplete list of hundreds of examples across the years, please see:
> http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp
> 
> The solution is to permit symlinks to only be followed when outside a sticky
> world-writable directory, or when the uid of the symlink and follower match,
> or when the directory owner matches the symlink's owner.
> 
> Some pointers to the history of earlier discussion that I could find:

I don't buy it.  If we are concerned about the symlinks in the middle of
pathname, your checks are useless (mkdir /tmp/a, ln -s whatever /tmp/a/b,
have victim open /tmp/a/b/something).  If we are not, then your checks are
in the wrong place.

"The more we prohibit, the safer we are" is best left to the likes of TSA;
if we are really interested in security and not in security theatre or
BDSM fetishism, let's make sure that heuristics we use make sense.
