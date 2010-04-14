Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab0DNC2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 22:28:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab0DNC2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 22:28:09 -0400
Date: Tue, 13 Apr 2010 23:28:00 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf: Fix accidentally preprocessed snprintf callback
Message-ID: <20100414022800.GE25649@ghostprotocols.net>
References: <1271205468-8202-1-git-send-regression-fweisbec@gmail.com> <20100414004115.GI5602@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100414004115.GI5602@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 14, 2010 at 02:41:16AM +0200, Frederic Weisbecker escreveu:
> On Wed, Apr 14, 2010 at 02:37:48AM +0200, Frederic Weisbecker wrote:
> > struct sort_entry has a callback named snprintf that turns an
> > entry into a string result.
> > 
> > But there are glibc versions that implement snprintf through a
> > macro. The following expression is then going to get the snprintf
> > call preprocessed:
> > 
> > 	ent->snprintf(...)
> > 
> > to finally end up in a build error:
> > 
> > 	util/hist.c: Dans la fonction «hist_entry__snprintf» :
> > 	util/hist.c:539: erreur: «struct sort_entry» has no member named «__builtin___snprintf_chk»
> > 
> > To fix this, rename struct sort_entry::snprintf() callback to
> > to_string(), assuming at least Java methods naming won't ever
> > conflict with perf.
> 
> 
> Note I'm not entirely happy with this to_string() renaming.
> May be append_string() would have been better. I don't know.
> snprintf() was just too good.
> If you think about something else, don't hesistate to change,
> or I can change it myself if you want.

psnprintf() I guess, the intent was exactly to mean that it is indeed
similar to snprintf... dammit, there is already a psnprintf out there
:-\

Perhaps just do it as ->he_snprintf and have the other methods as well
prefixed with he as a shorthand for hist_entry, that is what the methods
operate, besides the string, ok?

- Arnaldo
