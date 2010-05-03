Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab0ECREy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 13:04:54 -0400
Received: from kroah.org ([198.145.64.141]:44175 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab0ECREw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 13:04:52 -0400
Date: Mon, 3 May 2010 10:04:49 -0700
From: Greg KH <greg@kroah.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Ming Lei <tom.leiming@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3] firmware_class: fix memory leak - free allocated
 pages
Message-ID: <20100503170449.GA31336@kroah.com>
References: <1272788481-23066-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272788481-23066-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 02, 2010 at 11:21:21AM +0300, Tomas Winkler wrote:
> From: David Woodhouse <David.Woodhouse@intel.com>
> 
> fix memory leak introduced by the patch 6e03a201bbe:
> firmware: speed up request_firmware()
> 
> 1. vfree won't release pages there were allocated explicitly and mapped
> using vmap. The memory has to be vunmap-ed and the pages needs
> to be freed explicitly
> 
> 2. page array is moved into the 'struct
> firmware' so that we can free it from release_firmware()
> and not only in fw_dev_release()
> 
> The fix doesn't break the firmware load speed.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Ming Lei <tom.leiming@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Singed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> V2: fix authorship of the patch
> V3: fix const struct firmware breakage

Thanks, this looks much better, I've applied it now.

greg k-h
