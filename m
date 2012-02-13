Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2BMJMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:12:37 -0500
Received: from 184-106-247-128.static.cloud-ips.com ([184.106.247.128]:34463
	"EHLO cloud01.chad-versace.us" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755290Ab2BMJMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:12:35 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Feb 2012 04:12:34 EST
X-Spam-Flag: NO
X-Spam-Score: -2.9
Date: Mon, 13 Feb 2012 10:04:41 +0100
From: Ben Widawsky <ben@bwidawsk.net>
To: Yufeng Shen <miletus@chromium.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: Re: [PATCH] [PATCH] drm/i915: Fix race condition in accessing GMBUS
Message-ID: <20120213090440.GA11414@seagal.ffwll.local>
Mail-Followup-To: Yufeng Shen <miletus@chromium.org>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Eugeni Dodonov <eugeni.dodonov@intel.com>
References: <1328825697-23685-1-git-send-email-miletus@chromium.org>
 <1328896201-20909-1-git-send-email-miletus@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328896201-20909-1-git-send-email-miletus@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 12:50:01PM -0500, Yufeng Shen wrote:
> GMBUS has several ports and each has it's own corresponding
> I2C adpater. When multiple I2C adapters call gmbus_xfer() at
> the same time there is a race condition in using the underlying
> GMBUS controller. Fixing this by adding a mutex lock when calling
> gmbus_xfer().
> 
> Signed-off-by: Yufeng Shen <miletus@chromium.org>

I do not see the race. All the i2c transfers should be protected
correctly by the i2c core, or else I think we haven't registered our
device properly. Could you give an example of when/how this can happen?

Ben
