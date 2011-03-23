Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab1CWL3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:29:09 -0400
Received: from linux-sh.org ([111.68.239.195]:45837 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501Ab1CWL3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:29:07 -0400
Date: Wed, 23 Mar 2011 20:28:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kay Sievers <kay.sievers@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev class and sysdev
Message-ID: <20110323112826.GB6008@linux-sh.org>
References: <201103100131.58206.rjw@sisk.pl> <201103222130.46603.rjw@sisk.pl> <1300826390.1815.5.camel@zag> <201103222200.52131.rjw@sisk.pl> <1300828356.1815.15.camel@zag> <20110322214922.GA7503@linux-sh.org> <1300831256.1815.22.camel@zag> <20110322222347.GA3978@linux-sh.org> <20110323111220.GB27671@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323111220.GB27671@sirena.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 11:12:20AM +0000, Mark Brown wrote:
> On Wed, Mar 23, 2011 at 07:23:48AM +0900, Paul Mundt wrote:
> > On Tue, Mar 22, 2011 at 11:00:56PM +0100, Kay Sievers wrote:
> 
> > > Which is what we need to get rid of. It does not make any sense on the
> > > global picture to have anything like that exported to userspace.
> 
> > So far I haven't heard any rationale for why it doesn't. Exporting CPU
> > state to userspace certainly makes sense, and the sysdev model has worked
> > reasonably for CPUs, memory nodes, etc.
> 
> FWIW it'd be really helpful to have CPUs (or at least SoCs) be regular
> struct devices for integration with the regulator API so we can have all
> things that might use a regulator (like DVFS) be struct devices but...
> 
Sure, that makes sense. The easiest would probably be to just replace the
struct cpu sysdev with a struct device pointer and fix up drivers/base/cpu.c
accordingly. The linux/cpu.h API is unfortunately rather coupled to the
idea of having a sysdev, but this is purely for attributes and attribute
groups and primarily impacts powerpc, so the conversion shouldn't be too
painful. For simple topology registration the bulk of the architectures
ultimately don't care what's backing the struct cpu within the sysfs
context.
