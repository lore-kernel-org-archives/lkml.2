Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab2FEKie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:38:34 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49834 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932671Ab2FEKid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:38:33 -0400
MIME-Version: 1.0
In-Reply-To: <1338892071.28282.157.camel@twins>
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
	<CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>
	<1338891271.28282.155.camel@twins>
	<CABPqkBSv8CbMzUiRsN2uOF1v6rFTpzhQqNbo7OKe-nzsus0GDg@mail.gmail.com>
	<1338892071.28282.157.camel@twins>
Date: Tue, 5 Jun 2012 12:38:31 +0200
Message-ID: <CABPqkBSqLpa4X-WbR0PkouYvhODT78r3pxWq70=PTj1j=a307Q@mail.gmail.com>
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 12:27 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-06-05 at 12:21 +0200, Stephane Eranian wrote:
>> I agree with the first part of the patch in intel_try_alt_er(), we
>> should not touch
>> the actual event struct. But I am still unclear about the reg->alloc part.
>
> reg->alloc is part of the actual event.
>
Ok, I missed that (despite writing some of that code ;-<)

> Thing is, the patch is horridly ugly.. while I agree that changing event
> state isn't good, special casing all that code isn't good either.

Yeah, not pretty.

>
> I was looking at cloning the events for validate_group() as well, but so
> far that's not turning out too pretty either.

How about we add a field or flag to cpuc to tell it's fake, and then in
try_alt_er() and __intel_shared_reg_get_constraints() we avoid touching
live struct (like reg->alloc) if fake==1. I think he was trying to do the same
with the core_id == -1 test.
