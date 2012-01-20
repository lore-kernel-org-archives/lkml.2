Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2ATSWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 13:22:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37601 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab2ATSWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 13:22:20 -0500
Date: Fri, 20 Jan 2012 22:22:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, david@lang.hm,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andrey Vagin <avagin@openvz.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
Message-ID: <20120120182214.GI2786@moon>
References: <20120118224956.GF15652@moon>
 <m1zkdk4mj5.fsf@fess.ebiederm.org>
 <20120119065541.GA31379@moon>
 <m1ty3rukr1.fsf@fess.ebiederm.org>
 <20120120084008.GD1954@moon>
 <20120120090225.GD2786@moon>
 <4F197F73.3010000@zytor.com>
 <20120120162900.GP1954@moon>
 <4F199CE7.3020900@zytor.com>
 <20120120181954.GQ1954@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120181954.GQ1954@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 10:19:54PM +0400, Cyrill Gorcunov wrote:
> On Fri, Jan 20, 2012 at 08:57:11AM -0800, H. Peter Anvin wrote:
> > On 01/20/2012 08:29 AM, Cyrill Gorcunov wrote:
> > 
> > I would not worry about get_random_bytes() returning nothing... if
> > so, a lot of other places in the kernel would be broken.
> > 
> 
> Something like below?
> 
> 	Cyrill
> ---
...
> +
> +static __init int kcmp_cookie_init(void)
> +{
> +	int i, j;
> +
> +	for (i = 0; i < KCMP_TYPES; i++) {
> +		for (j = 0; j < 2; j++) {
> +			get_random_bytes(&cookies[i][j],
> +					 sizeof(cookies[i][j]));
> +			cookies[i][0] |= (~(~0UL >>  1) | 1);

Sigh, what a day. cookies[i][j]!

> +		}
> +	}
> +
> +	return 0;
> +}

	Cyrill
