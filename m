Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0G1N41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 09:56:27 -0400
Received: from kroah.org ([198.145.64.141]:47192 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab0G1N4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 09:56:16 -0400
Date: Wed, 28 Jul 2010 06:56:25 -0700
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb <linux-usb@vger.kernel.org>
Subject: Re: BUG: 'Unknown symbol in module' happens after reloading
	ehci-hcd module
Message-ID: <20100728135625.GA12916@kroah.com>
References: <AANLkTiniwW+r1G40QvA+oja=1YDkykNWRahHL4LuiCAU@mail.gmail.com> <AANLkTi=x0D_5yd7pWmYAcD2eeQN3HC9ecBXWEY-TpyYO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=x0D_5yd7pWmYAcD2eeQN3HC9ecBXWEY-TpyYO@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 03:33:30PM +0800, Ming Lei wrote:
> 2010/7/28 Ming Lei <tom.leiming@gmail.com>:
> > Hi,
> >
> > 'Unknown symbol in module' ?happens after the actions below:
> >
> > ? ? ? ? rmmod ehci-hcd
> > ? ? ? ? modprobe ehci-hcd
> >
> 
> The issue is caused by returning failure of debugfs_create_dir, and
> which may be fixed by replacing debugfs_remove with
> debugfs_remove_recursive in ehci_hcd_cleanup.

Or we can properly clean up all of the files, right?

Care to send a patch to resolve this?

thanks,

greg k-h
