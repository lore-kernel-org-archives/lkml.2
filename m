Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2I0Na3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:30:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14915 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2I0Na0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:30:26 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=LrhBLfKaQO8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SlKO6I3lSDoA:10 a=YO3Hm7etAV1sroPDY0oA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348752623.22822.73.camel@gandalf.local.home>
Subject: Re: [PATCH v6] hashtable: introduce a small and naive hashtable
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>, torvalds@linux-foundation.org,
        tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, neilb@suse.de, bfields@fieldses.org,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        josh@joshtriplett.org, rmallon@gmail.com, palves@redhat.com
Date: Thu, 27 Sep 2012 09:30:23 -0400
In-Reply-To: <20120927131118.GC30139@Krystal>
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com>
	 <1348667992.22822.50.camel@gandalf.local.home> <506310AA.2050700@gmail.com>
	 <20120926143905.GB22699@Krystal>
	 <1348675764.22822.56.camel@gandalf.local.home>
	 <20120926161956.GB28648@Krystal>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7009@saturn3.aculab.com>
	 <50640F4E.4020305@gmail.com> <20120927131118.GC30139@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 09:11 -0400, Mathieu Desnoyers wrote:

> AFAIK, gcc nowadays use "inline" only as a hint

Only if CONFIG_OPTIMIZE_INLINING is set.

>From include/linux/compiler-gcc.h:

#if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
    !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
# define inline         inline          __attribute__((always_inline)) notrace
# define __inline__     __inline__      __attribute__((always_inline)) notrace
# define __inline       __inline        __attribute__((always_inline)) notrace
#else
/* A lot of inline functions can cause havoc with function tracing */
# define inline         inline          notrace
# define __inline__     __inline__      notrace
# define __inline       __inline        notrace
#endif

-- Steve


