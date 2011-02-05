Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab1BEAiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 19:38:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39209 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1BEAiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 19:38:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=A2DFqCS1OvLRPGrLLdFIDG9zAiDma/GfPmhsjMmaKvGFxEvwyN10JL4xzg/6DQAhi3
         FJyvvRpFXvVXn+QYGUpKc5WBDYk3XmhjeyBO1HW7o3UMS4lRhswLWyeTRozquZk9U2ql
         uk/fQMaFzKoW/Ins2srWRqjT9CCEFDp9q0Hxw=
Date: Sat, 5 Feb 2011 01:38:14 +0100
From: Ulf Magnusson <ulfalizer.lkml@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kbuild@vger.kernel.org,
        zippel@linux-m68k.org, mmarek@suse.cz, akpm@linux-foundation.org,
        andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] [ANNOUNCE] kconfig: Kconfiglib: a flexible Python
 Kconfig parser
Message-ID: <20110205003813.GB13060@ulf>
Mail-Followup-To: Ulf Magnusson <ulfalizer.lkml@gmail.com>,
	Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
	linux-kbuild@vger.kernel.org, zippel@linux-m68k.org, mmarek@suse.cz,
	akpm@linux-foundation.org, andrea.gelmini@gelma.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20110201232750.GA30800@ulf>
 <20110204143529.f49e92e5.rdunlap@xenotime.net>
 <4D4C8EFA.40207@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D4C8EFA.40207@landley.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 05:42:50PM -0600, Rob Landley wrote:
> On 02/04/2011 04:35 PM, Randy Dunlap wrote:
> >> The patch should be preferably be applied to a recent kernel, i.e. Linus's
> >> (2.6.38-rc3 at the time of writing).  Due to recent Kconfig changes, the
> >> kconfigtest.py test suite - which compares output character-for-character -
> >> will indicate failure on older (a few months old) kernels versions even though
> >> the outputs are functionally equivalent.
> >>
> >>  Documentation/kbuild/kconfig-language.txt |    5 +
> >>  Documentation/kbuild/kconfig.txt          |    8 +
> >>  README                                    |   13 +
> >>  scripts/kconfig/Makefile                  |   26 +-
> >>  scripts/kconfig/kconfiglib.py             | 3918 +++++++++++++++++++++++++++++
> >>  scripts/kconfig/kconfigtest.py            |  396 +++
> >>  6 files changed, 4365 insertions(+), 1 deletions(-)
> >>  create mode 100644 scripts/kconfig/kconfiglib.py
> >>  create mode 100644 scripts/kconfig/kconfigtest.py
> 
> Wait, I thought this was an extra standalone library.  Are you saying
> you want to make it so Linux will no longer compile on a build machine
> that doesn't have Python installed?

No - it's completely standalone, and should have no effect on things
that do not use Kconfiglib. The only changes besides adding the script
itself is to add two (well, three - there's one that's only used by
kconfigtest.py) targets to scripts/kconfig/Makefile that make it easier
to use the library by ensuring the environment is set up correctly.

> 
> If this is merely an extra developer tool ala bloat-o-meter and
> checkpatch.pl then it's merely uninteresting to me.  (I myself wrote a
> quick and dirty http://kernel.org/doc/make/menuconfig2html.py to
> generate http://kernel.org/doc/menuconfig/x86.html and friends years
> ago, and I still run it to update that once in a while.  There's not
> much to it.)
> 
> But adding new prerequities to a build machine would be really annoying
> for my use cases.
> 
> Rob

You would only need to have Python installed if you are going to use
Kconfiglib directly (hard to get around with a Python library).

/Ulf
