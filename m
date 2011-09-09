Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756Ab1IIVEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 17:04:15 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60432 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933345Ab1IIVEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 17:04:14 -0400
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct
 _ddebug descriptor definitions
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        gregkh@suse.de, Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 09 Sep 2011 14:04:11 -0700
In-Reply-To: <CAJfuBxx=r_P7em_naUN_c96A++V4v6nfd8B_V2dppRag-z_qwg@mail.gmail.com>
References: <cover.1314725877.git.jbaron@redhat.com>
	 <94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
	 <20110908165230.a7505321.akpm@linux-foundation.org>
	 <1315534396.11939.10.camel@Joe-Laptop>
	 <20110908204200.6cf7abc2.akpm@linux-foundation.org>
	 <1315540963.11939.12.camel@Joe-Laptop>
	 <CAO+b5-oOHXEhnA+zpwA9GR7k1TX3Wn6XuOdc3TB4MPNiSpskiw@mail.gmail.com>
	 <CAJfuBxx=r_P7em_naUN_c96A++V4v6nfd8B_V2dppRag-z_qwg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1315602252.23777.5.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 13:23 -0600, Jim Cromie wrote:
> It also allows for "lite" usage of dynamic-debug,
> including 1..few descriptor per file or module to control all debug printing.
> As outlined, this "lite" usage is determined by the coder,
> it would be cool if it were more configurable than that,
> but I dont see how that would work atm.

General problem is that there are subsystems that use
bitmasks with more than a just a few bits defined.

> Now that the worms have escaped the can, one other thought:
> 	unsigned int lineno:24;
> allows for insanely large files.  The largest in the tree is 29k,
> 16 bits would cover all files likely to be accepted in the future.

I hope ever.

> Since since it works with module/file/function filtering, 3-4 user
> flags should be plenty.

I rather doubt it as there are both level and mask uses.

There is no real issue with adding another flag value
to the struct anyway.  It's declared __aligned(8) and
it ends in an unaligned single char so there's space
for another u32 without extending the structure size.



