Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1KQW1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:27:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1KQW1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:27:21 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=hsUE5kq4_wEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=TSbVqHtbAAAA:8 a=mDV3o1hIAAAA:8 a=oM_d82_HwKmRFyHMEcYA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RFC PATCH] Tracepoint: introduce tracepoint() API
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20111117215817.GB2441@redhat.com>
References: <1321502104.3274.22.camel@edumazet-laptop>
	 <1321543520.27735.67.camel@twins> <20111117155617.GA12665@Krystal>
	 <20111117205053.GA26484@Krystal> <1321564014.3533.13.camel@frodo>
	 <20111117215817.GB2441@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 17:27:17 -0500
Message-ID: <1321568837.3533.19.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 16:58 -0500, Jason Baron wrote:

> I brought this issue up a while back, with a very similar patch to what
> Mathieu wrote. Please see:
> 
> http://thread.gmane.org/gmane.linux.kernel/838911

Ah, I remember this now. Mathieu's version is a bit nicer. And we should
only do this for those places that are the problem cases. Basically only
the places that dereference structures, or have other indirections.

> 
> One conclusion from that thread was that it would be nice if gcc could
> optimize the load so that it only happens in the unlikely path. I filed
> a gcc bug for that: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=40207,
> but it doesn't seem to be implemented yet...

I agree that this is a compiler issue, but this has been two years and
no progress. Lets go with Mathieu's solution, and we should add a Link:
tag to Jason's patches as well, with a side note that talks about
Jason's previous changes with it.

-- Steve


