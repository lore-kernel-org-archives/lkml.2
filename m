Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab0KXTN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:13:58 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:55551 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab0KXTN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:13:57 -0500
Date: Wed, 24 Nov 2010 11:13:43 -0800
From: Andres Salomon <dilinger@queued.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2010-11-23-16-12 uploaded (olpc)
Message-ID: <20101124111343.70019b5c@debxo>
In-Reply-To: <20101124105126.8248fc1f.randy.dunlap@oracle.com>
References: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
	<20101124105126.8248fc1f.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010 10:51:26 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Tue, 23 Nov 2010 16:13:06 -0800 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2010-11-23-16-12 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git=
> 
> 
> make[4]: *** No rule to make target
> `arch/x86/platform/olpc/olpc-xo1-wakeup.c', needed by
> `arch/x86/platform/olpc/olpc-xo1-wakeup.o'.
> 
> 
> It's olpc-xo1-wakeup.S, so I guess it needs a special makefile rule ??
> 

I had trouble with this as well (and after flailing at it a bit, ended
up just dropping the olpc pm stuff from my tree for now).  The build
failure is definitely config-specific.  I suspected that it needs
something like the following, but failed to figure it out:

foo-y := olpc-xo1-wakeup.o
obj-$(CONFIG_OLPC_XO1) += olpc-xo1.o foo.o


