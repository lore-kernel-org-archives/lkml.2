Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031289Ab2CVV55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:57:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44065 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031169Ab2CVV5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:57:53 -0400
Date: Thu, 22 Mar 2012 21:57:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 00/16] mm: prepare for converting vm->vm_flags to 64-bit
Message-ID: <20120322215744.GF6589@ZenIV.linux.org.uk>
References: <20120321065140.13852.52315.stgit@zurg>
 <20120321100602.GA5522@barrios>
 <4F69D496.2040509@openvz.org>
 <20120322142647.42395398.akpm@linux-foundation.org>
 <20120322212810.GE6589@ZenIV.linux.org.uk>
 <20120322144122.59d12051.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322144122.59d12051.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 02:41:22PM -0700, Andrew Morton wrote:
> On Thu, 22 Mar 2012 21:28:11 +0000
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > On Thu, Mar 22, 2012 at 02:26:47PM -0700, Andrew Morton wrote:
> > > It would be nice to find some way of triggering compiler warnings or
> > > sparse warnings if someone mixes a 32-bit type with a vm_flags_t.  Any
> > > thoughts on this?
> > > 
> > > (Maybe that's what __nocast does, but Documentation/sparse.txt doesn't
> > > describe it)
> > 
> > Use __bitwise for that - check how gfp_t is handled.
> 
> So what does __nocast do?

Not much...  Basically, extending conversions.  __nocast int can be
freely mixed with int - no complaints will be given.

As far as I'm concerned, it's deprecated - it's weaker than __bitwise and
doesn't have particulary useful semantics.  For this kind of stuff (flags)
__bitwise is definitely better - that's what it had been implemented for.
