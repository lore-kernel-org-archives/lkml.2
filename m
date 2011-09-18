Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1IRPCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 11:02:08 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:34916 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754457Ab1IRPCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 11:02:07 -0400
Message-ID: <4E7607EC.4060208@xenotime.net>
Date: Sun, 18 Sep 2011 08:02:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, driverdevel <devel@driverdev.osuosl.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: [PATCH] staging: fix comedi build when ISA_DMA_API is enabled
 but COMEDI_PCI is not enabled
References: <4E68E7F9.4020906@xenotime.net> <20110912145320.GA28855@kroah.com> <20110918082048.GA17490@kroah.com>
In-Reply-To: <20110918082048.GA17490@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2011 01:20 AM, Greg KH wrote:
> On Mon, Sep 12, 2011 at 04:53:20PM +0200, Greg KH wrote:
>> On Thu, Sep 08, 2011 at 09:06:17AM -0700, Randy Dunlap wrote:
>>> From: Randy Dunlap <rdunlap@xenotime.net>
>>>
>>> Fix build when CONFIG_ISA_DMA_API is enabled but
>>> CONFIG_COMEDI_PCI[_DRIVERS] is not enabled.
>>> Fixes these build errors:
>>>
>>> drivers/staging/comedi/drivers/ni_labpc.c: In function 'labpc_ai_cmd':
>>> drivers/staging/comedi/drivers/ni_labpc.c:1351: error: implicit declaration of function 'labpc_suggest_transfer_size'
>>> drivers/staging/comedi/drivers/ni_labpc.c: At top level:
>>> drivers/staging/comedi/drivers/ni_labpc.c:1802: error: conflicting types for 'labpc_suggest_transfer_size'
>>> drivers/staging/comedi/drivers/ni_labpc.c:1351: note: previous implicit declaration of 'labpc_suggest_transfer_size' was here
>>>
>>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>>> ---
>>>
>>> Greg, I had previously said that this patch was not needed since
>>> you had merged a larger patch, but I had another build error which
>>> this patch fixes, so it is now needed in mainline.
>>
>> So this is needed in Linus's tree now?  Or in linux-next?  It doesn't
>> apply to my staging-next tree so I'm confused.

Somehow I didn't see the message above.

The patch applies cleanly to Linus' current tree.

> Now dropped from my to-apply queue.
> 
> If this is still needed, please resend.

Yes, it is still needed.  Please see below.

---
From: Randy Dunlap <rdunlap@xenotime.net>

Fix build when CONFIG_ISA_DMA_API is enabled but
CONFIG_COMEDI_PCI[_DRIVERS] is not enabled.
Fixes these build errors:

drivers/staging/comedi/drivers/ni_labpc.c: In function 'labpc_ai_cmd':
drivers/staging/comedi/drivers/ni_labpc.c:1351: error: implicit declaration of function 'labpc_suggest_transfer_size'
drivers/staging/comedi/drivers/ni_labpc.c: At top level:
drivers/staging/comedi/drivers/ni_labpc.c:1802: error: conflicting types for 'labpc_suggest_transfer_size'
drivers/staging/comedi/drivers/ni_labpc.c:1351: note: previous implicit declaration of 'labpc_suggest_transfer_size' was here

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/staging/comedi/drivers/ni_labpc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- lnx-31-rc5.orig/drivers/staging/comedi/drivers/ni_labpc.c
+++ lnx-31-rc5/drivers/staging/comedi/drivers/ni_labpc.c
@@ -241,8 +241,10 @@ static int labpc_eeprom_write_insn(struc
 				   struct comedi_insn *insn,
 				   unsigned int *data);
 static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd);
-#ifdef CONFIG_COMEDI_PCI
+#ifdef CONFIG_ISA_DMA_API
 static unsigned int labpc_suggest_transfer_size(struct comedi_cmd cmd);
+#endif
+#ifdef CONFIG_COMEDI_PCI
 static int labpc_find_device(struct comedi_device *dev, int bus, int slot);
 #endif
 static int labpc_dio_mem_callback(int dir, int port, int data,
