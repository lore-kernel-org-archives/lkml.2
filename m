Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab2JUSnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 14:43:41 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52431 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab2JUSnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 14:43:39 -0400
Date: Sun, 21 Oct 2012 20:43:30 +0200
From: Rabin Vincent <rabin@rab.in>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Dave Martin <dave.martin@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com
Subject: Re: [PATCH 9/9] ARM: add uprobes support
Message-ID: <20121021184324.GC4840@ubuntu>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
 <1350242593-17761-9-git-send-email-rabin@rab.in>
 <20121015111443.GA2006@linaro.org>
 <CAH+eYFC1fr0vpK2T4hz9LK=Nz5bzQBQ4O-o0f9tsnj-_D9ZEJg@mail.gmail.com>
 <20121015174450.GB18614@linaro.org>
 <1350485448.3206.146.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350485448.3206.146.camel@linaro1.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 03:50:48PM +0100, Jon Medhurst (Tixy) wrote:
> I just been looking at the decoding changes in patch 8 and had similar
> thoughts. The patch as it stands looks rather bolted on the side and
> makes the resulting code rather messy.

I agree.

> a) uprobes is similar enough to kprobes that the existing code can be
> morphed into something that cleanly supports both, or
> 
> b) the similarities aren't close enough and that we should factor out
> the similarities into a more generalised decoding base, which the
> {u,k}probe code can then build on.
> 
> c) some mix of a) and b)
> 
> I can't help but think of the various calls over the past year or so for
> a general ARM/Thumb instruction decoding framework (the last one only a
> few weeks ago on the linux-arm-kernel list). Perhaps b) would be a small
> step towards that.
> 
> I hope to find some time to understand the uprobe patches in more
> detail, so I can try and come up with some sensible suggestions on a
> cleaner solution; because I feel that as they stand they aren't really
> suitable for inclusion in the kernel.

I contemplated sending the decoding patch with [RFC] but finally went
with [PATCH] since they mostly mean the same thing :-).

Suggestions welcome.  For one thing, the creation of a fake struct
kprobe from within the uprobes and the dependency on kprobes because of
that is not very nice, we probably need a "struct probe" of some sort
perhaps.

> Rabin, what tree/commit are your patches based on? (They don't seem to
> apply cleanly to 3.6 or 3.7-rc1.) I want to apply them locally so I can
> use my favourite visualisation tool and to play with them.

The patches are based on next-20121012.  The uprobes core is seeing
quite a few changes in linux-next so the series will probably not apply
on later linux-next trees.
