Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0C0W5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 18:57:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41954 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab0C0W5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 18:57:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=gV6r38gpW185r+BopOP6ZHCKSAr7A+k887j4I+Paj1EKE1ULXRsQdIA4c9TVtKOCqN
         KiCoZqHA8K9IJ58EW2bRhmEXJ5NiPmuNDV+OxInXMnfdvvHtp1sn/UDCzqk4M5zIR2Jb
         0OHvIz/I881ZZjwMMu6Kv27slFN0ShMTaCgyM=
Date: Sat, 27 Mar 2010 19:57:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org, k-keiichi@bx.jp.nec.com
Subject: Re: [RFC PATCH 2/7] perf: add pipe-specific header read/write and
 event processing code
Message-ID: <20100327225747.GI23594@ghostprotocols.net>
References: <1267599929-8310-1-git-send-email-tzanussi@gmail.com>
 <1267599929-8310-3-git-send-email-tzanussi@gmail.com>
 <20100327031455.GN7166@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100327031455.GN7166@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Mar 27, 2010 at 04:14:57AM +0100, Frederic Weisbecker escreveu:
> On Wed, Mar 03, 2010 at 01:05:24AM -0600, Tom Zanussi wrote:
> >  
> > +int perf_header__write_pipe(struct perf_header *self, int fd)
> > +{
> > +	struct perf_file_header_pipe f_header;
> > +	int err;
> > +
> > +	f_header = (struct perf_file_header_pipe){
> > +		.magic	   = PERF_MAGIC,
> > +		.size	   = sizeof(f_header),
> > +	};

> I actually wonder why you bother with a header in the pipe mode,
> since it only contains MAGIC and its size.

Because he wants to detect endianness  :-)

- ARnaldo
