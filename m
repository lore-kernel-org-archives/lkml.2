Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2LLBKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 20:10:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40005 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2LLBKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 20:10:33 -0500
Date: Tue, 11 Dec 2012 17:10:23 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        "'Michal Nazarewicz'" <mina86@mina86.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config
 groups
Message-ID: <20121212011022.GS22789@localhost>
Mail-Followup-To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	'Sebastian Andrzej Siewior' <bigeasy@linutronix.de>,
	'Michal Nazarewicz' <mina86@mina86.com>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <50B39921.6090308@linutronix.de>
 <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com>
 <50B4E364.8030704@linutronix.de>
 <xa1tip8ruia5.fsf@mina86.com>
 <50B5C821.4000406@linutronix.de>
 <xa1ta9u1naik.fsf@mina86.com>
 <50B61695.50207@linutronix.de>
 <20121207231828.GM22789@localhost>
 <001401cdd6cd$788defa0$69a9cee0$%p@samsung.com>
 <000001cdd6e1$1ac24f60$5046ee20$%p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cdd6e1$1ac24f60$5046ee20$%p@samsung.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 03:17:34PM +0100, Andrzej Pietrasiewicz wrote:
> @Joel in particular: please see my comment in the bottom.

<snip>

> I forgot to mention, representing udcs (USB Device Controllers) in
> configfs is similar to interfaces/endpoints: the user needs to guess
> what name to use in mkdir, e.g. in:
> 
> $ mkdir ....../udcs/s3c-hsotg

	Again, discoverability.  Userspace should not need to guess.  So
some part of the system (configfs, sysfs, procfs, $dontcare) needs to
know what the available choices are.

> the poor user needs to know that the udc is actually called s3c-hsotg.
> And after the udc goes away from the system, the s3c-hsotg directory
> remains in the filesystem until the user deletes it (as nobody else
> but the user can do it). Again, an attribute like available_udcs in
> the udcs directory can help. But still, there will be times when
> its contents will not be consistent with the directories actually
> present.

	How does the system know there is an s3c-hsotg?  Is this from
scanning?

> @Joel: Any thoughts about it? Commitable items? E.g. the user creates
> whatever they want, so the "uncommitted" directory contains "garbage",
> that is directories which do not have to correspond to anything
> actually present in the system, but on commiting the gadget's item
> (group in fact) everything is verified and only "correct" gadgets
> are actually bound? Then, in the "uncommitted" directory the user
> can still do whatever they want, but this is not effective until
> uncommitting the old gadget and committing it again? There is just
> a tiny issue with committable items: Are they implemented? :O

	Committable items are not implemented, because everyone uses the
'enable' pattern:

  $ mkdir foo
  $ echo 1024 >foo/attr1
  $ echo 2048 >foo/attr2
  $ echo 1 >foo/enable

In o2hb, we don't have an explicit "enable" attribute.  Instead, we
enable when the block device's file descriptor is stored.  If the other
attributes aren't set yet, we fail the store.

Joel

-- 

Life's Little Instruction Book #451

	"Don't be afraid to say, 'I'm sorry.'"

			http://www.jlbec.org/
			jlbec@evilplan.org
