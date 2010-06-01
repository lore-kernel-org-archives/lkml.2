Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab0FABhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 21:37:40 -0400
Received: from ozlabs.org ([203.10.76.45]:56710 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab0FABhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 21:37:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] Make the module 'usage' lists be two-way
Date: Tue, 1 Jun 2010 11:07:34 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1005311311490.3637@i5.linux-foundation.org> <alpine.LFD.2.00.1005311315460.3637@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005311315460.3637@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006011107.35722.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 05:46:23 am Linus Torvalds wrote:
> 
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 31 May 2010 12:19:37 -0700
> Subject: [PATCH 1/2] Make the module 'usage' lists be two-way
> 
> When adding a module that depends on another one, we used to create a
> one-way list of "modules_which_use_me", so that module unloading could
> see who needs a module.
> 
> It's actually quite simple to make that list go both ways: so that we
> not only can see "who uses me", but also see a list of modules that are
> "used by me".

Thanks Linus, this is a nice cleanup.  One minor comment:

> +static int add_module_usage(struct module *a, struct module *b)
> +{
> +	int no_warn;
> +	struct module_use *use;

These days I tend to use bool for functions which return 1/0 like this.
(Older functions here I haven't churned, but I like it for new functions).
I've frobbed that and put this in my patch queue.

I'll submit it to Linus in the next merge window :)

Thanks,
Rusty.
