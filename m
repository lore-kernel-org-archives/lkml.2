Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1KIRlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:41:44 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:62703 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751219Ab1KIRln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:41:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAK+6uk4Y9geI/2dsb2JhbAAMHBqEfageAQEBAQMjVQEQCw4KAgIFFgsCAgkDAgECAUUGDQEFAgEBiAYjpS2SPoEwhzmBFgSIDJ4pTg
X-IronPort-AV: E=Sophos;i="4.69,484,1315195200"; 
   d="scan'208";a="147187934"
Message-ID: <4EBABB56.2060503@teksavvy.com>
Date: Wed, 09 Nov 2011 12:41:42 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH v2] drivers/net/usb/asix:  resync from vendor's copy
References: <4EA89972.5060101@teksavvy.com> <20111026.194045.2019668159403582571.davem@davemloft.net> <4EA8B283.3010105@teksavvy.com> <20111026.221719.2216112919297458522.davem@davemloft.net> <4EB19BBE.5050602@teksavvy.com> <4EBAB8F5.1010101@teksavvy.com>
In-Reply-To: <4EBAB8F5.1010101@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-09 12:31 PM, Mark Lord wrote:
> Second pass (for review) at updating the in-kernel asix usb/network driver
> from the v4.1.0 vendor GPL version of the driver, obtained from here:
> 
>   http://www.asix.com.tw/download.php?sub=searchresult&PItemID=84&download=driver
> 
> The original vendor copy used a local "axusbnet" middleware (rather than "usbnet").
> I've converted it back to using "usbnet", made a ton of cosmetic changes
> to get it to pass checkpatch.pl, and removed a small amount of code duplication.
> 
> The tx/rx checksum code has been updated per Ben's comments,
> and the duplicated MII_* definitions have been removed.
> I've changed the version string to be "4.1.0-kernel",
> to reflect the vendor's code version while also distinguishing
> this port from the original vendor code.
> 
> It can use more work going forward, but it is important to get it upstream
> sooner than later -- the current in-kernel driver fails with many devices,
> both old and new.  This updated version works with everything I have available
> to test with, and also handles suspend / resume (unlike the in-kernel one).
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> ---
> Note that the vendor now has a v4.2.0 version available,
> but for now I'm concentrating on the original v4.1.0 code.
> 
> After review/discussion of this patch, I will update for Linux-3.2-rc
> and resubmit for inclusion in the eventual linux-3.3 kernel.
> 
> Patch included below, and also attached to bypass mailer mangling.

..
> +#define AX_RX_CHECKSUM		(1 << 0)
> +#define AX_TX_CHECKSUM		(1 << 1)
..

Please consider those two lines (from asix.h) to be "nuked" from the next version.
