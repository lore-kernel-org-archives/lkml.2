Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab2HQQEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:04:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64230 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab2HQQDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:03:51 -0400
Subject: Re: [PATCH v2 2/5] perf ui/tui: Add tui.h header
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120816193711.GA10277@infradead.org>
References: <1345104894-14205-1-git-send-email-namhyung@kernel.org>
	 <1345104894-14205-2-git-send-email-namhyung@kernel.org>
	 <20120816193711.GA10277@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Aug 2012 01:03:44 +0900
Message-ID: <1345219424.1656.8.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

2012-08-16 (목), 16:37 -0300, Arnaldo Carvalho de Melo:
> Em Thu, Aug 16, 2012 at 05:14:51PM +0900, Namhyung Kim escreveu:
> > Consolidate TUI-relate header files and declarations into tui.h.
> 
> What for?
> 
> #include directives should be used where they are needed, and in this
> new tui.h only the definitions of those two structs are needed, right?

Right. But I just thought as more UI stuff is added, the more will be
needed. At least I'll add two more - hist, progress - in the near
future.


> I applied the first patch, looking at the others now.

Thanks! :)
Namhyung


>  
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/Makefile          |  1 +
> >  tools/perf/ui/helpline.h     |  2 --
> >  tools/perf/ui/tui/helpline.c |  5 +----
> >  tools/perf/ui/tui/setup.c    | 12 +-----------
> >  tools/perf/ui/tui/tui.h      | 21 +++++++++++++++++++++
> >  tools/perf/ui/tui/util.c     | 10 +---------
> >  6 files changed, 25 insertions(+), 26 deletions(-)
> >  create mode 100644 tools/perf/ui/tui/tui.h
> > 
> > diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> > index 483fb69fa4ae..14c0b744d98e 100644
> > --- a/tools/perf/Makefile
> > +++ b/tools/perf/Makefile
> > @@ -581,6 +581,7 @@ else
> >  		LIB_H += ui/progress.h
> >  		LIB_H += ui/util.h
> >  		LIB_H += ui/ui.h
> > +		LIB_H += ui/tui/tui.h
> >  	endif
> >  endif
> >  
> > diff --git a/tools/perf/ui/helpline.h b/tools/perf/ui/helpline.h
> > index 61118b2bc242..d9e97f771245 100644
> > --- a/tools/perf/ui/helpline.h
> > +++ b/tools/perf/ui/helpline.h
> > @@ -11,8 +11,6 @@ struct ui_helpline {
> >  
> >  extern struct ui_helpline *helpline_fns;
> >  
> > -void ui_helpline__init(void);
> > -
> >  void ui_helpline__pop(void);
> >  void ui_helpline__push(const char *msg);
> >  void ui_helpline__vpush(const char *fmt, va_list ap);
> > diff --git a/tools/perf/ui/tui/helpline.c b/tools/perf/ui/tui/helpline.c
> > index b4e521ef2170..62bd9432f12a 100644
> > --- a/tools/perf/ui/tui/helpline.c
> > +++ b/tools/perf/ui/tui/helpline.c
> > @@ -3,10 +3,7 @@
> >  #include <string.h>
> >  #include <pthread.h>
> >  
> > -#include "../../util/debug.h"
> > -#include "../helpline.h"
> > -#include "../ui.h"
> > -#include "../libslang.h"
> > +#include "tui.h"
> >  
> >  
> >  static void tui_helpline__pop(void)
> > diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
> > index e813c1d17346..e247bf51d247 100644
> > --- a/tools/perf/ui/tui/setup.c
> > +++ b/tools/perf/ui/tui/setup.c
> > @@ -1,22 +1,12 @@
> > -#include <newt.h>
> >  #include <signal.h>
> >  #include <stdbool.h>
> >  
> > -#include "../../util/cache.h"
> > -#include "../../util/debug.h"
> > -#include "../browser.h"
> > -#include "../helpline.h"
> > -#include "../ui.h"
> > -#include "../util.h"
> > -#include "../libslang.h"
> > -#include "../keysyms.h"
> > +#include "tui.h"
> >  
> >  pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
> >  
> >  static volatile int ui__need_resize;
> >  
> > -extern struct perf_error_ops perf_tui_eops;
> > -
> >  void ui__refresh_dimensions(bool force)
> >  {
> >  	if (force || ui__need_resize) {
> > diff --git a/tools/perf/ui/tui/tui.h b/tools/perf/ui/tui/tui.h
> > new file mode 100644
> > index 000000000000..51e8cb527fcc
> > --- /dev/null
> > +++ b/tools/perf/ui/tui/tui.h
> > @@ -0,0 +1,21 @@
> > +#ifndef _PERF_TUI_H_
> > +#define _PERF_TUI_H_
> > +
> > +#include <newt.h>
> > +
> > +#include "../../util/debug.h"
> > +#include "../../util/cache.h"
> > +#include "../ui.h"
> > +#include "../util.h"
> > +#include "../browser.h"
> > +#include "../helpline.h"
> > +#include "../libslang.h"
> > +#include "../keysyms.h"
> > +
> > +extern struct perf_error_ops perf_tui_eops;
> > +
> > +extern struct ui_helpline tui_helpline_fns;
> > +
> > +void ui_helpline__init(void);
> > +
> > +#endif /* _PERF_TUI_H */
> > diff --git a/tools/perf/ui/tui/util.c b/tools/perf/ui/tui/util.c
> > index 092902e30cee..b555ae839b2a 100644
> > --- a/tools/perf/ui/tui/util.c
> > +++ b/tools/perf/ui/tui/util.c
> > @@ -1,17 +1,9 @@
> > -#include "../../util/util.h"
> >  #include <signal.h>
> >  #include <stdbool.h>
> >  #include <string.h>
> >  #include <sys/ttydefaults.h>
> >  
> > -#include "../../util/cache.h"
> > -#include "../../util/debug.h"
> > -#include "../browser.h"
> > -#include "../keysyms.h"
> > -#include "../helpline.h"
> > -#include "../ui.h"
> > -#include "../util.h"
> > -#include "../libslang.h"
> > +#include "tui.h"
> >  
> >  static void ui_browser__argv_write(struct ui_browser *browser,
> >  				   void *entry, int row)
> > -- 
> > 1.7.11.2


-- 
Regards,
Namhyung Kim


