Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab0FBRC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 13:02:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44604 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650Ab0FBRCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 13:02:55 -0400
Date: Wed, 2 Jun 2010 09:53:02 -0700
From: Brandon Philips <brandon@ifup.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of
 module libcrc32c"
Message-ID: <20100602165302.GI10332@jenkins.ifup.org>
References: <201005252300.07739.rjw@sisk.pl>
 <201006021523.00357.rusty@rustcorp.com.au>
 <alpine.LFD.2.00.1006020006420.8175@i5.linux-foundation.org>
 <201006022336.53024.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006022336.53024.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23:36 Wed 02 Jun 2010, Rusty Russell wrote:
> On Wed, 2 Jun 2010 04:51:46 pm Linus Torvalds wrote:
> > On Wed, 2 Jun 2010, Rusty Russell wrote:
> > > 
> > > Moved all the sysfs-exposing stuff to the end just after we put in the
> > > list (and thus to after the find check).
> > 
> > Yeah, makes more sense that way. No reason to expose anything to sysfs 
> > early. And splitting it into two patches makes it easier to follow than 
> > the patch I posted. Ack.
> 
> Found another locking issue: the code which verifies we don't export over
> an existing symbol needs to be atomic wrt. adding us to the list.
> 
...
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6 modules

I tested this on the machine with the bnx2/libcrc32c issue and it
works. Feel free to add Tested-by: Brandon Philips <bphilips@suse.de>

Thanks,

	Brandon
