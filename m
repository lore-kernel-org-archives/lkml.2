Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab1FOWYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:24:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56380 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1FOWYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kIPjN6nCQ85yiopL60lZvijKeN3iWp9PUl6dEKbKFZGcR+AH1EleMHOtR+gqowAM0r
         GOLFNG89Y7yu00J/7o1AhUiH1rmu5dcgJAEyFJcLUgDySxtYZzOCwV6S/08GJVGMdoNa
         7usA/ej4JPEO0sB5/6Rcimzac9tknd3EKO2HQ=
Date: Thu, 16 Jun 2011 00:24:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Liao <phyomh@gmail.com>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] [perf] Add inverted call graph report support.
Message-ID: <20110615222402.GB18579@somewhere.redhat.com>
References: <BANLkTi=svHgWzyKiEHjMc-j5Hq4y5R8Mow@mail.gmail.com>
 <20110609193300.GA16858@dev1756.snc6.facebook.com>
 <20110614221517.GA20319@dev1756.snc6.facebook.com>
 <BANLkTikcxA53t1ummUG3-3TagFhj==qYjw@mail.gmail.com>
 <20110615081518.GC12496@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110615081518.GC12496@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:15:18AM +0200, Ingo Molnar wrote:
> 
> * Sam Liao <phyomh@gmail.com> wrote:
> 
> > On Wed, Jun 15, 2011 at 6:15 AM, Arun Sharma <asharma@fb.com> wrote:
> > > Sam,
> > >
> > > $ perf report -g graph,0.5,caller --sort pid
> > >
> > > is a bit hard to type. Perhaps add a simpler command line option
> > > that has the same effect?
> > >
> > >  -Arun
> > >
> > >
> > 
> > How about perf report -g [caller/callee,][graph,0.1] -s pid
> > 
> > or remove the order of the options for "-g"
> 
> We could alias the -G flag to the inverse graph.

Agreed.
-g could map to fine tuning of callchain parameters like it does right now
and we can use -G as a shortcut for inverted callchain keeping the default
settings.
 
> Plus it would be nice to allow a .perfconfig flag for people to 
> configure their desired default reporting parameters.

Yeah.

It would be also nice to have a "caller" sorting mode:

	perf report -G -s caller

This can be useful to get the entire tree of calls for each callers.
