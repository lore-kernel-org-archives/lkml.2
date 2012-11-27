Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab2K0RYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 12:24:15 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:35865 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752672Ab2K0RYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 12:24:14 -0500
Message-ID: <1354037039.3284.68.camel@thor>
Subject: Re: [PATCH 9/9] TTY: call tty_port_destroy in the rest of drivers
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Date: Tue, 27 Nov 2012 12:23:59 -0500
In-Reply-To: <20121127170407.GC2687@kroah.com>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
	 <1352969396-23760-10-git-send-email-jslaby@suse.cz>
	 <1354035129.3284.54.camel@thor> <20121127170407.GC2687@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 09:04 -0800, Greg Kroah-Hartman wrote:
> On Tue, Nov 27, 2012 at 11:52:09AM -0500, Peter Hurley wrote:
> > On Thu, 2012-11-15 at 09:49 +0100, Jiri Slaby wrote:
> > > After commit "TTY: move tty buffers to tty_port", the tty buffers are
> > > not freed in some drivers. This is because tty_port_destructor is not
> > > called whenever a tty_port is freed. This was an assumption I counted
> > > with but was unfortunately untrue. So fix the drivers to fulfil this
> > > assumption.
> > > 
> > > To be sure, the TTY buffers (and later some stuff) are gone along with
> > > the tty_port, we have to call tty_port_destroy at tear-down places.
> > > This is mostly where the structure containing a tty_port is freed.
> > > This patch does exactly that -- put tty_port_destroy at those places.
> > > 
> > > Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> > 
> > Hi Jiri & Greg & Alan,
> > 
> > I'd be more than willing to fixup staging/fwserial against this series
> > but I'm unclear on the mechanics since this series isn't in staging-next
> > and staging/fwserial isn't in tty-next.
> 
> The series is in tty-next, right?

Yes.

> Make it against linux-next, which has
> the trees combined, and I'll work to figure it out when/where to apply
> it.

Ok, will do.

Thanks,
Peter


