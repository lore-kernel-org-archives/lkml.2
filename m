Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab2CONrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 09:47:42 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41719 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753526Ab2CONrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 09:47:40 -0400
Date: Thu, 15 Mar 2012 14:47:35 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: "David S. Miller" <davem@davemloft.net>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        David Herrmann <dh.herrmann@googlemail.com>,
        Greg KH <gregkh@linuxfoundation.org>, Johan Hovold <jhovold@gmail.com>
Subject: bluetooth: bug fixes for bluetooth-next
Message-ID: <20120315134735.GA19821@localhost>
References: <1331307806-21761-1-git-send-email-jhovold@gmail.com>
 <20120314112543.GA5136@localhost>
 <1331749014.14217.112.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331749014.14217.112.camel@aeonflux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:16:54AM -0700, Marcel Holtmann wrote:
> > > This is a revised series which also contains a minimal fix to the memory leak
> > > discovered by David Hermann upon which the first NULL-pointer-dereference fix
> > > also depends.
> > > 
> > > These patches need to get to Linus ASAP as the problems are present in 3.3-rc6
> > > as well as earlier kernels and thus should be backported to the stable trees as
> > > well.
> > 
> > Any chance to get these into 3.3? Otherwise, is it possible to rebase
> > bluetooth-next on top of these so that Greg can get them into 3.3.1 (and
> > the other stable trees) once bluetooth-next is merged?
> > 
> > All three bugs can be used to crash any kernel with HCI-UART support and
> > can probably be used for exploits as they are extremely easy to trigger
> > reliably.
> 
> only if you have access to the TTY device node in the first place. If
> you do not have access to that device node, you can not crash the
> kernel.
> 
> Can you resend a clean set of patches for bluetooth-next and once we
> have that merged, we can talk on how to backport this to 3.3 and also
> -stable.

I'll respond to this mail with the two NULL-deref fixes against
bluetooth-next of today (44e612b3e6566f0b).

As I've mentioned before, a fix for the memory leak is already in
bluetooth-next and my first patch depends on it. Unfortunately, the
memory-leak fix in bluetooth-next is not a minimal fix but a more
invasive one:

	797fe796c4335b3 ("Bluetooth: uart-ldisc: Fix memory leak and
			  remove destruct cb")
	
and it also depends on a second commit (from bluetooth-next):

	010666a126fce7b ("Bluetooth: Make hci-destruct callback
			  optional")

Neither is marked for stable (and at least the latter probably shouldn't
be).

Please make sure that the memory leak fix also gets backported to
stable. A minimal (2-line) fix can be found here:

	http://marc.info/?l=linux-bluetooth&m=133130797428708&w=2

Thanks,
Johan
