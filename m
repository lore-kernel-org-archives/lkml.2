Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab0FAFzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:55:43 -0400
Received: from ozlabs.org ([203.10.76.45]:55216 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab0FAFzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:55:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 1/2] module: make locking more fine-grained.
Date: Tue, 1 Jun 2010 15:25:38 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201005312131.43238.rusty@rustcorp.com.au> <20100601053842.GD5134@cr0.nay.redhat.com>
In-Reply-To: <20100601053842.GD5134@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006011525.39293.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 03:08:42 pm Américo Wang wrote:
> On Mon, May 31, 2010 at 09:31:42PM +0930, Rusty Russell wrote:
> >@@ -783,9 +787,13 @@ SYSCALL_DEFINE2(delete_module, const cha
> > 	/* Store the name of the last unloaded module for diagnostic purposes */
> > 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
> > 	ddebug_remove_module(mod->name);
> >+
> >+	/* free_module doesn't want module_mutex held by caller. */
> >+	mutex_unlock(&module_mutex);
> > 	free_module(mod);
> >-
> >- out:
> >+	goto out_stop;
> 
> As Stephen found in linux-next, this line doesn't pass compiling.
> I think this line should be just deleted.

Yep, I didn't commit my fixes to the backport before pushing & posting;
I've done that now.  You can get the usable one from the git tree:

        git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6 modules

Thanks,
Rusty.
