Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1ECWBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:01:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56137 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1ECWBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qkKIu/kAj6csBtDuQl10+/gxHPh092kh1M3a4nBh6JXUFutpn3QYGV7Ug7yTU/cEBi
         gR/eMbPdLgqPkGrVkPWO3BrgV6nhevIJBb5JsWNYNLBKkQwwr5I3fZuGs7YsqOpEuNuZ
         A4cnNie2wlnvI+usOHIO3pbEy9JPeVuOb3ibo=
Date: Wed, 4 May 2011 00:01:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 01/32] TRACE_EVENT: gradual semicolon removal
Message-ID: <20110503220059.GD2678@nowhere>
References: <20110502211123.163877033@efficios.com>
 <20110502213211.250108074@efficios.com>
 <1304422337.25414.2382.camel@gandalf.stny.rr.com>
 <20110503212656.GG32331@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503212656.GG32331@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 05:26:57PM -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > * Why do this incrementally ?
> > 
> > Preaching to the choir?
> 
> I've been asked to explain myself on this topic by Frederic last time I
> posted this patchset, so I added the explanation to the changelog.

Explaining it in the cover letter is enough :)

> > 
> > > 
> > > After this preliminary patch, the semicolon removal can be done gradually
> > > without breaking the build: we can be in an intermediate state with some files
> > > having semicolons and others without. This is therefore good for
> > > bissectability, and seems like a nice way to bring in an internal API change
> > > without making developers suffer too much. Then, once things are stabilized, we
> > > can start modifying the Ftrace code to generate the more space-efficient arrays
> > > (possibly in a release-cycle or so), knowing that this enforces a strict
> > > requirement on semicolon removal.
> > 
> > Mathieu, I like the patch, but I think you explain too much ;)
> 
> Or too little, depending on the maintainer. ;-)

Well, I did never asked for 1000 lines of changelog ;)
The real problem with your previous set is that your arguments were
either too weak (double ";" in generated code doesn't alone justify
a massive change like this) or too foggy (the array of field
idea was not developed enough to be understanble whereas it was the
only sane reason for this massive change).

Just explain briefly that the end goal is for storing fields in an array
with a quick example and you are done with few dozen lines for
your changelog.

People simply don't review fat changelogs.
