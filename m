Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab1CPAd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 20:33:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16700 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab1CPAd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 20:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=apcLwmGDUzEhwvW8Mwm6hKq6ZVYBAuyqZp3o35BZHbRanlENV56LNA0qTUaTUIkuP6
         1aAwIQOmePtbMZ/YlboA==
MIME-Version: 1.0
In-Reply-To: <1300156268.9910.242.camel@gandalf.stny.rr.com>
References: <1300142528-4918-1-git-send-email-slavapestov@google.com> <1300156268.9910.242.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Tue, 15 Mar 2011 17:33:34 -0700
Message-ID: <AANLkTi=ssMY8615j1dXJPfK-awZnFSVn4tjLHh4Mnv4C@mail.gmail.com>
Subject: Re: [PATCH] ftrace: add 'version' special file for ring buffer format
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Slava Pestov <slavapestov@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 7:31 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-03-14 at 15:42 -0700, Slava Pestov wrote:
>> The intention here is that if the ftrace ring buffer format changes
>> in the future like it did in the past with ktrace, we can increment
>> the version number and update clients appropriately.
>
> I purposely avoided "versions", and instead use the
> tracing/events/header_page and .../header_event to describe how the ring
> buffer format is laid out. If the format changes, then so should those
> files.
>
> -- Steve

Those are useful files, but do not encompass the entirety of the API.
Specifically, they do not encode the semantics of those values, nor
the control interface.

For example, when the ring buffer header changed from type:2;len:3 to
type_len:5, while this would have been reflected in header_event, how
to interpret the different versions is not something that could be
automatically understood by a parser.

These files also do not cover the semantics of the control files. For
example, it is imaginable that buffer_size_kb could be changed from
per-core size to a total size, or that it would reflect the actual
total amount of memory used, instead of the "non-header" space. The
grammar of filter expressions is another example of something that
could change without notice.

d#

>
>>
>> Tested: Verified that special file contains correct content
>>
>> This patch is against 2.6.38-rc8 but should apply to any version
>> from at least 2.6.34 onwards.
>>
>> Signed-Off-By: Slava Pestov <slavapestov@google.com>
>
>
>
