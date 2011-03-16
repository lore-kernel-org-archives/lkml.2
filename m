Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab1CPA45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 20:56:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50878 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1CPA4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 20:56:53 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=LVe1Hbu2v80A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=zfP9BmUKhbsUcD1eafcA:9 a=LMzRc6ojI_Mz00S6jeIA:7 a=RXwIsiuebmDz7oM6cpAidHD4J1UA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace: add 'version' special file for ring buffer
 format
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: Slava Pestov <slavapestov@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
In-Reply-To: <AANLkTi=ssMY8615j1dXJPfK-awZnFSVn4tjLHh4Mnv4C@mail.gmail.com>
References: <1300142528-4918-1-git-send-email-slavapestov@google.com>
	 <1300156268.9910.242.camel@gandalf.stny.rr.com>
	 <AANLkTi=ssMY8615j1dXJPfK-awZnFSVn4tjLHh4Mnv4C@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 15 Mar 2011 20:56:50 -0400
Message-ID: <1300237010.16880.27.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 17:33 -0700, David Sharp wrote:
> On Mon, Mar 14, 2011 at 7:31 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Mon, 2011-03-14 at 15:42 -0700, Slava Pestov wrote:
> >> The intention here is that if the ftrace ring buffer format changes
> >> in the future like it did in the past with ktrace, we can increment
> >> the version number and update clients appropriately.
> >
> > I purposely avoided "versions", and instead use the
> > tracing/events/header_page and .../header_event to describe how the ring
> > buffer format is laid out. If the format changes, then so should those
> > files.
> >
> > -- Steve
> 
> Those are useful files, but do not encompass the entirety of the API.
> Specifically, they do not encode the semantics of those values, nor
> the control interface.
> 
> For example, when the ring buffer header changed from type:2;len:3 to
> type_len:5, while this would have been reflected in header_event, how
> to interpret the different versions is not something that could be
> automatically understood by a parser.

We do want to make the parser aware of these changes. As that change
happened, I have parse_events understand it.

> 
> These files also do not cover the semantics of the control files. For
> example, it is imaginable that buffer_size_kb could be changed from
> per-core size to a total size, or that it would reflect the actual
> total amount of memory used, instead of the "non-header" space. The
> grammar of filter expressions is another example of something that
> could change without notice.

Then we need to make sure that a change can be detected. Version numbers
for ABI in the kernel has been looked down upon. Again, if a change is
needed, I find a way to make it detected. I thought about adding to
buffer_size_kb:

1408 (total 5632)

or something of that matter.

Again, if we can not determine the features by reading a file or finding
if a syscall exists or not, then we are doing something wrong and need
to fix that.

Lets put it another way. Instead of making it easy for a parser, lets
make it easy for humans to know. If I look at the files I can quickly
figure out what type of features are available. I would be clueless to
know if all I had was "v1.0.2". One more thing: Version numbers are like
documentation. They are great when you start out, but soon become out of
sync with reality.

-- Steve


