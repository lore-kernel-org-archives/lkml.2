Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab2A0BPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 20:15:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2A0BPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 20:15:54 -0500
Date: Thu, 26 Jan 2012 17:15:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Nebojsa Trpkovic <trx.lists@gmail.com>, minchan@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, riel@redhat.com,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] mm: implement WasActive page flag (for improving
 cleancache)
Message-Id: <20120126171548.2c85dd44.akpm@linux-foundation.org>
In-Reply-To: <ccb76a4d-d453-4faa-93a9-d1ce015255c0@default>
References: <ea3b0850-dfe0-46db-9201-2bfef110848d@default>
	<4F218D36.2060308@linux.vnet.ibm.com>
	<9fcd06f5-360e-4542-9fbb-f8c7efb28cb6@default>
	<20120126163150.31a8688f.akpm@linux-foundation.org>
	<ccb76a4d-d453-4faa-93a9-d1ce015255c0@default>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 16:56:34 -0800 (PST)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> > > I'll find the place to add the call to ClearPageWasActive() for v2.
> > 
> > AFAICT this patch consumes our second-last page flag, or close to it.
> > We'll all be breaking out in hysterics when the final one is gone.
> 
> I'd be OK with only using this on 64-bit systems, though there
> are ARM folks playing with zcache that might disagree.

64-bit only is pretty lame and will reduce the appeal of cleancache and
will increase the maintenance burden by causing different behavior on
different CPU types.  Most Linux machines are 32-bit!  (My cheerily
unsubstantiated assertion of the day).

>  Am I
> correct in assuming that your "second-last page flag" concern
> applies only to 32-bit systems?

Sort-of.  Usually a flag which is 64-bit-only causes the above issues.

> > This does appear to be a make or break thing for cleancache - if we
> > can't fix https://lkml.org/lkml/2012/1/22/61 then cleancache is pretty
> > much a dead duck.
> 
> Hmmm... is that URL correct?  If so, there is some subtlety in
> that thread that I am missing as I don't understand the relationship
> to cleancache at all?

err, sorry, I meant your https://lkml.org/lkml/2011/8/17/351.

> > And I'm afraid that neither I nor other MM developers are likely to
> > help you with "fix cleancache via other means" because we weren't
> > provided with any description of what the problem is within cleancache,
> > nor how it will be fixed.  All we are given is the assertion "cleancache
> > needs this".
> 
> The patch comment says:
> 
> The patch resolves issues reported with cleancache which occur
> especially during streaming workloads on older processors,
> see https://lkml.org/lkml/2011/8/17/351
> 
> I can see that may not be sufficient, so let me expand on it.
> 
> First, just as page replacement worked prior to the active/inactive
> redesign at 2.6.27, cleancache works without the WasActive page flag.
> However, just as pre-2.6.27 page replacement had problems on
> streaming workloads, so does cleancache.  The WasActive page flag
> is an attempt to pass the same active/inactive info gathered by
> the post-2.6.27 kernel into cleancache, with the same objectives and
> presumably the same result: improving the "quality" of pages preserved
> in memory thus reducing refaults.
> 
> Is that clearer?  If so, I'll do better on the description at v2.

It really didn't tell us anything, apart from referring to vague
"problems on streaming workloads", which forces everyone to go off and
do an hour or two's kernel archeology, probably in the area of
readahead.

Just describe the problem!  Why is it slow?  Where's the time being
spent?  How does the proposed fix (which we haven't actually seen)
address the problem?  If you inform us of these things then perhaps
someone will have a useful suggestion.  And as a side-effect, we'll
understand cleancache better.
