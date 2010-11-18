Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343Ab0KRUmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:42:09 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:63410 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758535Ab0KRUmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:42:07 -0500
Message-ID: <4CE58F70.5040407@cs.columbia.edu>
Date: Thu, 18 Nov 2010 15:41:20 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: david@lang.hm
CC: Davide Libenzi <davidel@xmailserver.org>,
        Matt Helsley <matthltc@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <4CD23087.30900@cs.columbia.edu> <4CD28033.1000700@kernel.org> <20101106101209.GD11535@count0.beaverton.ibm.com> <alpine.DEB.2.00.1011071032001.29896@davide-lnx1> <alpine.DEB.2.00.1011071817560.24952@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1011071817560.24952@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/07/2010 09:32 PM, david@lang.hm wrote:
> On Sun, 7 Nov 2010, Davide Libenzi wrote:
> 
>> Please, do not compare things like single file systems, drivers, or
>> otherwise fairly isolated components, with this "thing".
>> This thing touches a freaky-large number of subsystems, effectively
>> adding a glueage between them, which can might end up causing problems
>> (and/or restrict design choices) in the future.
> 
> I've got a question about the ABI that would be created
> 
> I see two possible areas that could be considered an ABI
> 
> 1. control of the C/R process
> 
>   This is very clearly a userspace ABI, to be figured out and locked
> down like any other ABI
> 
> 2. the details of how things are stored and added back into a system
> 
>   This is not as clear. at one extreme, this could be like the module
> interface, (the checkpointed image is only guaranteed to work on a new
> system with a kernel compiled with the same config options as the system
> it was checkpointed from). At the other extreme, this could be something
> that allows you to ckeckpoint an image on 2.6.40 and restore it on
> 2.6.80. Or it could be something in between.
> 
> I don't see any way that it is sane to make the C/R image defiition and
> interface (#2) be an ABI that is guaranteed to never change without
> hurting future kernel development (exactly the type of things that
> Davide is worried about above), but what sort of guarantee are people
> interested in?

Agreed. The guarantee should be to specific kernels, in a sense (see
Matt's post in this thread 11/17).

The image format is tied to "set of features supported" (which boils
down to something like kernel version).  The format is constructed
in a modular way such that most new features can be added without
breaking old format. For the rare cases that they do, conversion
can be done in userspace in a straightforward manner. (All you need
is convert from N to N+1).

> 
> is it enough to sa that it must be the same kernel version compiled with
> the same options? (or at least the same options for some list of things
> that matter, most device drivers probably would not matter for example)
> 
> or would you need compatibility across all compile options for a kernel
> release?
> 
> would you require compatibility between 2.6.x.y and 2.6.x.z?
> 
> would you require compatibility between 2.6.x and 2.6.x+n (for some
> value of n)?
> 
> is this something that could go in with the weakest guarantee initially,
> and then as everyone is more comfortable with it, start extending the
> guarantee (and as-needed adding code to the kernel to maintain
> compatibility with old images)?
> 
> would you require compatibility between 2.6.x and 2.6.x-n?

We don't "require" compatibility. The compatibility is defined per
object (type) in the image format. New objects need not break
compatibility. Changes to objects are very rare; and when they happen
they "bump" the version. This can help avoid issues related to kernel
configs/options. Restarting an image incompatible with a particular
kernel will fail, adjustments should be done by userspace filtering.

Thanks,

Oren.
