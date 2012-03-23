Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab2CWBnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 21:43:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49952 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2CWBnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 21:43:04 -0400
Date: Fri, 23 Mar 2012 01:42:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Christopher Li <sparse@chrisli.org>
Subject: Re: [PATCH 00/16] mm: prepare for converting vm->vm_flags to 64-bit
Message-ID: <20120323014251.GH6589@ZenIV.linux.org.uk>
References: <20120321100602.GA5522@barrios>
 <4F69D496.2040509@openvz.org>
 <20120322142647.42395398.akpm@linux-foundation.org>
 <20120322212810.GE6589@ZenIV.linux.org.uk>
 <20120322144122.59d12051.akpm@linux-foundation.org>
 <4F6BA221.8020602@openvz.org>
 <4F6BA69F.1040707@openvz.org>
 <CA+55aFz4hWfT5c93rUWvN4OsYHjOSAjmNtoT7Rkjz7kYsaC7xg@mail.gmail.com>
 <4F6BAD15.90802@openvz.org>
 <20120322160944.ad06e559.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322160944.ad06e559.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 04:09:44PM -0700, Andrew Morton wrote:

> > Thanks. Looks like "__nocast" totally undocumented.
> > It would be nice to add something about this into Documentation/sparse.txt
> 
> Yup, Chris has added this to his todo list (thanks!).

Alternatively, we could just remove the remaining instances in the kernel -
cputime_t is the only borderline reasonable one there; xfs ones should be
__bitwise and so should zd_addr_t thing (with cpu_to_le16() moved from
uses of those suckers to macro definitions).  Hell knows - I suspect that
cputime_t also might've been turned into __bitwise u64, but I hadn't checked
if we ever do plain arithmetics on those...
