Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523Ab2JaUsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:48:03 -0400
Received: from void.printf.net ([89.145.121.20]:38480 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759678Ab2JaUsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:48:01 -0400
From: Chris Ball <cjb@laptop.org>
To: Trey Ramsay <tramsay@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Rich Rattanni <rattanni@gmail.com>,
        Radovan Lekanovic <lekanovic@gmail.com>
Subject: Re: drivers/mmc/card/block.c infinite loop in mmc_blk_err_check waiting on R1_READY_FOR_DATA
References: <50917DB7.6040503@linux.vnet.ibm.com>
Date: Wed, 31 Oct 2012 16:47:52 -0400
In-Reply-To: <50917DB7.6040503@linux.vnet.ibm.com> (Trey Ramsay's message of
	"Wed, 31 Oct 2012 14:36:23 -0500")
Message-ID: <87k3u6id1j.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 31 2012, Trey Ramsay wrote:
> In the 3.7-rc3 kernel, there is an infinite loop in the
> mmc_blk_err_check() function in drivers/mmc/card/block.c that can be
> caused bad hardware. This loop has moved around a little, but appears
> to have been around in the kernel since v2.6.12.  The code will loop
> forever on write if the card isn't ready for data or if it's in
> program mode.  I did some searching and saw that it was reported to
> linux-mmc@vger.kernel.org
> http://permalink.gmane.org/gmane.linux.kernel.mmc/2021 back in May but
> didn't see a response.  Should there be a maximum retry count or a
> timeout to prevent an infinite loop?

Yes, a (long) timeout is a good idea, and there are three different
places where we use this type of loop waiting for R1_STATE_PRG to drop.
I'll add this to my TODO list, but feel free to fix it if you want to.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
