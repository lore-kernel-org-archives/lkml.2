Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab2EJOLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:11:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50197 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab2EJOLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:11:34 -0400
Date: Thu, 10 May 2012 07:11:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] Driver Core: don't oops with unregistered driver in
 driver_find_device()
Message-ID: <20120510141130.GA20373@kroah.com>
References: <1336635302-29260-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336635302-29260-1-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:35:02AM +0300, Hiroshi DOYU wrote:
> driver_find_device() can be called with an unregistered driver.

Who does that?  Where in the kernel?  Why would you try to do that?

> Need to check driver_private to see if it's populated or not,
> especially under deferrable probe.

Hm, I don't know if this will really catch a driver that was registered
and then was unregistered, right?  It seems like moving the real problem
somewhere else, why not fix the original issue instead?

> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> ---
> In [PATCHv5 2/3] ARM: tegra: Add SMMU enabler in AHB:
>   http://article.gmane.org/gmane.linux.ports.tegra/4658
> 
> "tegra_ahb_driver" may not be populated when it's called.

It can?  I don't see that in that patch.

confused,

greg k-h
