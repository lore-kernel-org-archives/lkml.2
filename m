Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab0LMGuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:50:39 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:45262 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab0LMGuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:50:35 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Miguel Ojeda'" <miguel.ojeda.sandonis@gmail.com>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <01da01cb9784$d44c0460$7ce40d20$@mprc.pku.edu.cn> <AANLkTimDWHGsL+1H_VSevSjpFW0-h53NzRynANnayTRm@mail.gmail.com> <028901cb9933$4a2bfe10$de83fa30$@mprc.pku.edu.cn> <201012111456.07925.arnd@arndb.de>
In-Reply-To: <201012111456.07925.arnd@arndb.de>
Subject: RE: [PATCHv1 008/211] unicore32: new file arch/unicore32/boot/compressed/misc.c
Date: Mon, 13 Dec 2010 14:50:13 +0800
Message-ID: <004a01cb9a92$02629930$0727cb90$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGrmnwbWKliDFzh4nZd2nlW0eIAGgE8uuEQAX56uJoBZxO7GJO822Pw
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > +/* Diagnostic functions */
> > > > +#ifdef DEBUG
> > > > +#  define Assert(cond, msg)    { if (!(cond)) error(msg); }
> > > > +#  define Trace(x)             fprintf x
> > > > +#  define Tracev(x)            { if (verbose)                  fprintf x; }
> > > > +#  define Tracevv(x)           { if (verbose > 1)              fprintf x; }
> > > > +#  define Tracec(c, x)         { if (verbose && (c))           fprintf x; }
> > > > +#  define Tracecv(c, x)                { if ((verbose > 1) && (c))
> > > > fprintf x; }
> > >
> > > Maybe uppercase? Maybe do { ... } while(0)?
> >
> > Uppercase  for what? Tracexx to tracexx?
> 
> We normally don't have mixed-case identifiers, normally it would be
> trace() for functions vs. TRACE() for macros, though we also have a
> lot of lower-case macros as well.
> 
> For the debugging macros, I would generally recommend not having
> any, but simply using the standard pr_debug and dev_dbg macros
> that everyone knows and understands.
> 
> If you really need to do macros, make them so that they work like
> functions, e.g.
> 
> #define foo_tracev(...) do { if (verbose) fprintf(__va_args__); } while (0)

When reviewing misc.c, I find that Tracevv and Tracecv are not used in lib/decompress_inflate.c
So these macros could be removed directly.
The same for other architectures, I think.

Guan Xuetao



