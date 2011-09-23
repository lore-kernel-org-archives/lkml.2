Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab1IWSfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:35:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34191 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751514Ab1IWSfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:35:10 -0400
Date: Fri, 23 Sep 2011 14:35:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
cc: "Serge E. Hallyn" <serge@hallyn.com>, Greg KH <greg@kroah.com>,
        Oleg Nesterov <oleg@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        <richard@nod.at>, Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH resend] user namespace: usb: make usb urbs user namespace
 aware (v2)
In-Reply-To: <20110923172235.GB4065@sergelap>
Message-ID: <Pine.LNX.4.44L0.1109231431550.2059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011, Serge E. Hallyn wrote:

> > > > This should be broken up into two separate patches: One to add
> > > > kill_pid_info_as_cred() and the other to modify the usbfs driver.
> > > 
> > > It seems like that would make the first patch harder to review (since
> > > it won't just show the changes from kill_pid_info_as_uid to
> > > kill_pid_info_as_cred), but I'll go ahead and split it up.  I assume
> > > kill_pid_info_as_uid should be removed in a third patch?
> > 
> > No, what I meant was that all the changes to /kernel/signal.c should be 
> > in one patch and all the changes to drivers/usb/core/devio.c should be 
> > in a second patch.
> 
> But doing that in two patches would not be bisect-safe.

Argh, you're right.

It's not a good idea to combine changes to widely differing subsystems
in a single patch, but luckily this is small enough that it doesn't
matter too much.  If nobody else minds, I won't complain.

Alan Stern

