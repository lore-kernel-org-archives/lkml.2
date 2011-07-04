Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab1GDP4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 11:56:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:48199 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756902Ab1GDP4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 11:56:45 -0400
Date: Mon, 4 Jul 2011 11:56:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend to ram
In-Reply-To: <201107041054.36890.a.miskiewicz@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1107041155080.12242-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jul 2011, Arkadiusz Miskiewicz wrote:

> On Thursday 30 of June 2011, Alan Stern wrote:
> 
> > And now you know why, more or less -- we still have to figure out the
> > reason for the hang.  Probably something goes wrong when cdc-ether is
> > unbound from the wireless device.
> 
> Reverting patch below fixes hang.
> 
> commit fccf4e86200b8f5edd9a65da26f150e32ba79808
> Author: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Date:   Sun Jun 5 23:22:22 2011 -0700
> 
>     USB: Free bandwidth when usb_disable_device is called.

Ah, very good!  That explains everything.  Someone else reported a 
similar problem that was tracked down to this commit, and I submitted a 
fix a few days ago:

	http://marc.info/?l=linux-usb&m=130955300211987&w=2

I bet this will fix your problem too.

Alan Stern

