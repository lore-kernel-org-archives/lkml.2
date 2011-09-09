Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab1IIWcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 18:32:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40496 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759098Ab1IIWcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 18:32:08 -0400
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct
 _ddebug descriptor definitions
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        gregkh@suse.de, Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 09 Sep 2011 15:32:05 -0700
In-Reply-To: <CAJfuBxwtefLyJcz1EbKvsGJ+XMtJiRW7A3Yy+wHXgL3GpUXbSg@mail.gmail.com>
References: <cover.1314725877.git.jbaron@redhat.com>
	 <94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
	 <20110908165230.a7505321.akpm@linux-foundation.org>
	 <1315534396.11939.10.camel@Joe-Laptop>
	 <20110908204200.6cf7abc2.akpm@linux-foundation.org>
	 <1315540963.11939.12.camel@Joe-Laptop>
	 <CAO+b5-oOHXEhnA+zpwA9GR7k1TX3Wn6XuOdc3TB4MPNiSpskiw@mail.gmail.com>
	 <CAJfuBxx=r_P7em_naUN_c96A++V4v6nfd8B_V2dppRag-z_qwg@mail.gmail.com>
	 <1315602252.23777.5.camel@Joe-Laptop>
	 <CAJfuBxwtefLyJcz1EbKvsGJ+XMtJiRW7A3Yy+wHXgL3GpUXbSg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1315607527.23777.21.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 16:06 -0600, Jim Cromie wrote:
> The trick is then to allow those users to define flag-chars that they like
> (mnemonic value), and that work with the dynamic-debug mini-language
> implemented in $CONTROL reader.

I don't think that's a problem really.

I think a simple control/test variable as either value
or mask would work fine.

Take a single bit control to either test as mask
or test as level.  No mnemonic letters needed.

pr_debug_mask(mask, fmt, ...)
pr_debug_level(level, fmt, ...)

could set the appropriate type bit in the struct
so the test works as appropriate.

echo 'value <foo>' > <debugfs>/dynamic_debug/control

> But that begs the question - is there a reason why __aligned(4)
> wouldnt work for 32 bit machines ?   It would reduce the footprint
> for small machines.

No real idea why it's aligned(8).  Jason?

> Also, what is your notion of level ?

Driver specific value.
Look at the _dbg uses in drivers/net/wireless/ath for example.
I believe there are only two types of uses in the kernel:
module debug level and module debug mask output controls.

> it is independent of the error,warning,info,debug levels correct ?

Yes.  Attached to debug output only.


