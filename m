Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2I0Osv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:48:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38790 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2I0Ost (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:48:49 -0400
Date: Thu, 27 Sep 2012 18:48:42 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120927144842.GI6618@moon>
References: <20120923010953.GA17663@kroah.com>
 <20120923064007.GA2994@moon>
 <34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com>
 <20120924141441.GD16532@moon>
 <20120927140502.GB12552@moon>
 <20120927151447.2460ce44@pyramind.ukuu.org.uk>
 <20120927141425.GG6618@moon>
 <5064600D.1090506@zytor.com>
 <20120927142149.GH6618@moon>
 <50646620.4090708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50646620.4090708@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 07:43:44AM -0700, H. Peter Anvin wrote:
> >>If you can't guarantee that ALL those processes are stopped and
> >>checkpointed/restarted, you have a huge problem.
> >
> >Well, sure inside our tool before doing checkpoint we stop all
> >tasks which are part of dumpee process tree. This unfortunatly
> >doesn't apply to these ioctl calls. Peter, any idea how to deal
> >with that?
> 
> Sorry, no.  I suspect you might be trying to do something that is
> impossible to do in a general fashion without application changes.

I see. What if I wrap all this entries with CONFIG_CHECKPOINT_RESTORE
and say add some sysctl which would enable/disbale this ioctls. Then
it'll be up to user-space callers to make sure that data received is
valid and can be used? The problem is that I need to fetch this bits
somehow with minimal changes in kernel.
