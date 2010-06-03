Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0FCG6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:58:44 -0400
Received: from smtp-out.google.com ([74.125.121.35]:19876 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab0FCG6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:58:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=ekiRdcgVp8aLBucseZ3H/+d51nxf6uxv4UAz/p3yrwgcoV7Eg5ULtvmaBeC/+Yu1S
	mhI1qxYCwytmWvN4UK/bQ==
MIME-Version: 1.0
In-Reply-To: <20100603042403.GC20028@linux-sh.org>
References: <Pine.LNX.4.44L0.1005271141410.3239-100000@iolanthe.rowland.org>
	<alpine.LFD.2.00.1005271751240.3032@localhost.localdomain>
	<20100603042403.GC20028@linux-sh.org>
Date: Wed, 2 Jun 2010 23:58:37 -0700
Message-ID: <AANLkTinxP73uOG4XtnTtS1LZnWDvvgpAFN5Uv_xdKEwk@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Brian Swetland <swetland@google.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Arve Hj?nnev?g" <arve@android.com>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 9:24 PM, Paul Mundt <lethal@linux-sh.org> wrote:
>
> On the other hand, while this isn't that difficult for the UP case it
> does pose more problems for the SMP case. Presently the suspend paths
> (suspend-to-RAM/hibernate/kexec jump) all deal with disabling and
> enabling of non-boot CPUs via CPU hotplug explicitly, which will clear
> them from the online CPU map. We would have to rework the semantics a bit
> if cpuidle were also permitted to opportunistically offline CPUs.

That's definitely something we'd be interested in looking at.  Some
upcoming ARM v7 architecture SMP SoCs we're seeing will support full
independent clock scaling and power gating for the individual cores --
if there's not enough work to keep the 2nd (or nth) cpu busy, there
would be good power savings to be had shutting it down.

I haven't poked around too much with how things work in SMP
environments -- are there per-cpu idle threads?

Brian
