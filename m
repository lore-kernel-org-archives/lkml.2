Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab2BUARn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 19:17:43 -0500
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:49876 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278Ab2BUARl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 19:17:41 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Feb 2012 19:17:41 EST
X-AuditID: 1209190f-b7f8a6d000000914-0d-4f42e1784101
Message-ID: <4F42E171.9080005@mit.edu>
Date: Mon, 20 Feb 2012 16:12:33 -0800
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, hjl.tools@gmail.com
Subject: Re: [PATCH 30/30] x32: Add x32 VDSO support
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <1329696488-16970-31-git-send-email-hpa@zytor.com>
In-Reply-To: <1329696488-16970-31-git-send-email-hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsUixG6nolvx0Mnf4M8zDos569ewWWxfd5jZ
	YtpGcYuOXV9ZLC7vmsNmsfrfKUaLzZumMls86nvL7sDhsXPWXXaPTas62TzenTvH7nFixm8W
	j8+b5DxOtHxhDWCL4rJJSc3JLEst0rdL4Mo4/vcqa8F2jorGP9wNjCfZuhg5OSQETCQ+Xu9k
	grDFJC7cWw8U5+IQEtjHKNFzazqUs4FR4siH81DOCyaJKdcug7XzCqhJ3F72lxXEZhFQldix
	pxMsziagItGx9AHYWFGBCIl3C7czQtQLSpyc+YQFxBYBqpn+8xMTyFBmgcOMEs9nXWAGSQgD
	3dT35CPYUCGBAolNiz+CNXAK2EtcW3gDzGYW0JF41/eAGcKWl9j+dg7zBEbBWUh2zEJSNgtJ
	2QJG5lWMsim5Vbq5iZk5xanJusXJiXl5qUW6Jnq5mSV6qSmlmxhBMcIpyb+D8dtBpUOMAhyM
	Sjy8XKVO/kKsiWXFlbmHGCU5mJREeY8+AArxJeWnVGYkFmfEF5XmpBYfYpTgYFYS4S1bCpTj
	TUmsrEotyodJSXOwKInzqmm98xMSSE8sSc1OTS1ILYLJynBwKEnwvgIZKliUmp5akZaZU4KQ
	ZuLgBBnOAzRc7iHI8OKCxNzizHSI/ClGRSlxXlaQhABIIqM0D64XlsJeMYoDvSLM+w1kBQ8w
	/cF1vwIazAQ0uOW/I8jgkkSElFQDo9zOGddK5BxrZ3nV5DgdcFaZp3U3h8/8xqInE3bNdtCd
	eXHvz5SPL7//XybgaG8daZAstv1o7Wsj/r0Bm36c0G2cHhrNPMHZnpe3yr6r0XercNgtAfvA
	x5/f+z727S9duDfNRuWH/fXZb3V7wj8dn5u4KU3S57LWiYgpizVf7GnseDH3Y+46FSWW4oxE
	Qy3mouJEAAcU2Cw8AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 04:08 PM, H. Peter Anvin wrote:
> From: "H. J. Lu" <hjl.tools@gmail.com>
> 
> Add support for the x32 VDSO.  The x32 VDSO takes advantage of the
> similarity between the x86-64 and the x32 ABIs to contain the same
> content, only the container is different, as the x32 VDSO obviously is
> an x32 shared object.

> +
> +/*
> + * This controls what userland symbols we export from the vDSO.
> + */
> +VERSION {
> +	LINUX_2.6 {
> +	global:
> +		clock_gettime;
> +		__vdso_clock_gettime;
> +		gettimeofday;
> +		__vdso_gettimeofday;
> +		getcpu;
> +		__vdso_getcpu;
> +		time;
> +		__vdso_time;
> +	local: *;
> +	};
> +}
> +

Would it make sense to remove the non-__vdso-prefixed weak symbols?
AFAICT they are somewhere between useless (because the __vdso symbols
are unambiguous), confusing (has anyone not read this and said "huh?"),
and wrong (they are not interchangeable with glibc's symbols as they
return different values).

We're stuck with them on x86-64, but x32 is new and has no
backwards-compatibility issues.

--Andy
