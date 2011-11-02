Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1KBVEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab1KBVEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:04:10 -0400
Message-ID: <4EB1B01E.7030005@redhat.com>
Date: Wed, 02 Nov 2011 17:03:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default> <20111031171321.097a166c.kamezawa.hiroyu@jp.fujitsu.com> <ef778e79-72d0-4c58-99e8-3b36d85fa30d@default 20111101095038.30289914.kamezawa.hiroyu@jp.fujitsu.com> <f62e02cd-fa41-44e8-8090-efe2ef052f64@default> <20111101144309.a51c99b5.akpm@linux-foundation.org>
In-Reply-To: <20111101144309.a51c99b5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2011 05:43 PM, Andrew Morton wrote:

> I will confess to and apologise for dropping the ball on cleancache and
> frontswap.  I was never really able to convince myself that it met the
> (very vague) cost/benefit test,

I believe that it can, but if it does, we also have to
operate under the assumption that the major distros will
enable it.

This means that "no overhead when not compiled in" is
not going to apply to the majority of the users out there,
and we need clear numbers on what the overhead is when it
is enabled, but not used.

We also need an API that can handle arbitrarily heavy
workloads, since that is what people will throw at it
if it is enabled everywhere.

I believe that means addressing some of Andrea's concerns,
specifically that the API should be able to handle vectors
of pages and handle them asynchronously.

Even if the current back-ends do not handle that today,
chances are that (if tmem were to be enabled everywhere)
people will end up throwing workloads at tmem that pretty
much require such a thing.

An asynchronous interface would probably be a requirement
for something as high latency as encrypted ramster :)

API concerns like this are things that should be solved
before a merge IMHO, since afterwards we would end up with
the "we cannot change the API, because that breaks users"
scenario that we always end up finding ourselves in.
