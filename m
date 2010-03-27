Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0C0XMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 19:12:09 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53293 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab0C0XMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 19:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gfKkoY/rQezqkAQdNDclEq20EQ0p+3M4y4HIJWF7QUAzDVFym1Tohm62dhSW+rjnYV
         2kzItDpO5LD7oSwmpTKO3f0D4jCOWAqjYRAInj27CsyegCVPaORrRkjS07JqoHqFX0jg
         w03jjbTJKluOhs/8mgWPBFoWFXeLdCINTpx+w=
Date: Sun, 28 Mar 2010 00:12:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org, k-keiichi@bx.jp.nec.com
Subject: Re: [RFC PATCH 2/7] perf: add pipe-specific header read/write and
	event processing code
Message-ID: <20100327231202.GC5096@nowhere>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com> <1267599929-8310-3-git-send-email-tzanussi@gmail.com> <20100327031455.GN7166@nowhere> <20100327225747.GI23594@ghostprotocols.net> <20100327230505.GK23594@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100327230505.GK23594@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 27, 2010 at 08:05:05PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Sat, Mar 27, 2010 at 07:57:47PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Sat, Mar 27, 2010 at 04:14:57AM +0100, Frederic Weisbecker escreveu:
> > > On Wed, Mar 03, 2010 at 01:05:24AM -0600, Tom Zanussi wrote:
> > > >  
> > > > +int perf_header__write_pipe(struct perf_header *self, int fd)
> > > > +{
> > > > +	struct perf_file_header_pipe f_header;
> > > > +	int err;
> > > > +
> > > > +	f_header = (struct perf_file_header_pipe){
> > > > +		.magic	   = PERF_MAGIC,
> > > > +		.size	   = sizeof(f_header),
> > > > +	};
> > 
> > > I actually wonder why you bother with a header in the pipe mode,
> > > since it only contains MAGIC and its size.
> > 
> > Because he wants to detect endianness  :-)
> 
> Elaborating: piping over netcat from a big endian to a little endian
> machine works because he used the ->needs_swap logic I implemented to
> allow cross platform analysis.
> 
> Its just a matter of having the DSOS with matching build-ids in the
> cache of the machine running 'perf report'.
> 
> - Arnaldo


Ok, thanks for the explanations :-)

