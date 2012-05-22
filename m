Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab2EVOLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:11:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45983 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755444Ab2EVOLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:11:42 -0400
Date: Tue, 22 May 2012 10:11:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Greg KH <gregkh@linuxfoundation.org>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Subject: =?UTF-8?Q?Re=3A_Race_condition_between_driver=5Fprobe=5Fdevice_and_d?=
 =?UTF-8?Q?evice=5Fshutdown=E2=80=8F?=
In-Reply-To: <CACVXFVMCaYPWMiWeKa7tz=Xmi4PLez-3=1rnVPODYvSXBG4Y2Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1205221008530.2100-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Ming Lei wrote:

> On Tue, May 22, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Mon, 21 May 2012, Ming Lei wrote:
> >> Another candidate fix is to register a reboot notifier in driver core to prevent
> >> driver from being bound or unbound from start of reboot/shutdown, but looks
> >> not easy as the way of holding device locks.
> >
> > I'd guess it was done this way so that the shutdown task wouldn't have
> > to wait for a buggy driver that didn't want to release the device lock
> > (or that crashed while holding the lock).
> 
> Maybe, so I understand you agree on adding the device lock as did
> in the patch, don't I?

I don't know.  It depends on the intention behind the shutdown 
callback.  Maybe each driver is supposed to be responsible for doing 
its own locking.

Do you think that a buggy driver should be able to prevent the system 
from shutting down?

> Also we can add below line before acquiring device lock to help
> toubleshoot buggy driver.
> 
>                dev_dbg(dev, "acquiring device lock for shutdown\n");
> 
> >
> > It's not clear that the reboot notifier approach would work.  What
> > about probes that had already started when notifier was called?
> 
> Looks holding device lock is still needed in the notifier callback for
> handling the case if reboot notifier approach is taken.
> 
> IMO, the way of holding device lock is better than reboot notifier approach.

Yes, it is better.  The question is, is it right?

Alan Stern

