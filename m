Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab0DWK54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:57:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40126 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752609Ab0DWK5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:57:54 -0400
Date: Fri, 23 Apr 2010 11:57:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: platform_bus: Allow runtime PM by default
Message-ID: <20100423105750.GA27232@rakim.wolfsonmicro.main>
References: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100422235353.GA16310@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100422235353.GA16310@kroah.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 04:53:53PM -0700, Greg KH wrote:
> On Fri, Mar 26, 2010 at 05:42:50PM +0000, Mark Brown wrote:

> > Change the default implementation to the standard pm_generic_runtime
> > one, allowing drivers to use runtime PM without per-architecture
> > changes.

> That's nice, but it breaks the build on my system:
>   CC      drivers/base/platform.o
> drivers/base/platform.c: In function ‘platform_pm_runtime_suspend’:
> drivers/base/platform.c:970: error: implicit declaration of function ‘pm_generic_runtime_suspend’
> drivers/base/platform.c: In function ‘platform_pm_runtime_resume’:
> drivers/base/platform.c:975: error: implicit declaration of function ‘pm_generic_runtime_resume’
> drivers/base/platform.c: In function ‘platform_pm_runtime_idle’:
> drivers/base/platform.c:980: error: implicit declaration of function ‘pm_generic_runtime_idle’
> make[1]: *** [drivers/base/platform.o] Error 1
> make: *** [_module_drivers/base] Error 2

> Care to fix it up?

This depends on "PM: Provide generic subsystem-level callbacks" which is
in Linus' tree - which kernel version are you building against and with
what config?  Things work fine for me in -next...
