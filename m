Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0C0XFL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 19:05:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55779 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab0C0XFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 19:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=QRklJ1gQWkbbfFm1JKiN/9pic52EPtzQSyari1UReWz0Lq0wliW3mBvM0sQ/UvwPRF
         LjhPZJW0nG3vl8rRCuD4jm75Ff5NJQFo13DVkkxDrCX6mX1RTi10mcs7xWrTIo+QuuMU
         EyIQ3do874k/Ap3CirjWmxh9fUKf2qJfkU5vs=
Date: Sat, 27 Mar 2010 20:05:05 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org, k-keiichi@bx.jp.nec.com
Subject: Re: [RFC PATCH 2/7] perf: add pipe-specific header read/write and
 event processing code
Message-ID: <20100327230505.GK23594@ghostprotocols.net>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
 <1267599929-8310-3-git-send-email-tzanussi@gmail.com>
 <20100327031455.GN7166@nowhere>
 <20100327225747.GI23594@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100327225747.GI23594@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Mar 27, 2010 at 07:57:47PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Sat, Mar 27, 2010 at 04:14:57AM +0100, Frederic Weisbecker escreveu:
> > On Wed, Mar 03, 2010 at 01:05:24AM -0600, Tom Zanussi wrote:
> > >  
> > > +int perf_header__write_pipe(struct perf_header *self, int fd)
> > > +{
> > > +	struct perf_file_header_pipe f_header;
> > > +	int err;
> > > +
> > > +	f_header = (struct perf_file_header_pipe){
> > > +		.magic	   = PERF_MAGIC,
> > > +		.size	   = sizeof(f_header),
> > > +	};
> 
> > I actually wonder why you bother with a header in the pipe mode,
> > since it only contains MAGIC and its size.
> 
> Because he wants to detect endianness  :-)

Elaborating: piping over netcat from a big endian to a little endian
machine works because he used the ->needs_swap logic I implemented to
allow cross platform analysis.

Its just a matter of having the DSOS with matching build-ids in the
cache of the machine running 'perf report'.

- Arnaldo
