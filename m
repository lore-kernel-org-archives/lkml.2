Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1IOI4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 04:56:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60986 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab1IOI4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 04:56:43 -0400
Subject: Re: [PATCH 0/9] Per-cgroup /proc/stat
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, jbottomley@parallels.com,
        Paul Turner <pjt@google.com>
Date: Thu, 15 Sep 2011 10:56:29 +0200
In-Reply-To: <m2fwjyg9fx.fsf@firstfloor.org>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	 <1316031196.5040.46.camel@twins> <m2fwjyg9fx.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316076989.3045.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 13:23 -0700, Andi Kleen wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> >
> > Guys we should seriously trim back a lot of that code, not grow ever
> > more and more. The sad fact is that if you build a kernel with
> > cpu-cgroup support the context switch cost is more than double that of a
> > kernel without, and then you haven't even started creating cgroups yet.
> 
> That sounds indeed quite bad. Is it known why it is so costly?

Mostly because all data structures grow and all code paths grow, some by
quite a bit, its spread all over the place, lots of little cuts etc..

pjt and I tried trimming some of the code paths with static_branch() but
didn't really get anywhere.. need to get back to looking at this stuff
sometime soon.
