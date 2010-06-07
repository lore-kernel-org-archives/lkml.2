Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab0FGSVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:21:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:49536 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab0FGSVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:21:31 -0400
Date: Mon, 7 Jun 2010 11:16:51 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.COM>
Cc: Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support kernel/hotplug sysctl variable when !CONFIG_NET
Message-ID: <20100607181651.GA9999@suse.de>
References: <1275911832-11667-1-git-send-email-abbotti@mev.co.uk>
 <20100607174350.GA7807@suse.de>
 <20100607111145.1b98fdb4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100607111145.1b98fdb4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 11:11:45AM -0700, Randy Dunlap wrote:
> On Mon, 7 Jun 2010 10:43:50 -0700 Greg KH wrote:
> 
> > On Mon, Jun 07, 2010 at 12:57:12PM +0100, Ian Abbott wrote:
> > > From: Ian Abbott <abbotti@mev.co.uk>
> > > 
> > > The kernel/hotplug sysctl variable (/proc/sys/kernel/hotplug file) was
> > > made conditional on CONFIG_NET by commit
> > > f743ca5e10f4145e0b3e6d11b9b46171e16af7ce (applied in 2.6.18) to fix
> > > problems with undefined references in 2.6.16 when CONFIG_HOTPLUG=y &&
> > > !CONFIG_NET, but this restriction is no longer needed.
> 
> Ack, builds for me on x86_64 when CONFIG_NET is not enabled.
> 
> > Why is this restriction no longer needed?  What changed?
> 
> 
> commit cd3772e6898c6386f21d2958346d6dd57d4204f5
> Author: Ming Lei <tom.leiming@gmail.com>
> Date:   Sun Nov 16 18:22:09 2008 +0800
> 
>     kernel/ksysfs.c:fix dependence on CONFIG_NET
>     
>     Access to uevent_seqnum and uevent_helper does not need to
>     depend on CONFIG_NET, so remove it.
>     
>     Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>     Cc: Kay Sievers <kay.sievers@vrfy.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

So something back in 2008 changed which requires a change now?

I'm still confused, what use case calls for the original patch here
being made?  Who wants to modify this option with CONFIG_NET disabled on
their machine?

thanks,

greg k-h
