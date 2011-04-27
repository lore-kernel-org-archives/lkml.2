Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab1D0ODh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:03:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894Ab1D0ODf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:03:35 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=XYJHFtupD_QA:10 a=yvBG9YuN2l4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3J4kajBME3dDW4uYzyAA:9 a=wTwojRmyW5iaIv-n99kA:7 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 27 Apr 2011 10:03:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rafa?? Mi??ecki <zajec5@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Botting <andy@andybotting.com>
Subject: Re: Crash with kfree(null) on MacBook? kobject_set_name_vargs
Message-ID: <20110427140333.GA22909@home.goodmis.org>
References: <BANLkTi=n+ckDXVk6rN=Mgh+BApbrPqPfmg@mail.gmail.com>
 <BANLkTi=R_D9ujCFeKv_o_U83GAR35X3TOQ@mail.gmail.com>
 <BANLkTincyn_2FrSYwJnNNnYE9WdyVzoHFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTincyn_2FrSYwJnNNnYE9WdyVzoHFA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 09:38:02PM +0200, Rafa?? Mi??ecki wrote:
> Thank you Linus, now when you made it clear to me that NULL ~!= NULL,
> I realized I didn't zeroed struct which contains struct dev.
> 
> struct axi_device core;
> vs.
> struct axi_device core = { };

The two are identical. If they are declared as globals or static. As
globals and static variables are initialized to zero at start up.

Is this on the stack or global? If on the stack, you need the
initializer, if it is global you do not.

IOW:

struct axi_device core;
static struct axi_device core;

void func(void)
{
	static struct axi_device core;
[...]

All the above is OK with no initializer.

void func(void)
{
	struct axi_device core = {};


This does need an initializer, but gcc should complain if you use core
without initializing.

-- Steve

