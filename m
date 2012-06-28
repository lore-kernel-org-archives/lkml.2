Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab2F1T5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:57:33 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:15156 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2F1T5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:57:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1340913450!2582886!4
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Thu, 28 Jun 2012 14:57:18 -0500
Subject: RE: [PATCH 04/19] staging: comedi: adl_pci6208: document the
 register map of the device
Thread-Topic: [PATCH 04/19] staging: comedi: adl_pci6208: document the
 register map of the device
Thread-Index: Ac1VYSDCKCePtuF3Sg6TMMz05jFZyQABVMfg
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698F2EA87@AUSP01VMBX24.collaborationhost.net>
References: <201206271456.44218.hartleys@visionengravers.com>
 <20120628190602.GM5333@mwanda>
In-Reply-To: <20120628190602.GM5333@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 28, 2012 12:06 PM, Dan Carpenter wrote:
> On Wed, Jun 27, 2012 at 02:56:43PM -0700, H Hartley Sweeten wrote:
>> Add defines for the register map of the device. These will be
>> used to clarify the code.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  drivers/staging/comedi/drivers/adl_pci6208.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>> 
>> diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
>> index f949d20..b6a8439 100644
>> --- a/drivers/staging/comedi/drivers/adl_pci6208.c
>> +++ b/drivers/staging/comedi/drivers/adl_pci6208.c
>> @@ -53,6 +53,18 @@ References:
>>   */
>>  #include "../comedidev.h"
>>  
>> +/*
>> + * PCI-6208/6216-GL register map
>> + */
>> +#define PCI6208_AO_CONTROL(x)		(0x00 + (2 * (x)))
>> +#define PCI6208_AO_STATUS		0x00
>> +#define PCI6208_AO_STATUS_DATA_SEND	(1 << 0)
>> +#define PCI6208_DIO			0x40
>> +#define PCI6208_DIO_DO_MASK		(0x0f)
>> +#define PCI6208_DIO_DO_SHIFT		(0)
>> +#define PCI6208_DIO_DI_MASK		(0xf0)
>> +#define PCI6208_DIO_DI_SHIFT		(4)
>
> This series is nice and I'm not nacking anything, but really is it
> that useful to say:
> 	status = inw(dev->iobase + PCI6208_AO_STATUS);
> instead of just?:
> 	status = inw(dev->iobase);

Either would work.

But the '+ PCI6208_AO_STATUS' used in the function makes it
easily apparent that the 'status' register is being read without
having to go back and see what the assumed '+ 0' register is.

> I'm not sure what the 0x00 in PCI6208_AO_CONTROL represents.  Some
> of these are not used like PCI6208_DIO_DI_SHIFT.

Sorry about that. Maybe there should be a comment.

The PCI-6208 has 8 separate "control" registers, one for each DAC output
(the PCI-6216 has 16). They are at offsets 0x00, 0x02, 0x04, ... 0x0e (0x1e for
The PCI-6216). The PCI6208_AO_CONTROL macro is used to calculate the
necessary offset based on the DAC channel. The original code used the
same open-coded logic.

The unused ones can be removed. When I created the patch that added
them I just added everything that might be useful from the manual for
the PCI-6208. I was quite sure what ones would end up un used.

> Does checkpatch.pl complain if you leave off these parenthesis?  If
> so I will complain again to the checkpatch.pl people.  Extra
> parenthesis are silly and there not used consistently.  Only
> PCI6208_AO_CONTROL() and PCI6208_AO_STATUS_DATA_SEND() need
> paranthesis.

No, checkpatch.pl does not complain about the parenthesis either way.
I usually use the parenthesis in the 'bit' defines and not for the 'register'
defines. It helps my brain keep them separate... ;-)

But, they can be removed it needed.

> Again, I'm fine with this patch and the whole series.  These are
> just comments.

Thanks for the comments!

Regards,
Hartley
