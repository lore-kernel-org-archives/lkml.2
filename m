Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0C1APu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 20:15:50 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:54086 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab0C1APt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 20:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=unhBER/qlXwX801HUGdHKd3QESBI26wlWka/PJApgFP3sBos3B/v+VN+RpuKE2Ux7Z
         QM+1iWm8wOZh04Bl+358g9Y/FtfQ0bM3DslihxFr27eUSkuMgSrLW03k+BH6y5PjJDTP
         olkBL2HhJ9A/WDGFI89yIMYAALUXtFN+Dvfz4=
Date: Sat, 27 Mar 2010 21:15:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org, k-keiichi@bx.jp.nec.com
Subject: Re: [RFC PATCH 2/7] perf: add pipe-specific header read/write and
 event processing code
Message-ID: <20100328001544.GL23594@ghostprotocols.net>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
 <1267599929-8310-3-git-send-email-tzanussi@gmail.com>
 <20100327031455.GN7166@nowhere>
 <20100327225747.GI23594@ghostprotocols.net>
 <20100327230505.GK23594@ghostprotocols.net>
 <20100327231202.GC5096@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100327231202.GC5096@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Mar 28, 2010 at 12:12:05AM +0100, Frederic Weisbecker escreveu:
> On Sat, Mar 27, 2010 at 08:05:05PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Sat, Mar 27, 2010 at 07:57:47PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > Em Sat, Mar 27, 2010 at 04:14:57AM +0100, Frederic Weisbecker escreveu:
> > > > I actually wonder why you bother with a header in the pipe mode,
> > > > since it only contains MAGIC and its size.
> > > 
> > > Because he wants to detect endianness  :-)
> > 
> > Elaborating: piping over netcat from a big endian to a little endian
> > machine works because he used the ->needs_swap logic I implemented to
> > allow cross platform analysis.
> > 
> > Its just a matter of having the DSOS with matching build-ids in the
> > cache of the machine running 'perf report'.

> Ok, thanks for the explanations :-)

Humm, now that I read this again, the build-ids now are in the headers,
which will not be pushed as it is the last step in 'perf record', after
we stop recording events, so only if we make sure that the binaries are
the same is that we will be able to make sense of it over the network.

One more reason for the loader of DSOs to read the pre calculated
build-id ELF session to tell the kernel the 20 bytes build id that in
turn will inject it in the PERF_RECORD_MMAP event.

- Arnaldo
