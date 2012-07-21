Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2GUBTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 21:19:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36410 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2GUBTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 21:19:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120721005610.GB9399@thunk.org>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
	<0107910@agluck-desktop.sc.intel.com>
	<20120721005610.GB9399@thunk.org>
Date: Fri, 20 Jul 2012 18:19:33 -0700
X-Google-Sender-Auth: LwWdy4zpizS55PV6MA_o18dxs0Q
Message-ID: <CA+8MBbKroxc1p8+QOhEd6+gn2BD4ymcS7n7SOMR2=aiMW8waqA@mail.gmail.com>
Subject: Re: [PATCH] dmi: Feed DMI table to /dev/random driver
From: Tony Luck <tony.luck@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, mpm@selenic.com,
        nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
        davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 5:56 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> The other approach was to add some new interface that random.c would
> call which would grab the dmi data from rand_initialize().  But that's
> going to be a lot more complicated, so I guess we should go with the
> simple/stupid approach.

It wouldn't be all that hard ... we'd just need to add a new entry point
to the dmi codefor random to call (and a stub somewhere so that
CONFIG_DMI=n kernels still build). But getting some per-platform
data into the random pools earlier is a good thing ... it means that
users of random data will see the benefit earlier than they do now.

So add the big fat comment so that people know not to break this
useful (if not entirely intentional) functionality.

-Tony
