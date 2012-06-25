Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab2FYIWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 04:22:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51728 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2FYIWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 04:22:31 -0400
Date: Mon, 25 Jun 2012 10:22:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, David Ahern <dsahern@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Shan Wei <davidshan@tencent.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 00/20] perf/core improvements
Message-ID: <20120625082225.GB24512@gmail.com>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
 <20120620120141.GB1925@gmail.com>
 <1340201223.1520.5.camel@leonhard>
 <20120620144902.GB2007@gmail.com>
 <87lijgkmlw.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lijgkmlw.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hi, Ingo
> 
> On Wed, 20 Jun 2012 16:49:02 +0200, Ingo Molnar wrote:
> > Well, 'make' should notice that they are stale or should 
> > regenerate them all the time.
> >
> 
> Could you check the patch below does it?
> 
> 
> diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> index 3d69aa9ff51e..42f018e15f36 100644
> --- a/tools/lib/traceevent/Makefile
> +++ b/tools/lib/traceevent/Makefile
> @@ -250,8 +250,12 @@ endef
>  all_objs := $(sort $(ALL_OBJS))
>  all_deps := $(all_objs:%.o=.%.d)
>  
> +# let .d file also depends on the source and header files
>  define check_deps
> -               $(CC) -M $(CFLAGS) $< > $@;
> +               @set -e; $(RM) $@; \
> +               $(CC) -M $(CFLAGS) $< > $@.$$$$; \
> +               sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
> +               $(RM) $@.$$$$
>  endef

Yeah, something like this should do the trick.

Thanks,

	Ingo
