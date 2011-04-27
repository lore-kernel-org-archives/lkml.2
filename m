Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab1D0QE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:04:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43651 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504Ab1D0QEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=prwB0OYWzMn75IqrRUATxE8w+gohwLctpyKHivTFZmea4CL4D9tDnAj11gsME10aw7
         BXmGHFIrS3ggX3YGqWMI0jeLGR+OIL31YXxkahJ+dcLBGxxM4VJi5/ADl1tem7awrLu3
         pLcmPRQu6xtf2cEKPote16ygxgXPZstQsmcy8=
MIME-Version: 1.0
In-Reply-To: <20110427145209.GJ9486@thunk.org>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	<20110427005243.GI9486@thunk.org>
	<20110427064719.GB597@infradead.org>
	<alpine.DEB.2.00.1104270445210.7570@mtl.rackplans.net>
	<20110427145209.GJ9486@thunk.org>
Date: Wed, 27 Apr 2011 19:04:23 +0300
Message-ID: <BANLkTikGYLEWx8xrYs3Nv=-oPS3n95rXZA@mail.gmail.com>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, gmack@innerfire.net,
        Christoph Hellwig <hch@infradead.org>,
        Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 5:52 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Apr 27, 2011 at 04:47:40AM -0400, gmack@innerfire.net wrote:
>> Knowing about it and not screwing it up are two different things. I was
>> working on a project a few years ago and we made this exact change thanks
>> to the backwards logic of strcmp constantly screwing people up and the bug
>> count went down considerably.
>
> If someone could even vaguely possibly screw up strcmp(), I don't want
> them submitting patches to my subsystem.  I'm generally worried about
> far more subtle bugs (deadlocks, locking screwups), and as Christoph
> said, if you can't notice a strcmp bug, there's something
> ***seriousl**** wrong with your code review process, test suite,
> testing discpline, or all of the above.

This can be good excuse in math where proof of existence is enough.
For some reason, the one making excuses always fails to say
what exactly is wrong with all of the above.

> I would consider patches to change !strcmp() to streq() in any code I
> maintain to be worse noise than spelling patches, or whitespace
> patches.

If someone finds strcmp bug in e2fsprogs or ext[234] code,
will you change your opinion?


People are trying to add "string comparison by value" idiom
the way it's supposed to be.
Adding it into C2042 is very hard, so they add it into kernel.

But instead of agreeing
that, yes, streq() as "compare strings by value, relative order is not
important,
interesting or relevant" should have existed from the very beginning,
let's add it into kernel at least,

that, yes, strcmp() usage bugs happened
(side note: kernel doesn't have in-tree testsuite, only chaotic tests,
so what do these kernel guys know about testing their own code?)

that, yes, 3 ways to write "S1 equals S2" sucks.

that, yes, penny-wise Unix is in the past,

instead, there is usual ignorant hand-waving.

P. S.: I for one glad kmemdup() is in tree.
