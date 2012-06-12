Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab2FLAHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 20:07:45 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:37188 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2FLAHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 20:07:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-131.messagelabs.com!1339459662!20015277!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Date: Mon, 11 Jun 2012 19:07:41 -0500
Subject: RE: [PATCH] staging: comedi: cleanup alloc_subdevices
Thread-Topic: [PATCH] staging: comedi: cleanup alloc_subdevices
Thread-Index: Ac1ILeaWvdUhvECsRpu1Ithdin1XKQAAPucw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698DBC4A9@AUSP01VMBX24.collaborationhost.net>
References: <201206071508.15674.hartleys@visionengravers.com>
 <20120611235657.GA26721@kroah.com>
In-Reply-To: <20120611235657.GA26721@kroah.com>
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

On Monday, June 11, 2012 4:57 PM, Greg KH wrote:
> On Thu, Jun 07, 2012 at 03:08:15PM -0700, H Hartley Sweeten wrote:
>> Cleanup the comedi core "alloc_subdevices" fuction and it's use
>> in the comedi drivers.
>> 
>> 1) Move the inline alloc_subdevices() function from comedidev.h
>> to drivers.c and rename it to comedi_alloc_subdevices(). The
>> function is large enough to warrant being an exported symbol
>> rather than being an inline in every driver.
>> 
>> 2) Since dev->n_subdevices is an int variable, change the 
>> num_subdevices parameter from an unsigned int to an int.
>> 
>> 3) It's possible for a couple of the comedi drivers to incorrectly
>> call this function with num_subdevices = 0 so add a sanity check
>> before doing the kcalloc.
>> 
>> 4) It's possible for the kcalloc to fail so don't set dev->n_subdevices
>> until after the kcalloc has succedded. Also, remove the places in
>> the drivers were dev->n_subdevices was being set directly.
>> 
>> 5) Remove all the "allocation failed" error messages.
>> 
>> 6) Remove all the "Allocate the subdevice structures" comments from
>> the drivers. The function name itself provides this information.
>> 
>> 7) When comedi_alloc_subdevices does fail, make all the drivers
>> properly return the error code.
>
> You are doing 7 different things in one patch.  Doesn't that imply that
> you should have 7 different patches, in series, doing this?  That would
> make it easier to review at the least.
>
> Please redo this in that manner and resend.

2, 3, and 4 probably go together. They all deal with the 'num_subdevices'

1 can be a separate patch as long as I don't do the rename.

5, 6, and 7 could all go together with the final rename of the function.

Does that sound ok?

Regards,
Hartley

