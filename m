Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab1ACO0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:26:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53537 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab1ACO0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:26:38 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=4pdSCqo9-bIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=BJ3IY8WxZl4q7xCdmVUA:9 a=13c7ghXJcTpyIVSOn4ACf-SKUfUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Should we be using unlikely() around tests of GFP_ZERO?
From: Steven Rostedt <rostedt@goodmis.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Minchan Kim <minchan.kim@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, npiggin@kernel.dk
In-Reply-To: <AANLkTik9VodSjNnubf4Psbb9TgOEufw0m2q1_e5+X165@mail.gmail.com>
References: <E1PZXeb-0004AV-2b@tytso-glaptop>
	 <AANLkTi=9ZNk6w8PxvveWHy5+okfTyKUj3L2ywFOuFjoq@mail.gmail.com>
	 <AANLkTinz52Ky5BhU-gHq8vx9=1uoN+iuDn1f0C8fnSjQ@mail.gmail.com>
	 <1294062351.3948.7.camel@gandalf.stny.rr.com>
	 <AANLkTik9VodSjNnubf4Psbb9TgOEufw0m2q1_e5+X165@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 03 Jan 2011 09:26:36 -0500
Message-ID: <1294064796.3948.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 16:10 +0200, Pekka Enberg wrote:

> >  correct incorrect  %        Function                  File              Line
> >  ------- ---------  -        --------                  ----              ----
> >  6890998  2784830  28        slab_alloc                slub.c            1719
> >
> > That's incorrect 28% of the time.
> 
> Thanks! AFAICT, that number is high enough to justify removing the
> unlikely() annotations, no?

Personally, I think anything that is incorrect more that 5% of the time
should not have any annotation.

My rule is to use the annotation when a branch goes one way 95% or more.
With the exception of times when we want a particular path to be the
faster path, because we know its in a more critical position (as there
are cases in the scheduler and the tracing infrastructure itself).

But here, I think removing it is the right decision.

-- Steve


