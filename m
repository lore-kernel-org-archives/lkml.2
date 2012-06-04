Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2FDStm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:49:42 -0400
Received: from plane.gmane.org ([80.91.229.3]:40591 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab2FDStj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:49:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Improving SD/SDHC/SDXC write performance by using a discard/TRIM
 like operation
Date: Mon, 04 Jun 2012 20:49:22 +0200
Message-ID: <jqivvi$q7m$1@dough.gmane.org>
References: <jqiull$fvb$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: barriere.frankfurter-softwarefabrik.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
In-Reply-To: <jqiull$fvb$1@dough.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just found another credible reference claiming existence of an "erase" command
for SD cards: The "SD Card Specification Simplified Version of: Part E1" (see:
http://www.sandisk.com/Assets/File/OEM/Manuals/SD_SDIO_specsv1.pdf ) states:

> ERASE_WR_BLK_START Sets the address of the first write block to be Index address erased.
> ERASE_WR_BLK_END Sets the address of the last write block of the address continuous range to be erased.

Since these are "SD bus commands", I wonder whether they are easily accessible
behind usual USB card reader hardware... but the mentioned "formatter" tool
seems to be able to do so.

Regards,

Lutz Vieweg


On 06/04/2012 08:27 PM, Lutz Vieweg wrote:
> When I read reports from (non-expert) users who claimed that they were able
> to restore the initial write performance of their SDXC cards by using a "special
> formatter tool" (while normal "formatting" did not improve performance),
> I was very sceptical, as I also had read that there is no way to discard/TRIM
> blocks on SD/SDHC/SDXC cards.
>
> But then I noticed that this "special formatter" tool was actually offered (for free)
> by the SD Association:
> https://www.sdcard.org/downloads/formatter_3/
> ... and its documentation clearly states that this tool is capable of using
> "flash erase" operations on SD cards, which are said to be different from
> ordinary "overwrites", see
> https://www.sdcard.org/downloads/formatter_3/SDFormatter_3.1e.pdf
> pages 7 ("Format type Erase" vs. "Format type Overwrite") and the screen shot on page 9.
>
> Now I wonder: Is there really such a thing as a command to erase NAND flashes
> in SD cards like there is for SSDs? If so, it would certainly be a good thing
> to support it with Linux block discard...
>
> Regards,
>
> Lutz Vieweg
>

