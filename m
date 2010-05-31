Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab0EaVkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 17:40:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58624 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab0EaVkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 17:40:21 -0400
Date: Mon, 31 May 2010 23:40:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf-record: Check correct pid when forking
Message-ID: <20100531214015.GA27050@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	LKML <linux-kernel@vger.kernel.org>
References: <20100531211818.GA30175@liondog.tnic>
 <20100531212723.GH5157@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100531212723.GH5157@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, May 31, 2010 at 11:27:26PM +0200

Hi Frederic :),

> On Mon, May 31, 2010 at 11:18:18PM +0200, Borislav Petkov wrote:
> > When forking the child to be traced, we should check the correct return
> > value from fork() and not a local variable which is otherwise unused.
> > 
> > Signed-off-by: Borislav Petkov <bp@alien8.de>
> > ---
> >  tools/perf/builtin-record.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > index 9bc8905..dc3435e 100644
> > --- a/tools/perf/builtin-record.c
> > +++ b/tools/perf/builtin-record.c
> > @@ -503,7 +503,6 @@ static int __cmd_record(int argc, const char **argv)
> >  {
> >  	int i, counter;
> >  	struct stat st;
> > -	pid_t pid = 0;
> >  	int flags;
> >  	int err;
> >  	unsigned long waking = 0;
> > @@ -572,7 +571,7 @@ static int __cmd_record(int argc, const char **argv)
> >  
> >  	if (forks) {
> >  		child_pid = fork();
> > -		if (pid < 0) {
> > +		if (child_pid < 0) {
> 
> 
> 
> Oops :)

Yeah, this looked really odd and I had recheck it couple of times just
to be sure I'm not missing any "hidden" semantics. And it seems that
nobody has hit that because obviously we always fork fine :)

-- 
Regards/Gruss,
    Boris.
