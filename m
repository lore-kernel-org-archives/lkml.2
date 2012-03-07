Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887Ab2CGSpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:45:33 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:57773 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759673Ab2CGSpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:45:32 -0500
Date: Wed, 7 Mar 2012 13:44:55 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Peter Seebach <peter.seebach@windriver.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anton Blanchard <anton@samba.org>, paulus@samba.org,
        peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com,
        fweisbec@gmail.com, yanmin_zhang@linux.intel.com, emunson@mgebm.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120307184455.GA13565@elliptictech.com>
References: <20120307114249.44275ca3@kryten>
 <20120307010904.GE5656@infradead.org>
 <20120306192912.59811e3e@wrlaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306192912.59811e3e@wrlaptop>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-06 19:29 -0600, Peter Seebach wrote:
> To frame it another way:  Imagine an alternative function, called
> slenprintf(), which is just like snprintf except that it returns the
> number of bytes written instead of the number it would have liked to
> write in the event that the buffer isn't big enough.  And also
> vslenprintf(), analogous to vsnprintf().
> 
> Now consider what happens if you have one and want the semantics of the
> other:
[...]
> size_t
> mysnprintf(char *buffer, size_t len, char *fmt, ...) {
>     size_t ret;
>     va_list ap;
>     va_start(ap, fmt)
>     ret = vslenprintf(buffer, len, fmt, ap);
>     /* now what? */

To answer the question, one "solution" here is to run in a loop
allocating larger and larger buffers until ret is strictly less
than len, then (for this function) free the allocated buffer.

There are a couple functions in POSIX that work this way (*cough*
readlink *cough*), and it's *ugly*.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

