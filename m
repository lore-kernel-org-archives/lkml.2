Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271Ab1JFR5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:57:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48330 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965244Ab1JFR5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:57:50 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=q6D_i0jzt40A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=VwQbUJbxAAAA:8 a=HDVsoBHzlVNRPcT3oZUA:9 a=PUjeQqilurYA:10 a=U62fhAwekXMA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH v2][QUILT] Add
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, quilt-dev <quilt-dev@nongnu.org>,
        LKML <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andreas Gruenbacher <agruen@suse.de>
Date: Thu, 06 Oct 2011 13:57:47 -0400
In-Reply-To: <20111006102626.22002ed9.akpm@linux-foundation.org>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	 <1317896857.29658.10.camel@twins>
	 <20111006102626.22002ed9.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317923868.4729.11.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 10:26 -0700, Andrew Morton wrote:
> On Thu, 06 Oct 2011 12:27:37 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > since we're all happily sharing quilt hackery, let me hijack this thread
> > and share one I've been carrying around for a while.
> > 
> > I use the below patch to run a script like:
> > 
> > #!/bin/bash
> > 
> > if [ -x ./scripts/chechpatch.pl ]; then
> >         ./scripts/checkpatch.pl $1
> > fi
> > 
> > 
> > ---
> > --- /usr/share/quilt/refresh.orig	2010-02-27 20:42:14.888302809 +0100
> > +++ /usr/share/quilt/refresh	2010-10-31 12:36:57.355400831 +0100
> > @@ -310,6 +310,10 @@
> >  
> >  cat $tmp_patch >> $tmp_result
> >  
> > +if [ -n $QUILT_REFRESH_EXT ] ; then
> > +	$QUILT_REFRESH_EXT $tmp_result
>    else
> 	sudo rm -rf /


I think I now know who cracked kernel.org.

-- Steve

> > +fi
> > +
> >  mkdir -p $(dirname $patch_file)
> >  
> >  if [ -e $patch_file ] && \


