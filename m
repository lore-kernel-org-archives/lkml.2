Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab2K1OKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:10:06 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61655 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab2K1OKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:10:04 -0500
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joel Becker'" <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Michal Nazarewicz'" <mina86@mina86.com>
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
 <50B39921.6090308@linutronix.de>
 <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com>
 <50B4E364.8030704@linutronix.de>
 <002901cdcd3f$e7288ac0$b579a040$%p@samsung.com>
 <50B5CD8C.9060902@linutronix.de>
In-reply-to: <50B5CD8C.9060902@linutronix.de>
Subject: RE: [RFC][PATCH] fs: configfs: programmatically create config groups
Date: Wed, 28 Nov 2012 15:09:54 +0100
Message-id: <001201cdcd72$0c424d50$24c6e7f0$%p@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3NQ8oNqlaOJU5lRyahj04VuKZdlAAKmnkw
Content-language: pl
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 28, 2012 9:39 AM Sebastian Andrzej Siewior wrote:

<snip>

> >
> > so that we can create the endpoint directories.
> > And now what? What names shall the user use for the endpoint
> > directories? Oh, that's simple: just see what the endpoint
> > directories' names are. But wait, aren't we just creating them?
> >
> > Please also see Micha³'s point about user interface.
> 
> Yeah I did. Now I'm okay with creating new directories but we should keep
> this to a minimum and encode as much information possible in directory's
> name.
> 

I think I've identified one more case where programmatic creation/removal
of configfs directories is required. There is a general agreement that
binding/unbinding the gadgets will be achieved with using symlinks between
configfs representations of udcs and gadgets. So we need to represent
udcs in configfs. Suppose that the udc driver for user's platform
is modular, e.g. s3c-hsotg.ko. Now, after:

$ modprobe s3c-hsotg

I would _very_ much like the s3c-hsotg or something similar to appear
_automatically_ under $CONFIGFS_ROOT/udcs, e.g.:

$ ls $CONFIGFS_ROOT/udcs

s3c-hsotg

If there can be more instances than 1, then probably I would want

s3c-hsotg.0 	s3c-hsotg.1 ....

or something like that.

It would be _very_ frustrating for the user to have to guess
what name to use _if_ the relevant directory were to be
created manually with mkdir. Conversely, what would

$ rmdir s3c-hsotg

mean? Should it cause the s3c-hsotg.ko to unload?

All the above problems are elegantly solved with programmatic
creation and removal of configfs directories: in the udcs
config_group there is no make_item nor make_group, so mkdir
is not allowed, but instead the directories appear and
disappear as udcs come and go.

Andrzej


