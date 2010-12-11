Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0LKAJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:09:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab0LKAJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 19:09:14 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=ol3fQ0Bz-dcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=IJv9LcIfAAAA:8 a=BuHDjuvowRZ33NWagAcA:9 a=A6reI9-EYARj1Ay9-4zQKYbbaGcA:4 a=PUjeQqilurYA:10 a=K6kUPx8HyhEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 02/10] mm: Remove likely() from
 mapping_unevictable()
From: Steven Rostedt <rostedt@goodmis.org>
To: Miles Bader <miles@gnu.org>
Cc: Joe Perches <joe@perches.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <buok4jikq3e.fsf@dhlpc061.dev.necel.com>
References: <20101207021328.569328536@goodmis.org>
	 <1291688533.16223.119.camel@gandalf.stny.rr.com>
	 <20101210160115.C7C4.A69D9226@jp.fujitsu.com>
	 <1291964792.24978.3.camel@Joe-Laptop>
	 <buok4jikq3e.fsf@dhlpc061.dev.necel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 10 Dec 2010 19:09:12 -0500
Message-ID: <1292026152.5015.1541.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 17:08 +0900, Miles Bader wrote:
> Joe Perches <joe@perches.com> writes:
> > It'd be better to use
> >
> > 	if (!mapping)
> > 		return 0;
> > 	return test_bit(AS_UNEVICTABLE, &mapping->flags);
> >
> > to avoid the unnecessary !!
> 
> How about 
> 
>  	return mapping && test_bit(AS_UNEVICTABLE, &mapping->flags);
> 
> instead...?

I'll just add my current patch as a "likely()" clean up. Any other
change should be separate.

Thanks,

-- Steve


