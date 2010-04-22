Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab0DWAPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 20:15:55 -0400
Received: from kroah.org ([198.145.64.141]:41020 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab0DWAOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 20:14:44 -0400
Date: Thu, 22 Apr 2010 16:53:53 -0700
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: platform_bus: Allow runtime PM by default
Message-ID: <20100422235353.GA16310@kroah.com>
References: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 05:42:50PM +0000, Mark Brown wrote:
> 
> Currently the default runtime PM callbacks for platform devices return
> -ENOSYS, preventing the use of runtime PM platforms until they have
> provided at least a default implementation. This hinders the use of
> runtime PM by devices which work with many platforms such as memory
> mapped devices, MFDs and on chip IPs shared by multiple architectures.
> 
> Change the default implementation to the standard pm_generic_runtime
> one, allowing drivers to use runtime PM without per-architecture
> changes.

That's nice, but it breaks the build on my system:
  CC      drivers/base/platform.o
drivers/base/platform.c: In function ‘platform_pm_runtime_suspend’:
drivers/base/platform.c:970: error: implicit declaration of function ‘pm_generic_runtime_suspend’
drivers/base/platform.c: In function ‘platform_pm_runtime_resume’:
drivers/base/platform.c:975: error: implicit declaration of function ‘pm_generic_runtime_resume’
drivers/base/platform.c: In function ‘platform_pm_runtime_idle’:
drivers/base/platform.c:980: error: implicit declaration of function ‘pm_generic_runtime_idle’
make[1]: *** [drivers/base/platform.o] Error 1
make: *** [_module_drivers/base] Error 2

Care to fix it up?

thanks,

greg k-h
