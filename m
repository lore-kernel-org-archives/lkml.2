Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2FEMkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:40:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55415 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2FEMkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:40:09 -0400
Message-ID: <1338899999.28282.164.camel@twins>
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org
Date: Tue, 05 Jun 2012 14:39:59 +0200
In-Reply-To: <1338898024.28282.160.camel@twins>
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
	 <CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
	 <CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>
	 <1338891271.28282.155.camel@twins>
	 <CABPqkBSv8CbMzUiRsN2uOF1v6rFTpzhQqNbo7OKe-nzsus0GDg@mail.gmail.com>
	 <1338892071.28282.157.camel@twins>
	 <CABPqkBSqLpa4X-WbR0PkouYvhODT78r3pxWq70=PTj1j=a307Q@mail.gmail.com>
	 <1338898024.28282.160.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 14:07 +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 12:38 +0200, Stephane Eranian wrote:
> > How about we add a field or flag to cpuc to tell it's fake, and then
> > in
> > try_alt_er() and __intel_shared_reg_get_constraints() we avoid
> > touching
> > live struct (like reg->alloc) if fake==1. I think he was trying to do
> > the same with the core_id == -1 test. 
> 
> We might have to do something like that, however I'm trying to figure
> out when that reg->alloc test in __intel_shared_reg_get_contraints() is
> useful.
> 
> If it is useful in event scheduling, we cannot just leave it out in
> validate_group().

OK, so x86_schedule_events() can call that multiple times on the same
event in case we keep adding events.. it needs the constraints of the
previous events as well, and in that case we skip the whole extra_reg
muck.

But for validate_group() we only do this once, so it should work. Nasty
though.



