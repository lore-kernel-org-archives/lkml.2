Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2EEL5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 07:57:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55588 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2EEL5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 07:57:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120505145403.e73ce6633d2930ecde461bcf@canb.auug.org.au>
References: <1336186227-1941-1-git-send-email-pierre@spotify.com>
	<20120505145403.e73ce6633d2930ecde461bcf@canb.auug.org.au>
Date: Sat, 5 May 2012 13:57:47 +0200
Message-ID: <CAPXGRDmXxWr4p-S1RMRNG05nP1OEC8u++WqZY7jaPgcu7zQZtg@mail.gmail.com>
Subject: Re: [PATCH 1/1] procfs: expose umask in stat and status
From: Pierre Carrier <pierre@spotify.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 5, 2012 at 6:54 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Why not use "Umask:\t%#o\n" ? that way you don't get two zeros if the
> umask is zero.

Because of ignorance and laziness.
Just tried "%#o" with v3.4-rc5-182-g71eb557 and got equivalent results
to "0%o", including 0->"00".

So it's agreeably better, even we just don't see it yet.


On Sat, May 5, 2012 at 6:54 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> It would be good to tell us why we need this, of course.

Oops. I don't have a killer argument.

We happened to look for the information for a running service and
couldn't think of a simple, non-invasive solution.
It feels like it'd be useful to expose it.

I assumed status is a good fit (already has euid, egid and ngroups for example).
AFAICT there wouldn't be any significant security or performance implications.

But I could very well be missing something.


Thanks,

-- 
Pierre Carrier
Service Reliability Engineer
Spotify AB
