Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab1EXUba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:31:30 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:42295 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab1EXUb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:31:29 -0400
Date: Tue, 24 May 2011 16:31:11 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        fbuihuu@gmail.com, paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
In-Reply-To: <20110524154020.GA26516@elte.hu>
Message-ID: <alpine.DEB.2.00.1105241616280.24062@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu> <1306182141.2497.5.camel@laptop> <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu> <1306233036.2497.15.camel@laptop> <alpine.DEB.2.00.1105241041490.10575@cl320.eecs.utk.edu>
 <1306249830.18455.41.camel@twins> <20110524154020.GA26516@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Ingo Molnar wrote:
> 
> Btw., how did it happen that the PAPI tests did not get run against upstream 
> over the course of about half a year, two full stable kernels released:

we run regresion tests nightly.  There was a bug in our 
  "create two events and sample on the second"
test, where it was actualy sampling on the first counter by mistake.
When I fixed the test to do what it claimed to do it found the bug.

PAPI runs on at least 5 different operating systems, 3 different
Linux perf counter implementations, and on kernels dating back to 2.4.
Plus numerous architectures.  While we try to test against recent
Linux perf_events, we just don't have the hardware to be comprehensive.

It doesn't help that our test machines are primarily used for GPGPU work
during the day, so we're limited to what kernels we can have installed
due to driver issues.

> suggest moving these usecases into 'perf test' or so - that it gets run every 
> day:

you can feel free to install PAPI on your test machines and give it a run 
daily too.  It's open source

  setenv CVSROOT :pserver:anonymous@cvs.eecs.utk.edu:/cvs/homes/papi 
  cvs login
  cvs co all

  cd papi
  ./configure
  make
  ./run_tests

There are often false negatives on the tests that can be a pain
to track down.  Welcome to my world.  We gladly accept patches.

Vince
