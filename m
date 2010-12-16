Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab0LPUJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:09:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46893 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab0LPUJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:09:21 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=sESGoGjSBwoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=zZYJuShuEBqwDvdGYU8A:9 a=MdVPd6THerriVJu-00NznLRVGeoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH/RFC 1/2] jump label: make enable/disable o(1)
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, athieu.desnoyers@polymtl.ca,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101216194852.GD2856@redhat.com>
References: <cover.1292522251.git.jbaron@redhat.com>
	 <a35b9310aafa31a9e97f5c9bad9b09e0b6cbbf79.1292522252.git.jbaron@redhat.com>
	 <1292526602.2708.57.camel@laptop> <20101216192303.GB2856@redhat.com>
	 <1292528031.2708.77.camel@laptop> <20101216193635.GC2856@redhat.com>
	 <1292528501.2708.80.camel@laptop>  <20101216194852.GD2856@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Dec 2010 15:09:16 -0500
Message-ID: <1292530156.22905.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 14:48 -0500, Jason Baron wrote:
>  
> > static inline int atomic_read(const atomic_t *v)
> > {
> >         return (*(volatile int *)&(v)->counter);
> > }
> > 
> > The volatile simply forces a load to be emitted.
> 
> Mathieu, what do you think? Are you ok with an atomic_read() for
> checking if a tracepoint is enabled, when jump labels are disabled?

Note, I'm fine with this method too. An atomic_read() is extremely fast.
The worse that it does is to prevent gcc from optimizing a little, which
we already cause it to do due to the asm goto that we use.

-- Steve


