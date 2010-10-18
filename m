Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab0JRPDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:03:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab0JRPDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:03:32 -0400
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
From: Eric Paris <eparis@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@parisplace.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com,
        devel@lists.fedoraprojet.org
In-Reply-To: <20101018145930.GE4120@thunk.org>
References: <20101016065206.GO4681@dastard>
	 <20101016192027.GA6883@infradead.org>
	 <1287295077.3020.83.camel@localhost.localdomain>
	 <1287313332.1998.172.camel@laptop>
	 <AANLkTinNbF9=5Ojn8kKEvSkGbpqQw+DGKyRWhAD1AYZK@mail.gmail.com>
	 <1287323960.1998.360.camel@laptop>
	 <1287324983.2530.35.camel@localhost.localdomain>
	 <1287403048.29097.1553.camel@twins>  <20101018145930.GE4120@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 11:02:53 -0400
Message-ID: <1287414173.2530.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 10:59 -0400, Ted Ts'o wrote:
> On Mon, Oct 18, 2010 at 01:57:28PM +0200, Peter Zijlstra wrote:
> > Well, you could use the actual freezer to freeze luserspace and then
> > simply iterate all open files, I mean, those few sods who actually want
> > this enabled can either pass a boot option to enable from boot or suffer
> > the overhead on enable, right?
> 
> I'm a little confused why anyone would want to turn on IMA at any time
> other than right away at boot?  If you haven't been doing integrity
> management checking from the very beginning of the boot process, what
> does turning on IMA after the system has booted buy you in the way of
> security protections?
> 
> In other words, turning on IMA via a boot option seems to be the only
> thing that makes any sense at all.

It can be turned on any time inside the initrd without loss of integrity
assuming the kernel and initrd were both measured and stored in a TPM
PCR.  I'm willing to agree that the usefulness might be limited, but it
isn't non-existant.  I'm going to make a note to look at other ways to
cut down the memory usage.

-Eric

