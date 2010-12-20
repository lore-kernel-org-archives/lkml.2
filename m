Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab0LTKut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:50:49 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:33738 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755698Ab0LTKuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:50:44 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+sA8EySRqsL69IJvrVjLABwFuHjde58ePG2cU6U9
	eKVgSBwjBDIXzE
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D0F34C0.9000400@redhat.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>
	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>
	 <1292615509.7381.81.camel@marge.simson.net>  <4D0CE937.8090601@redhat.com>
	 <1292699204.1181.51.camel@marge.simson.net>  <4D0DA45A.9070600@redhat.com>
	 <1292753156.16367.104.camel@marge.simson.net> <4D0DCE10.7000200@redhat.com>
	 <1292834372.8948.27.camel@marge.simson.net> <4D0F1794.3010803@redhat.com>
	 <1292835302.8948.35.camel@marge.simson.net> <4D0F1BD8.20601@redhat.com>
	 <1292837440.8948.60.camel@marge.simson.net> <4D0F25E8.80305@redhat.com>
	 <1292841193.11946.36.camel@marge.simson.net> <4D0F3266.90908@redhat.com>
	 <1292842010.11946.39.camel@marge.simson.net>  <4D0F34C0.9000400@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 11:50:43 +0100
Message-ID: <1292842243.11946.40.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 12:49 +0200, Avi Kivity wrote:
> On 12/20/2010 12:46 PM, Mike Galbraith wrote:
> > >
> > >  However, if I'm all alone on my cpu, and the other task is runnable but
> > >  not running, behind some unrelated task, then I do need that task to be
> > >  preempted (or to move tasks around).
> >
> > So in that case, a pull may be advantageous.
> 
> Yes.
> 
> > >  >  Would a kick/hint option be useful?
> > >
> > >  Depends on what it does...
> >
> > Let you decide whether you only want to drop a hint and leave it at
> > that, or also attempt a preemption.
> 
> Who is "you" in this?  the scheduler?

The caller.

> I'm fine with hints so long as they are usually acted upon (if it isn't, 
> I'll go back to the guest, spin a bit more, and retry).



