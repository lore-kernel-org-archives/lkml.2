Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab1ERNaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:30:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab1ERNaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:30:21 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=UWMw6JNi2FwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=g-yS39ANLg_9dPtGpbIA:9 a=znYNwHQpnrmOwAPnkeQA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] x86, ftrace: Fix compiler warning in ftrace.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <BANLkTinUCh_ZbfxEtC4XYOqN_q6_yBq92Q@mail.gmail.com>
References: <1305221620.7986.4.camel@localhost.localdomain>
	 <1305648241.5456.743.camel@gandalf.stny.rr.com>
	 <BANLkTim2rcr9F=5+C9t-BU8OVfbWw5mFyQ@mail.gmail.com>
	 <1305654302.5456.751.camel@gandalf.stny.rr.com>
	 <BANLkTinUCh_ZbfxEtC4XYOqN_q6_yBq92Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 18 May 2011 09:30:19 -0400
Message-ID: <1305725419.26849.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 11:02 +0600, Rakib Mullick wrote:
> 

>         
> Cause, __probe_kernel_write() currently takes void * as its parameter.
> That means all the users of __probe_kernel_write() currently passes
> void *. If we change __probe_kernel_write's parameter ( src) from void
> * to const void * , then all the callers also needs to do that. Isn't
> it?

No.

Look at __probe_kernel_write() itself. It calls
__copy_to_user_in_atomic() which takes const void *src, where we pass in
void *src. That __probe_kernel_write() having void *src is actually a
bug.

Make that a separate patch, or maybe I'll just do it.

-- Steve



