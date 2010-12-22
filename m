Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab0LVWvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 17:51:37 -0500
Received: from smtp-out.google.com ([74.125.121.67]:22405 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab0LVWvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 17:51:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=KqE+Rjn3C3ryAYfShw9hLTFPKpTnT/tKF29TciK+uavtv2u0eYx1VtVVAcM2y7e27U
         Z9ZjstQP7B+WVP2auaTw==
Date: Wed, 22 Dec 2010 14:51:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Venkatesh Pallipadi <venki@google.com>, "H. Peter Anvin" <hpa@zytor.com>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikanth Karthikesan <knikanth@suse.de>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH -v2 2/2] x86, acpi: Parse all SRAT cpu entries even have
 cpu num limitation
In-Reply-To: <AANLkTim7GbOJzjt9Wdba-pdAj+GUR1xZCqOv+bDmypTj@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1012221446460.2612@chino.kir.corp.google.com>
References: <20101111100628.GA24728@localhost> <1289478978.2084.74.camel@laptop> <20101111124015.GA9706@localhost> <1289480656.2084.80.camel@laptop> <20101113084018.GA23098@localhost> <1289644224.2084.521.camel@laptop> <20101113120030.GA31517@localhost>
 <1289653078.2084.675.camel@laptop> <20101113131042.GA5522@localhost> <4CDEE314.6090107@kernel.org> <20101113235746.GA9458@localhost> <4CDF3DA1.2090806@kernel.org> <4D093ABB.4030206@zytor.com> <4D0943D5.1090404@kernel.org> <4D094703.7080701@zytor.com>
 <4D0AD464.2020408@kernel.org> <4D0AD486.9020704@kernel.org> <AANLkTin-LGig2RHHmvvy5H04jQRus_1mmS1Cr4KDWKsN@mail.gmail.com> <4D0BB9AD.90506@kernel.org> <AANLkTimw_nvDEb4t1nOQFCtY8fx6fvg5Mmy+6vZw8mw1@mail.gmail.com> <AANLkTi=VYooLbwWkTCSfQ38z=UO_kQZyQyKaw-5+kyYn@mail.gmail.com>
 <alpine.DEB.2.00.1012212230580.9505@chino.kir.corp.google.com> <AANLkTim7GbOJzjt9Wdba-pdAj+GUR1xZCqOv+bDmypTj@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010, Venkatesh Pallipadi wrote:

> > Peter just merged my NUMA emulation fixes into the x86 tree, could you try
> > applying Yinghai's series on top of x86/linux-2.6-tip.git#x86/numa and see
> > if the problem persists?
> >
> > On a different topic: Yinghai, do you think you could base your series off
> > of Tejun's x86_32/x86_64 NUMA unification series since it already
> > duplicates some of the work?
> >
> 
> Yes. #x86/numa kernel works fine both with and without Yinghai's series.
> I am assuming those changes are lined up for .38. Is there any
> specific fix that can make into .37 to fix this regression?
> 

The specific fix should be d845c04a from that tree (x86, numa: Fake 
node-to-cpumask for NUMA emulation).

Peter, I'm assuming these fixes are on track for .38 (although they have 
been pending for a couple months and I was hoping for .37 inclusion)?
