Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2IGP0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:26:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53644 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2IGP0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:26:37 -0400
Message-ID: <1347031571.18408.85.camel@twins>
Subject: Re: [PATCH 09/12] perf diff: Add weighted diff computation way to
 compare hist entries
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Date: Fri, 07 Sep 2012 17:26:11 +0200
In-Reply-To: <1347024784.1505.12.camel@leonhard>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
	 <1346946426-13496-10-git-send-email-jolsa@redhat.com>
	 <87wr06bchw.fsf@sejong.aot.lge.com>
	 <20120907092831.GB3411@krava.brq.redhat.com>
	 <1347024784.1505.12.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 22:33 +0900, Namhyung Kim wrote:
> 2012-09-07 (금), 11:28 +0200, Jiri Olsa:
> > On Fri, Sep 07, 2012 at 02:58:19PM +0900, Namhyung Kim wrote:
> > > I don't see why this do { } while(0) loop is necessary.
> > > How about this?
> > > 
> > > 	w1 = strtol(opt, &tmp, 10);
> > > 	if (*tmp != ',')
> > > 		goto error;
> > > 
> > > 	opt = tmp + 1;
> > > 	w2 = strtol(opt, &tmp, 10);
> > > 	if (*tmp != '\0')
> > > 		goto error;
> > > 
> > > 	if (!w1 || !w2)
> > > 		goto error;
> > 
> > I do this not to use labels & goto ;)
> 
> But isn't it usual?  Do you have a reason not to do it?
> 
> I was a bit confused finding which path actually make it a loop... but
> there's none. :-/

I fully agree, please use goto, there's nothing wrong with them, esp. if
not using them obfuscates the code.
