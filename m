Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab1CXPwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:52:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45752 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754634Ab1CXPwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:52:37 -0400
Date: Thu, 24 Mar 2011 11:52:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Chris Wright <chrisw@sous-sol.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH] usb: core: Change usb_create_sysfs_intf_files()' return
 type to void
In-Reply-To: <7269aca0469928347bbff55c8c2efd1c86cf1f4b.1300979212.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1103241150210.2006-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Michal Nazarewicz wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> The usb_create_sysfs_intf_files() function always returned zero even
> if it failed to create sysfs fails.  Since this is a desired behaviour
> there is no need to return return code at all.  This commit changes
> function's return type (form int) to void.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> ---
>  drivers/usb/core/sysfs.c |    7 +++----
>  drivers/usb/core/usb.c   |    3 +--
>  drivers/usb/core/usb.h   |    2 +-
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
> The below patch has not been tested (not even compiled), just a quick scatch.

If you had compiled it, you would have seen why it's not a good idea to 
remove retval.  :-)

On the other hand, changing the function's return type to void is okay.  
I think the reason it returns int is historical; there used to be a
failure mode but it got removed.

Alan Stern

