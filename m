Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab1B1QkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:40:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:25096 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab1B1QkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:40:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,240,1297065600"; 
   d="scan'208";a="662202564"
Date: Mon, 28 Feb 2011 17:40:14 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/29] mfd-core: add platform_device sharing support
 for mfd (v2)
Message-ID: <20110228164013.GC5263@sortiz-mobl>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
 <1297998456-7615-29-git-send-email-dilinger@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297998456-7615-29-git-send-email-dilinger@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Thu, Feb 17, 2011 at 07:07:35PM -0800, Andres Salomon wrote:
> This adds functions to enable platform_device sharing for mfd clients.
> 
> Each platform driver (mfd client) that wants to share an mfd_cell's
> platform_device uses the mfd_shared_platform_driver_{un,}register()
> functions instead of platform_driver_{un,}register().  Along with
> registering the platform driver, these also register a new platform
> device with the same characteristics as the original cell, but a different
> name.  Given an mfd_cell with the name "foo", drivers that want to
> share access to its resources can call mfd_shared_platform_driver_register
> with platform drivers named (for example) "bar" and "baz".  This
> will register two platform devices and drivers named "bar" and "baz"
> that share the same cell as the platform device "foo".  The drivers
> can then call "foo" cell's enable hooks (or mfd_shared_cell_enable)
> to enable resources, and obtain platform resources as they normally
> would.
I'm not fine with the naming, as it really is doing more than
registering a platform driver. But since I can not come up with a better name
right now, I would really appreciate if you could add some comments there
explaining what this routine (mfd_shared_platform_driver_register)
does and in which cases it is needed. The OLPC example could also be
mentioned.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
