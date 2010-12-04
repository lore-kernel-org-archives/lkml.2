Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0LDBnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 20:43:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39604 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0LDBnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 20:43:31 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=m4z5O64LGoQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=MWmFdflc5ijyW7JVrEwA:9 a=tdS4GyYJSJW-1WUiiKraqd75mIUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 03/15] ring_buffer: Align buffer_page struct
 allocations only to fit the flags.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com
In-Reply-To: <1291421609-14665-4-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-4-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Dec 2010 20:43:28 -0500
Message-ID: <1291427008.16223.7.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
> buffer_page structs need to be aligned to 4 byte boundaries because the page
> flags are stored in the two least-significant bits of the pointers in the page
> list. Aligning to cache lines is sufficient, but doesn't seem to be necessary.
> Reducing the alignement to only 4 bytes may improve cache efficiency.

The reason for the cache line boundaries because the bpages are per cpu,
and if they are allocated next to some variable that gets change
globally or even another bpage that is used for another cpu buffer, then
I would expect we would get some cache line bouncing.

Perhaps we should make bpage have its own slab allocation
(kmem_cache_alloc). And perhaps even try to keep all bpages that share
the same cache line on the same cpu buffer.

-- Steve


