Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1CJVym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:54:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59503 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab1CJVyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:54:41 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7vSkPOS3JZ6F2Jngs50A:9 a=mcRdFO8CsdorMEg9A0NCGIKeevQA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 10 Mar 2011 16:54:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Hounschell <markh@compro.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel git bisect question
Message-ID: <20110310215438.GE12521@home.goodmis.org>
References: <4D793414.4090206@compro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D793414.4090206@compro.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 03:27:00PM -0500, Mark Hounschell wrote:
> Between git bisect [good | bad ]s should I always "make clean" or can I
> count on the build system to take care of everything properly?

I don't usually do a make clean. Although my ktest.pl (see tools/testing/ktest)
does do a make mrproper between builds (unless you specify not to).

There are some cases in the kernel that can cause bugs if you do not do
a make clean, so if your bisect hits one of those rare cases, you may
introduce a bug in the build. But that is extremely rare. Like I said, when I use to
do manual git bisects, I never did a make clean. But now that I do
automate bisects, and do not need to babysit the box, I let ktest do
those cleans.

-- Steve

