Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab1BVUzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:55:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45145 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1BVUzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:55:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vh0zCo33fUeNPetJKa7rutr5lr8izr7UZV9OibP0Rv5ZVoGreWNMqcfa5qMnFKLcMM
         gHQaX1FrThrBhWOaHX/XF1/iw6hTPoh+OZEDcL64iAK/Ks2Q8zVP+4w2j4P4tQRNOTwm
         QH5sV0Fw1MYqoQvdbWzk0UEyD6BnzNICsIuEQ=
Date: Tue, 22 Feb 2011 21:53:12 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf lock: show valid sort keys in usage
Message-ID: <20110222205312.GA18474@joi.lan>
References: <20110222174557.GB9687@joi.lan>
 <20110222180110.GG27070@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222180110.GG27070@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 03:01:10PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Feb 22, 2011 at 06:45:57PM +0100, Marcin Slusarz escreveu:
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > ---
> >  tools/perf/builtin-lock.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> > index 2b36def..0305a40 100644
> > --- a/tools/perf/builtin-lock.c
> > +++ b/tools/perf/builtin-lock.c
> > @@ -893,7 +893,7 @@ static const char * const report_usage[] = {
> >  
> >  static const struct option report_options[] = {
> >  	OPT_STRING('k', "key", &sort_key, "acquired",
> > -		    "key for sorting"),
> > +		    "key for sorting (acquired / contended / wait_total / wait_max / wait_min)"),
> >  	/* TODO: type */
> >  	OPT_END()
> >  };
> 
> Can you please add to tools/perf/Documentation/perf-lock.txt too?

Sure. 

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] perf lock: document valid sort keys

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 tools/perf/Documentation/perf-lock.txt |   12 ++++++++++--
 tools/perf/builtin-lock.c              |    2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-lock.txt b/tools/perf/Documentation/perf-lock.txt
index 921de25..4d3314b 100644
--- a/tools/perf/Documentation/perf-lock.txt
+++ b/tools/perf/Documentation/perf-lock.txt
@@ -24,8 +24,8 @@ and statistics with this 'perf lock' command.
 
   'perf lock report' reports statistical data.
 
-OPTIONS
--------
+COMMON OPTIONS
+--------------
 
 -i::
 --input=<file>::
@@ -39,6 +39,14 @@ OPTIONS
 --dump-raw-trace::
         Dump raw trace in ASCII.
 
+REPORT OPTIONS
+--------------
+
+-k::
+--key=<value>::
+        Sorting key. Possible values: acquired (default), contended,
+        wait_total, wait_max, wait_min.
+
 SEE ALSO
 --------
 linkperf:perf[1]
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 2b7eb18..812ad26 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -904,7 +904,7 @@ static const char * const report_usage[] = {
 
 static const struct option report_options[] = {
 	OPT_STRING('k', "key", &sort_key, "acquired",
-		    "key for sorting"),
+		    "key for sorting (acquired / contended / wait_total / wait_max / wait_min)"),
 	/* TODO: type */
 	OPT_END()
 };
-- 
1.7.4.rc3
