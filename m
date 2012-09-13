Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab2IMQlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:41:07 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60372 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236Ab2IMQlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:41:04 -0400
Date: Thu, 13 Sep 2012 20:41:00 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120913164100.GN19956@moon>
References: <20120913095623.GB28508@moon>
 <20120913135131.5b251797@pyramind.ukuu.org.uk>
 <20120913125401.GK19956@moon>
 <20120913172507.5039e3c6@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913172507.5039e3c6@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 05:25:07PM +0100, Alan Cox wrote:
> On Thu, 13 Sep 2012 16:54:01 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > On Thu, Sep 13, 2012 at 01:51:31PM +0100, Alan Cox wrote:
> > > > +static int pty_get_lock(struct tty_struct *tty, int __user *arg)
> > > > +{
> > > > +	int locked = test_bit(TTY_PTY_LOCK, &tty->flags);
> > > > +	if (put_user(locked, arg))
> > > > +		return -EFAULT;
> > > 
> > > Now explain exactly how this doesn't race with another thread chanigng
> > > the lock setting ?
> > 
> > It's the same as to set/clear this bit, isn't it? Please correct me
> > if I'm wrong.
> 
> So by the time you've finished the test bit and returned it to user space
> the answer may have changed?

Yes. Btw, as far as I see the same applies to lock bit on its own. One
process may lock it while another process may unlock it right after that.

> > > The other comment I have is that it might be better put these in now
> > > there are sysfs patches for the tty layer bouncing about to provide the
> > > needed infrastructure ?
> > 
> > Alan, could you please point me where these patches are living, so I would
> > take a look and check them out
> 
> linux-serial or check tty-next as I think Greg has now merged the test
> patch.

Ah, thanks a lot, Alan, I'll take a look! 

	Cyrill
