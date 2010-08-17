Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0HQOKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:10:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52323 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0HQOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 10:10:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sP+iVot+v+hLwHyvfUhWOo7kU3b8/CSRpSnP/0bWJQVXMxvpOnzVlImwKMRL6orxbq
         hP4LEOvoBIz3EdW3oycvq4hyYEENeXJTmBtB2yXezP/fAE5Ayr2Th8BNa+JGW6KQ/doc
         6/MTZ7Ya7VFMvyJqJlg4WjBCNVaxxmV4/2yi4=
Date: Tue, 17 Aug 2010 18:10:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC -tip]
Message-ID: <20100817141013.GA5879@lenovo>
References: <20100816110253.GD5805@lenovo> <1282036441.11858.14.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282036441.11858.14.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 05:14:01PM +0800, Lin Ming wrote:
> On Mon, 2010-08-16 at 19:02 +0800, Cyrill Gorcunov wrote:
> > Hi,
> > 
> > please review the approach, I can't test it due to lack
> > of hw (btw Ming, if you have some spare minutes -- mind to
> > pass some event as RAW and see how it goes?).
> 
> #raw event for cpu cycles
> perf top -e r3000020c0403c000
> 
> #raw event for cache-misses
> perf top -e r120e00030803e000
> 

Ming, I had something different in mind, I'll prepare the case
to be tested. Will notify you. Thanks!

> I tried some raw events and it works.
> 
> > Index: linux-2.6.git/arch/x86/include/asm/Kbuild
> > =====================================================================
> > --- linux-2.6.git.orig/arch/x86/include/asm/Kbuild
> > +++ linux-2.6.git/arch/x86/include/asm/Kbuild
> > @@ -24,3 +24,4 @@ unifdef-y += unistd_32.h
> >  unifdef-y += unistd_64.h
> >  unifdef-y += vm86.h
> >  unifdef-y += vsyscall.h
> > +unifdef-y += perf_event_p4.h
> 
> +header-y += perf_event_p4.h
> 
> Need to update this to header-y.


Yeah, thanks for catching this!

> 
> Thanks,
> Lin Ming
> 
...

	-- Cyrill
