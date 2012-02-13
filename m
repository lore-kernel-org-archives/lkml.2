Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab2BMLiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 06:38:19 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52167 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2BMLiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 06:38:10 -0500
Date: Mon, 13 Feb 2012 06:37:54 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Divy Le Ray <divy@chelsio.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: pull request: linux-firmware: update cxgb* firmwares
Message-ID: <20120213113754.GA28238@hmsreliant.think-freely.org>
References: <4F35DB79.6070104@chelsio.com>
 <20120211140701.GA5194@neilslaptop.think-freely.org>
 <4F38A526.70900@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F38A526.70900@chelsio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 09:52:38PM -0800, Divy Le Ray wrote:
> On 2/11/2012 6:07 AM, Neil Horman wrote:
> >On Fri, Feb 10, 2012 at 07:07:37PM -0800, Divy Le Ray wrote:
> >>Hi David,
> >>
> >>Can you please pull from the following URL?
> >>      git://git.chelsio.net/pub/git/linux-firmware.git for-david
> >>
> >>It contains the following commits:
> >>03cadf2 linux-firmware: update cxgb3 driver firmware to revision 7.12.0
> >>235dfaf linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 driver.
> >>e2ea873 linux-firmware: remove current t4fw.bin
> >>
> >>The following changes since commit 15888a2eab052ac3d3f49334e4f6f05f347a516e:
> >>
> >>   bnx2x: Adding FW 7.0.29.0 (2011-10-24 16:31:44 +0200)
> >>
> >>are available in the git repository at:
> >>   git://git.chelsio.net/pub/git/linux-firmware.git for-david
> >>
> >>Divy Le Ray (3):
> >>       linux-firmware: remove current t4fw.bin
> >>       linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 driver.
> >>       linux-firmware: update cxgb3 driver firmware to revision 7.12.0
> >>
> >>  WHENCE                  |    3 ++-
> >>  cxgb3/t3fw-7.12.0.bin   |  Bin 0 ->   31812 bytes
> >>  cxgb4/t4fw-1.4.16.0.bin |  Bin 0 ->   298496 bytes
> >>  cxgb4/t4fw.bin          |  Bin 241664 ->   0 bytes
> >>  4 files changed, 2 insertions(+), 1 deletions(-)
> >>  create mode 100755 cxgb3/t3fw-7.12.0.bin
> >>  create mode 100644 cxgb4/t4fw-1.4.16.0.bin
> >>  delete mode 100644 cxgb4/t4fw.bin
> >>
> >Deleting the old firmware is a bad idea.  You've haven't modified the driver in
> >net or net-next to use the new firmware, and until you do, kernels won't be able
> >to find the firmware the driver is requesting.  You should make firmware changes
> >addative.  Add new versions of firmware, but keep the old ones (at least for a
> >while).  Thank you for moving cxgb4 to a versioned firmware file though.  I
> >presume there is a pending update to change the FW_FNAME definition to pending?
> 
> Hi Neil,
> 
> Thank you for the review. I have updated the patch series with the
> following changes:
> - Rename the existing t4fw.bin file as t4fw-1.3.10.0.bin
> - Add t4fw.bin as a symlink to the latest t4fw revision.
> 
Thank you, that helps. 

> The driver looks up "t4fw.bin", the symlink allows updates of the FW
> without actually modifying the driver source.
> Also, if the firmware revision under /lib/firmware/cxgb4/t4fw.bin is
> more recent than the adapter's embedded FW,
> the driver will update it. The FW revisions are forward compatible.
> 
Thats fine, I presume then we can expect a commit to the cxgb3 driver shortly,
updatnig the FW_VERSION_MINOR macro?

Acked-by: Neil Horman <nhorman@tuxdriver.com>


