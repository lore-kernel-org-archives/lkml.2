Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab2BIVzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 16:55:49 -0500
Received: from seven.medozas.de ([188.40.89.202]:47875 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294Ab2BIVzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 16:55:46 -0500
Date: Thu, 9 Feb 2012 22:55:45 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] SubmittingPatches: Increase the line length limit from
 80 to 100 colums
In-Reply-To: <20120203100743.GA3334@elte.hu>
Message-ID: <alpine.LNX.2.01.1202092206040.11004@frira.zrqbmnf.qr>
References: <20120130140905.441199885@openvz.org> <20120130141852.309402052@openvz.org> <20120203074656.GC30543@elte.hu> <20120203083530.GD1968@moon> <20120203090929.GA23996@elte.hu> <20120203012241.bcd3d0c8.akpm@linux-foundation.org> <20120203095227.GA13162@elte.hu
 <20120203100743.GA3334@elte.hu>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 2012-02-03 11:07, Ingo Molnar wrote:

>[PATCH] SubmittingPatches: Increase the line length limit from 80 to 100 colums
>
>As far as I'm aware I was the last regular kernel contributor who
>still used a standard VGA text console, but both text (100 cols is
>also arguably closer to various brain limits such as vision of field
>and resolution restrictions

Please, no.

(Corollary 1) The older you get, the larger you like your glyphs to
be (...and the FOV is likely to lower as well).

14pt and up usually. And there is not a whole lot that fit on
10.1-inch netbook screens that way.

(Corollary 2) Travelers desire minimizing size and weight.

-----

As for checkpatch, I am throwing in the suggestion to augment checkpatch 
such that it does not look at whether single lines are over $limit, but 
whether a certain percentage of lines of a file is over $limit. That, 
together with a badness value that is e.g. following some power law to 
the amount of chars too much, but not when the line cannot be broken
in the first place. Maybe along the lines of

 #perlish#
 foreach (<>) {
     /^\s+\S+/;
     if (length($_) > length($&)) {
         push @candidate, $_;
         $badness += (length($_) - length($&)) ** 1.5;
     }
 }
 if ($badness > $threshold) {
     warn about @candidate_lines;
 }
