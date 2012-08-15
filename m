Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2HONM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:12:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42913 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab2HONM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:12:57 -0400
Date: Wed, 15 Aug 2012 10:12:46 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>, paulus@samba.org,
        Ingo Molnar <mingo@kernel.org>, Palmer Cox <p@lmercox.com>,
        Jan Beulich <JBeulich@suse.com>, Michael Witten <mfwitten@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [perf] make clean problematic bashism
Message-ID: <20120815131245.GF2370@infradead.org>
References: <502B714E.4010700@cwi.nl>
 <1345026408.31459.60.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345026408.31459.60.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 15, 2012 at 12:26:48PM +0200, Peter Zijlstra escreveu:
> On Wed, 2012-08-15 at 11:52 +0200, Wouter M. Koolen wrote:
> > The reason for this was a bunch of generated empty flex files in util/ 
> > that were not removed by make clean. They are intended to be erased, 
> > since the Makefile executes

> > rm -f util/*-{bison,flex}*

> > however, this command does not remove the files. I guess because {,} 
> > alternatives are only special in bash but the makefile is run with some 
> > other shell?

> ISTR us getting a number of such patches, did we miss a site, acme?

[acme@sandy linux]$ git describe --match 'v[0-9].[0-9]*' 7f309ed6453926a81e2a97d274f67f1e48f0d74c
v3.5-358-g7f309ed
[acme@sandy linux]$ git show --oneline  7f309ed6453926a81e2a97d274f67f1e48f0d74c
7f309ed perf tools: Remove brace expansion from clean target
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 32912af..35655c3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -987,7 +987,8 @@ clean:
        $(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
        $(MAKE) -C Documentation/ clean
        $(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
-       $(RM) $(OUTPUT)util/*-{bison,flex}*
+       $(RM) $(OUTPUT)util/*-bison*
+       $(RM) $(OUTPUT)util/*-flex*
        $(python-clean)
 
 .PHONY: all install clean strip $(LIBTRACEEVENT)
[acme@sandy linux]$
 
> > I got perf to compile now, but thought you would be interested to know 
> > about this little problem.

> > PS: as a side note: GNU make has the .DELETE_ON_ERROR: special target, 
> > which removes the target file when its generating command fails. This 
> > would have prevented my problem and sounds like a good idea in general. 
> > Maybe perf could make use of this feature when on GNU make?
 
> I don't think we build with anything but gnu make, mind sending a patch
> implementing your suggestion?

Yeah, please submit a patch,

- Arnaldo
