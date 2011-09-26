Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1IZXrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 19:47:01 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60457 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858Ab1IZXrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 19:47:00 -0400
X-Sasl-enc: qkUtuQIFbgv7P1hGWZcMqHxUKyEEvG1Gf/3b3HJfvkHL 1317080818
Date: Mon, 26 Sep 2011 16:45:40 -0700
From: Greg KH <greg@kroah.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] user namespace: usb: make usb urbs user namespace
 aware (v2)
Message-ID: <20110926234540.GA28525@kroah.com>
References: <20110926151829.GA5190@peqn>
 <20110926154518.GA6897@peqn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110926154518.GA6897@peqn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 10:45:18AM -0500, Serge Hallyn wrote:
> Add to the dev_state and alloc_async structures the user namespace
> corresponding to the uid and euid.  Pass these to kill_pid_info_as_uid(),
> which can then implement a proper, user-namespace-aware uid check.
> 
> Changelog:
> Sep 20: Per Oleg's suggestion: Instead of caching and passing user namespace,
> 	uid, and euid each separately, pass a struct cred.
> Sep 26: Address Alan Stern's comments: don't define a struct cred at
> 	usbdev_open(), and take and put a cred at async_completed() to
> 	ensure it lasts for the duration of kill_pid_info_as_cred().
> 
> Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Greg KH <greg@kroah.com>

I have no objection to this, is it going to go through your tree, or
somewhere else?

If so, please add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to it.

greg k-h
