Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab0LMNQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:16:06 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:60277 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab0LMNQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:16:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=RLVSZARmuH4Bfx7doY4qrM983KPNsWCiAzWrLcX+jZ21m03kau/6LsJJgGj9SNAzM5
         1fuDI0bvcXdmiAwXYop0iU44zURyPeadHD83rV5q4KyGJl6HmpoNiUF2scJ18V2PuzyP
         JGpd2VHDpaE2BYYfyN5yHbpiFU9UDbcVsJ2t0=
Date: Mon, 13 Dec 2010 11:15:57 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
Message-ID: <20101213131557.GD5407@ghostprotocols.net>
References: <1291773285-16254-1-git-send-email-daahern@cisco.com>
 <1291773285-16254-2-git-send-email-daahern@cisco.com>
 <20101212201613.GA1784@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101212201613.GA1784@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Dec 12, 2010 at 09:16:16PM +0100, Frederic Weisbecker escreveu:
> On Tue, Dec 07, 2010 at 06:54:44PM -0700, David Ahern wrote:
> > +++ b/tools/perf/util/header.c
> > @@ -191,6 +191,40 @@ static int write_padded(int fd, const void *bf, size_t count,
> > +static int perf_header__read_ref_time(struct perf_header *header,
> > +			int fd, u64 offset, u64 size)
> > +{
> > +	size_t sz_nsec = sizeof(header->nsec_ref);
> > +	size_t sz_tv   = sizeof(header->tv_ref);
> > +	int err = -1;
> > +
> > +	if (((size - offset) < (sz_nsec + sz_tv)) ||
> > +	    (read(fd, &header->nsec_ref, sz_nsec) != (ssize_t) sz_nsec) ||
> > +	    (read(fd, &header->tv_ref, sz_tv) != (ssize_t) sz_tv))
> > +		goto out;
> 
> Hmm, could we have endianness related troubles if we write the timespec on
> an arch and cross read from another, or other cross read issues?

Well spotted, it needs to use perf_header__getbuffer64 and make sure
that nsec_ref, etc are u64 fields.
 
- Arnaldo
