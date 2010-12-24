Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0LXEf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 23:35:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab0LXEf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 23:35:28 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=pPXw3_qIy5IA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=49WD_Y0i5dF8x-k797kA:9 a=ebJNC-J2ff51WBzfJkWLAYAPiuwA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: ftrace: trace_pipe_raw interface broken
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>
In-Reply-To: <AANLkTi=_VJcDmpdfy=nfo_771iHjdVHTHnciUe8DrZme@mail.gmail.com>
References: <AANLkTik6RfWWqjtuBUWRGZ0e+DHHm02opR9FAQJPdTR1@mail.gmail.com>
	 <1292903569.22905.123.camel@gandalf.stny.rr.com>
	 <AANLkTin7nLrRPc9qGjdjHbeVDDWiJjAiYyb-L=gH85bx@mail.gmail.com>
	 <AANLkTikkwQC8pHPw=dvf5h++MnSOo9YY0dagNhv6s11B@mail.gmail.com>
	 <AANLkTinFjuFFAp3ayeF8L5x813248zeVJbPbgKK02Rjv@mail.gmail.com>
	 <AANLkTinEFVeVfMj9HgfO90wHVgCrzK+RSaDyXqeJuHUh@mail.gmail.com>
	 <1293119853.22802.33.camel@gandalf.stny.rr.com>
	 <AANLkTi=_VJcDmpdfy=nfo_771iHjdVHTHnciUe8DrZme@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Dec 2010 23:35:26 -0500
Message-ID: <1293165326.22802.411.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 15:06 -0800, David Sharp wrote:
> On Thu, Dec 23, 2010 at 7:57 AM, Steven Rostedt <rostedt@goodmis.org> wrote:

> > Not quite intended, but not something to worry about either. We mask off
> > the 30 bits to determine the size.
> 
> in trace-cmd you mean?

Yeah, but if you find that strange, I guess we could mask it off too.

> 
> >> By my count that leaves only one mystery: why are we seeing this extra
> >> page at the beginning with pre-overflow data?
> >
> > If you did not reset the buffer, there's a chance that the writer is on
> > the reader page. The reader page is always outside the ring buffer, but
> > it points into the ring buffer. If this occurs, then you will get the
> > reader page data, plus the rest of the ring buffer (which is the full
> > size you asked for).
> 
> Okay, that's a surprising behavior to me, but resetting the buffer
> seems like a fine workaround.

Getting a little more trace than you asked for seems like a good thing
to me ;-)

> 
> btw, corroborating this is that reading the formatted output of
> "trace" also shows the page of pre-overflow data.

Yep, that's already known.

-- Steve


