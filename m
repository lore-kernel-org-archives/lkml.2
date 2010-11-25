Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab0KYHqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:46:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61944 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab0KYHqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:46:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=glL5F6LyiJ+rHbOQrbgBH5bcXPJPzpJYqA0e3fgGe2szsejJvyhShqEyf2Y1TKlney
         MkZDBvmehDYWKrsj2NIVv21Wom9kXi3yhcYnLZIHu1w2RXaA0HTlY7Twi24RQQ6a1sl2
         yzdmEsbZjqVHhPBs4KrzigDTh7MK/qmrPvWrk=
Date: Thu, 25 Nov 2010 08:46:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, Julia Lawall <julia@diku.dk>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: [RFC PATCHv3] perf tools: add event grouping capability to
 "perf stat"
Message-ID: <20101125074629.GC2538@nowhere>
References: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com>
 <1290666760.2072.539.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290666760.2072.539.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 07:32:40AM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-24 at 17:54 -0800, Corey Ashford wrote:
> > Add the ability to create multiple event groups, each with their own leader
> > using the existing "-e <event>[,<event> ...] [-e <event>[,<event>]]"
> > syntax.  Each additional -e switch creates a new group, and each event
> > listed within a -e switch is within that group.
> > 
> > Changes since v1:
> > - Because of a flub, v2 did not contain the changes I had intended to make,
> > and instead, v2 had the same patch contents as v1.
> > - When perf stat is not supplied any events on the command line, put
> > each default event in its own group.
> 
> I like this, but could you also extend this to perf-record? its a bit
> odd to diverge between the two.
> 
> Using Stephane's latest syntax changes you could actually do something
> like:
> 
> perf record -e task-clock:freq=1000,cycles:period=0

Wouldn't this syntax clash with the flags we have on events already?

the u,k,p flags?




> 
> Which would create a group with 1 sampling counter and a counting
> counter (at which point we should probably start flipping
> PERF_SAMPLE_READ).
> 
> Matt was working on supporting that (although not through cmdline
> syntax) and teaching perf-report to cope with such output.
> 
