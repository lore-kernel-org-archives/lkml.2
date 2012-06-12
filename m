Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2FLUUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:20:36 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:3341 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2FLUUf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:20:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-160.messagelabs.com!1339532255!9308589!147
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
Date: Tue, 12 Jun 2012 15:20:32 -0500
Subject: RE: [PATCH 8/8] staging: comedi: cleanup comedi_alloc_subdevices
Thread-Topic: [PATCH 8/8] staging: comedi: cleanup comedi_alloc_subdevices
Thread-Index: Ac1I1Jh/JNUFPlnvRVKZy2nFxAJWHwAA43AA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698DBC78B@AUSP01VMBX24.collaborationhost.net>
References: <201206121159.55522.hartleys@visionengravers.com>
 <20120612194940.GZ4400@mwanda>
In-Reply-To: <20120612194940.GZ4400@mwanda>
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

On Tuesday, June 12, 2012 12:50 PM, Dan Carpenter wrote:
> On Tue, Jun 12, 2012 at 11:59:55AM -0700, H Hartley Sweeten wrote:
>>  	for (i = 0; i < num_subdevices; ++i) {
>> -		dev->subdevices[i].device = dev;
>> -		dev->subdevices[i].async_dma_dir = DMA_NONE;
>> -		spin_lock_init(&dev->subdevices[i].spin_lock);
>> -		dev->subdevices[i].minor = -1;
>> +		s = dev->subdevices + i;
>
> You don't have to resend, but I think this would look better as:
>
> 		s = &dev->subdevices[i];

I don't disagree but the "dev->subdevices +i" format is consistently
used in all the comedi stuff. If the format above is preferred we
should probably update everything,

>> +		s->device = dev;
>> +		s->async_dma_dir = DMA_NONE;
>> +		spin_lock_init(&s->spin_lock);
>> +		s->minor = -1;
>>  	}
>
> Btw, this patchset is great.  Nice.

Thanks!
Hartley
