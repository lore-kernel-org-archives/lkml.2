Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2IWPVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 11:21:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47417 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab2IWPVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 11:21:43 -0400
Date: Sun, 23 Sep 2012 19:21:37 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120923152137.GC2994@moon>
References: <20120913135131.5b251797@pyramind.ukuu.org.uk>
 <20120913125401.GK19956@moon>
 <20120913172507.5039e3c6@pyramind.ukuu.org.uk>
 <20120922180639.GC11610@moon>
 <20120922200731.GD14004@kroah.com>
 <20120922201144.GD11610@moon>
 <20120922215232.GA25778@moon>
 <20120923010953.GA17663@kroah.com>
 <20120923064007.GA2994@moon>
 <34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2012 at 07:46:24AM -0700, H. Peter Anvin wrote:
> >changed right after that operation). Maybe I should put everything to
> >procfs, or stick back with ioctl calls?
> 
> The problem as I see it is that you don't know if your process is
> the lock holder.

Wait, Peter, this lock is set via ioctl call on the fd obtained from
open(ptmx) call, so i fail to see how one can setup such lock without
having fd on the hands. When we do checkpoint the processes we expect
the user passes us the pid of process which is the leader not some
subtree (we can deal with process subtrees too but it is not
encouraged ;)
