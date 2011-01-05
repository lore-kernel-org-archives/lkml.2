Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab1AER20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:28:26 -0500
Received: from canuck.infradead.org ([134.117.69.58]:57224 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab1AER2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:28:24 -0500
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D24A822.4000009@redhat.com>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	 <20110103162918.577a9620@annuminas.surriel.com>
	 <1294164289.2016.186.camel@laptop>  <4D24A5F4.3000508@redhat.com>
	 <1294247718.2016.269.camel@laptop>  <4D24A822.4000009@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 18:28:31 +0100
Message-ID: <1294248511.2016.274.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 19:19 +0200, Avi Kivity wrote:
> On 01/05/2011 07:15 PM, Peter Zijlstra wrote:
> > On Wed, 2011-01-05 at 19:10 +0200, Avi Kivity wrote:
> > >  On 01/04/2011 08:04 PM, Peter Zijlstra wrote:
> > >  >  This definitely wants to be EXPORT_SYMBOL_GPL() and if it were possible
> > >  >  I'd make it so only kvm.o could use it. It really sucks that kvm is a
> > >  >  module.
> > >
> > >  Why does it suck?  I mean apart from the "virtualization is crap" song.
> >
> > Because it needs hooks all over the core kernel, like this yield_to()
> > stuff. Exporting this might lead to others wanting to use it too.
> 
> Well, it's very convenient for development (modprobe vs. reboot).

Get a machine that boots fast ;-), it might be because I've never worked
on anything modular, but typically stuff crashes when I got it wrong, in
which case you're forced to power-cycle anyway.

>   What hooks do you object to? 

Don't really keep a list, but every now and again see something that
makes me think that ought not be exported.

> mmu notifiers are useful for some drivers, sched 
> notifiers are useful for cmwq and possibly perf?

Both use explicit function calls because its easier to read the code and
faster.
