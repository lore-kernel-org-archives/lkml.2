Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2ISM07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 08:26:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54848 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab2ISM04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 08:26:56 -0400
Subject: Re: [PATCH] tools lib traceevent: Handle alloc_arg failure
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>
In-Reply-To: <20120919114258.GA16696@gmail.com>
References: <87boh23epi.fsf@sejong.aot.lge.com>
	 <1348037109-17252-1-git-send-email-namhyung@kernel.org>
	 <20120919114258.GA16696@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Sep 2012 21:26:49 +0900
Message-ID: <1348057609.1644.9.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

2012-09-19 (수), 13:42 +0200, Ingo Molnar:
> * Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > +		if (!left) {
> > +			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
> > +			goto out_free;
> 
> > +		if (!right) {
> > +			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
> > +			goto out_free;
> > +		}
> 
> > +		if (!left) {
> > +			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
> > +			goto out_free;
> > +		}
> 
> > +		if (!left) {
> > +			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
> > +			goto out_free;
> > +		}
> 
> > +		if (!right) {
> > +			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
> > +			goto out_free;
> > +		}
> 
> > +		if (!left) {
> > +			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
> > +			goto out_free;
> > +		}
> 
> These repetitive patterns are seriously uglifying the code and 
> are crying out loud for a out_war_free label:
> 
> 		if (!left)
> 			goto out_warn_free;

Yeah, I agree.  But I wanted to add a bit more helpful (to developers)
info - function name and line number - rather than just "not enough
memory" message.  Maybe we could change do_warning to emit such info
automatically.

Thanks,
Namhyung



