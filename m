Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2F2X0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 19:26:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2F2X0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 19:26:51 -0400
Date: Fri, 29 Jun 2012 16:26:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, proski@gnu.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] lib: printf: append support of '%*p[Mm][FR]'
Message-Id: <20120629162649.f277177f.akpm@linux-foundation.org>
In-Reply-To: <1340986086.6562.36.camel@joe2Laptop>
References: <20110930115306.3bc105cb@mj>
	<1340985513-15655-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1340986086.6562.36.camel@joe2Laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2012 09:08:06 -0700
Joe Perches <joe@perches.com> wrote:

> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
> > @@ -655,11 +655,12 @@ char *resource_string(char *buf, char *end, struct resource *res,
> >  }
> >  
> >  static noinline_for_stack
> > -char *mac_address_string(char *buf, char *end, u8 *addr,
> > -			 struct printf_spec spec, const char *fmt)
> > +char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
> > +		 const char *fmt)
> >  {
> > -	char mac_addr[sizeof("xx:xx:xx:xx:xx:xx")];
> > -	char *p = mac_addr;
> > +	char hex_str[64*3];	/* support up to 64 bytes to print */
> 
> Might be too much stack though.

Yes, it's a bit marginal, as this new capability might be used in debug
or crash situations where we're deep into the stack.  The average case
could be improved by using alloca()-style allocation.

Documentation/printk-formats.txt would need to be updated please.  Also
the big comment over vsnprintf().
