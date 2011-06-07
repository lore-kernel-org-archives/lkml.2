Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab1FGRLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:11:12 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46768 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753086Ab1FGRLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:11:10 -0400
X-Sasl-enc: prsgle8vF5T8bcXEkfkrj/NTE5pRSZMztMWvt68Mgm3W 1307466669
Date: Tue, 7 Jun 2011 10:10:43 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2 2/2] TTY: ntty, add one more sanity check
Message-ID: <20110607171043.GA1200@kroah.com>
References: <BANLkTik5QP7e=+FWSa1kLVpCjZpWEtF1PQ@mail.gmail.com>
 <1307276177-20957-1-git-send-email-jslaby@suse.cz>
 <1307276177-20957-2-git-send-email-jslaby@suse.cz>
 <20110607164423.GA32575@kroah.com>
 <4DEE588E.1050108@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEE588E.1050108@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 06:57:50PM +0200, Jiri Slaby wrote:
> On 06/07/2011 06:44 PM, Greg KH wrote:
> > On Sun, Jun 05, 2011 at 02:16:17PM +0200, Jiri Slaby wrote:
> >> With the previous patch, we fixed another bug where read_buf was freed
> >> while we still was in n_tty_read. We currently check whether read_buf
> >> is NULL at the start of the function. Add one more check after we wake
> >> up from waiting for input.
> >>
> >> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> >> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> >> ---
> >>  drivers/tty/n_tty.c |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> >> index 95d0a9c..c62c856 100644
> >> --- a/drivers/tty/n_tty.c
> >> +++ b/drivers/tty/n_tty.c
> >> @@ -1785,6 +1785,7 @@ do_it_again:
> >>  				break;
> >>  			}
> >>  			timeout = schedule_timeout(timeout);
> >> +			BUG_ON(!tty->read_buf);
> > 
> > So, if we ever hit this, what are we going to do with this crash?
> > 
> > I really don't want to add more BUG_ON() calls to the kernel if at all
> > possible.  Or is it the case that we will crash if this case is true
> > soon afterward anyway?
> 
> Yeah, it will crash something like 10 lines below. The pointer is
> dereferenced there.

Ok, fair enough, thanks.

greg k-h
