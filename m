Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab1F2UgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:36:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48917 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab1F2UgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:36:08 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=yGV206oZUtoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=n8i27M1mAAAA:8 a=5O3G7zNavz2zFuWJqc4A:9 a=rgZ1SMTVc69gxrmoGaQA:7 a=PUjeQqilurYA:10 a=rXZLD9m7qZoA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] plist: add mutex to the blessed lock type for plists
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dima Zavin <dima@android.com>, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <m2tyb81jml.fsf@firstfloor.org>
References: <1309376033-32005-1-git-send-email-dima@android.com>
	 <m2tyb81jml.fsf@firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 29 Jun 2011 16:36:06 -0400
Message-ID: <1309379766.26417.46.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 13:13 -0700, Andi Kleen wrote:
> Dima Zavin <dima@android.com> writes:
> 
> > Currently, plist debugging "enforces" that the plist is locked
> > with either a raw_spinlock or a spinlock. The plist data structure
> > is useful in other places, where spinlocks are unnecessary.
> >
> > Extend the plist initializers and debug checks to allow the plist
> > to be protected by a mutex
> 
> Seems really ugly and clearly not a godo path. 
> 
> It's a bit like adding a 11th argument to a function which already has 
> 10.
> 
> Perhaps better move out the locking completely to wrappers and remove
> the knowledge from the core plist code.

I don't think wrappers will help any. You still need to add some hook to
let the debugging know what type of lock is protecting a plist. It is
also nice annotation to see it. The code isn't that bad, and it is
compiled out when DEBUG_PI_LIST is not set.


-- Steve


