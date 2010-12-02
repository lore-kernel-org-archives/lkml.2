Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab0LBPBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 10:01:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399Ab0LBPBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 10:01:19 -0500
Date: Thu, 2 Dec 2010 10:00:45 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Dan Carpenter <error27@gmail.com>, Vasiliy Kulikov <segoon@openwall.com>,
        kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: rc: ir-lirc-codec: fix potential integer overflow
Message-ID: <20101202150045.GA32168@redhat.com>
References: <20101202045126.GA1784@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202045126.GA1784@bicker>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 07:51:26AM +0300, Dan Carpenter wrote:
> On Fri, Nov 26, 2010 at 08:06:35PM +0300, Vasiliy Kulikov wrote:
> >  	count = n / sizeof(int);
> > -	if (count > LIRCBUF_SIZE || count % 2 == 0)
> > +	if (count > LIRCBUF_SIZE || count % 2 == 0 || n % sizeof(int) != 0)
>                                                       ^^^^^^^^^^^^^^^^^^^^
> 
> Wait, what?  We just checked this a couple lines before.

Bah. I'd only looked at the diff, which didn't have enough context. I
thought that looked familiar. Indeed, this part seems to be unnecessary.

> The rest of the patch is right and a clever catch.  It would affect 
> x86_64 systems and not i386.  This doesn't have security implications
> does it?  You'd just catch the kmalloc() stack trace for insanely large
> allocations.

Even on x86_64, it looks to my (relatively untrained) eye like you'd
actually be fine. n is a size_t (so, 64-bit on x86_64). count is an int
(so 32-bit on x86_64). We initialize count to some 64-bit value / 4, so
at most, 16 bits, which always fits just fine in the 32-bit int, no?

-- 
Jarod Wilson
jarod@redhat.com

