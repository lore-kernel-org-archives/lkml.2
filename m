Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2K0RCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:02:44 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43733 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab2K0RCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:02:43 -0500
Date: Tue, 27 Nov 2012 09:04:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 9/9] TTY: call tty_port_destroy in the rest of drivers
Message-ID: <20121127170407.GC2687@kroah.com>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
 <1352969396-23760-10-git-send-email-jslaby@suse.cz>
 <1354035129.3284.54.camel@thor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354035129.3284.54.camel@thor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 11:52:09AM -0500, Peter Hurley wrote:
> On Thu, 2012-11-15 at 09:49 +0100, Jiri Slaby wrote:
> > After commit "TTY: move tty buffers to tty_port", the tty buffers are
> > not freed in some drivers. This is because tty_port_destructor is not
> > called whenever a tty_port is freed. This was an assumption I counted
> > with but was unfortunately untrue. So fix the drivers to fulfil this
> > assumption.
> > 
> > To be sure, the TTY buffers (and later some stuff) are gone along with
> > the tty_port, we have to call tty_port_destroy at tear-down places.
> > This is mostly where the structure containing a tty_port is freed.
> > This patch does exactly that -- put tty_port_destroy at those places.
> > 
> > Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> 
> Hi Jiri & Greg & Alan,
> 
> I'd be more than willing to fixup staging/fwserial against this series
> but I'm unclear on the mechanics since this series isn't in staging-next
> and staging/fwserial isn't in tty-next.

The series is in tty-next, right?  Make it against linux-next, which has
the trees combined, and I'll work to figure it out when/where to apply
it.

thanks,

greg k-h
