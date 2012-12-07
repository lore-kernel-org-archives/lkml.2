Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054Ab2LGCvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:51:12 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58682 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965020Ab2LGCvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:51:11 -0500
Message-ID: <1354848669.22463.23.camel@joe-AO722>
Subject: Re: [PATCH v2 00/14] printk() fixes, optimizations, and clean ups
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan =?ISO-8859-1?Q?H=2ESch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 06 Dec 2012 18:51:10 -0800
In-Reply-To: <20121206161943.78633125.akpm@linux-foundation.org>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <20121206133907.37c255e9.akpm@linux-foundation.org>
	 <1354837050.22463.4.camel@joe-AO722>
	 <20121206161943.78633125.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 16:19 -0800, Andrew Morton wrote:
> On Thu, 06 Dec 2012 15:37:30 -0800
> Joe Perches <joe@perches.com> wrote:
> > Can you please pick this up for -next now and I'll
> > redo my patches against -next for -rc1 so I'm not
> > delayed until 3.9?
> 
> It would be better to do things in the other order.
> 
> a) Your patches perform mainly code-movement which doesn't cause
>    functional changes.  Jan's patches are functional changes which
>    require more thought and testing and possible fixups.

Fine by me.  Jan?

Jan's patches also correct garbled output with the relatively
infrequent use of printk with only a newline like printk("\n");

$ git grep -E "\b(printk|pr_cont)\s*\(\s*\"\\\\n\""|wc -l
890

I think that's not too serious a dmesg problem for now.


