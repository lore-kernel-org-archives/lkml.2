Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab2FOMZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:25:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab2FOMZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:25:43 -0400
X-Authority-Analysis: v=2.0 cv=NbpkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ag8JG7z7P3cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=oKSlQLE3GBj-n7PoBQgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339763129.13377.357.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/3] tools lib traceevent: Introduce pevent_strerror
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Fri, 15 Jun 2012 08:25:29 -0400
In-Reply-To: <87ipet3pzf.fsf@sejong.aot.lge.com>
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
	 <1339486959-25241-4-git-send-email-namhyung@kernel.org>
	 <1339524114.13377.140.camel@gandalf.stny.rr.com>
	 <87ehpj6hic.fsf@sejong.aot.lge.com>
	 <1339730825.13377.311.camel@gandalf.stny.rr.com>
	 <87ipet3pzf.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 18:04 +0900, Namhyung Kim wrote:

> 
> > If you need the code to be thread safe, have all errors do:
> >
> > 	ret = pevent_foo();
> > 	if (ret < 0) {
> > 		pevent_strerr_val(ret, buf, buflen);
> >
> >
> > For programs that do not need to be thread safe, then:
> >
> > 	ret = pevent_foo();
> > 	if (ret < 0) {
> > 		pevent_strerr(pevent, buf, buflen);
> >
> 
> Do we really need these two? I think having a single API is just
> enough, IMHO.

Hmm, maybe not. I guess I was confused about the need to pass the pevent
into the function. I think we only need the return val. Or is there
other data in the future that you envision will require needing pevent
passed in?

-- Steve


