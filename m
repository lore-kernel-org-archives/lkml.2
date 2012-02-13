Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab2BMFxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:53:12 -0500
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:42336
	"EHLO l.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2BMFxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:53:10 -0500
Message-ID: <4F38A526.70900@chelsio.com>
Date: Sun, 12 Feb 2012 21:52:38 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: pull request: linux-firmware: update cxgb* firmwares
References: <4F35DB79.6070104@chelsio.com> <20120211140701.GA5194@neilslaptop.think-freely.org>
In-Reply-To: <20120211140701.GA5194@neilslaptop.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/2012 6:07 AM, Neil Horman wrote:
> On Fri, Feb 10, 2012 at 07:07:37PM -0800, Divy Le Ray wrote:
>> Hi David,
>>
>> Can you please pull from the following URL?
>>       git://git.chelsio.net/pub/git/linux-firmware.git for-david
>>
>> It contains the following commits:
>> 03cadf2 linux-firmware: update cxgb3 driver firmware to revision 7.12.0
>> 235dfaf linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 driver.
>> e2ea873 linux-firmware: remove current t4fw.bin
>>
>> The following changes since commit 15888a2eab052ac3d3f49334e4f6f05f347a516e:
>>
>>    bnx2x: Adding FW 7.0.29.0 (2011-10-24 16:31:44 +0200)
>>
>> are available in the git repository at:
>>    git://git.chelsio.net/pub/git/linux-firmware.git for-david
>>
>> Divy Le Ray (3):
>>        linux-firmware: remove current t4fw.bin
>>        linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 driver.
>>        linux-firmware: update cxgb3 driver firmware to revision 7.12.0
>>
>>   WHENCE                  |    3 ++-
>>   cxgb3/t3fw-7.12.0.bin   |  Bin 0 ->   31812 bytes
>>   cxgb4/t4fw-1.4.16.0.bin |  Bin 0 ->   298496 bytes
>>   cxgb4/t4fw.bin          |  Bin 241664 ->   0 bytes
>>   4 files changed, 2 insertions(+), 1 deletions(-)
>>   create mode 100755 cxgb3/t3fw-7.12.0.bin
>>   create mode 100644 cxgb4/t4fw-1.4.16.0.bin
>>   delete mode 100644 cxgb4/t4fw.bin
>>
> Deleting the old firmware is a bad idea.  You've haven't modified the driver in
> net or net-next to use the new firmware, and until you do, kernels won't be able
> to find the firmware the driver is requesting.  You should make firmware changes
> addative.  Add new versions of firmware, but keep the old ones (at least for a
> while).  Thank you for moving cxgb4 to a versioned firmware file though.  I
> presume there is a pending update to change the FW_FNAME definition to pending?

Hi Neil,

Thank you for the review. I have updated the patch series with the 
following changes:
- Rename the existing t4fw.bin file as t4fw-1.3.10.0.bin
- Add t4fw.bin as a symlink to the latest t4fw revision.

The driver looks up "t4fw.bin", the symlink allows updates of the FW 
without actually modifying the driver source.
Also, if the firmware revision under /lib/firmware/cxgb4/t4fw.bin is 
more recent than the adapter's embedded FW,
the driver will update it. The FW revisions are forward compatible.

The following changes since commit 15888a2eab052ac3d3f49334e4f6f05f347a516e:

   bnx2x: Adding FW 7.0.29.0 (2011-10-24 16:31:44 +0200)

are available in the git repository at:
   git://git.chelsio.net/pub/git/linux-firmware.git for-david

Divy Le Ray (3):
       linux-firmware: rename t4fw.bin
       linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 driver.
       linux-firmware: update cxgb3 driver firmware to revision 7.12.0

  WHENCE                  |    4 +++-
  cxgb3/t3fw-7.12.0.bin   |  Bin 0 -> 31812 bytes
  cxgb4/t4fw-1.3.10.0.bin |  Bin 0 -> 241664 bytes
  cxgb4/t4fw-1.4.16.0.bin |  Bin 0 -> 298496 bytes
  cxgb4/t4fw.bin          |  Bin 241664 -> 17 bytes
  5 files changed, 3 insertions(+), 1 deletions(-)
  create mode 100755 cxgb3/t3fw-7.12.0.bin
  create mode 100644 cxgb4/t4fw-1.3.10.0.bin
  create mode 100644 cxgb4/t4fw-1.4.16.0.bin
  mode change 100644 => 120000 cxgb4/t4fw.bin

Cheers,
Divy

