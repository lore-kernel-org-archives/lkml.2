Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab2D0UNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:13:14 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:30779 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab2D0UNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:13:13 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1335557569!4192560!35
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Date: Fri, 27 Apr 2012 15:13:05 -0500
Subject: RE: [PATCH] staging: comedi: introduce 'comedi_get_board' helper
 function
Thread-Topic: [PATCH] staging: comedi: introduce 'comedi_get_board' helper
 function
Thread-Index: Ac0krApMSbmUjjA8SbuTCk3dmtDjCQABaOnA
Message-ID: <ADE657CA350FB648AAC2C43247A983F002069887EFFF@AUSP01VMBX24.collaborationhost.net>
References: <201204271149.49035.hartleys@visionengravers.com>
 <20120427192900.GA14158@kroah.com>
In-Reply-To: <20120427192900.GA14158@kroah.com>
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

On Friday, April 27, 2012 12:29 PM, Greg KH wrote:
> On Fri, Apr 27, 2012 at 11:49:48AM -0700, H Hartley Sweeten wrote:
>> This helper function is used to fetch the comedi_device board_ptr
>> which is used during the attach to pass board specific information
>> to the comedi drivers.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: Mori Hess <fmhess@users.sourceforge.net>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> 
>> ---
>> 
>> With this helper removing all the 'this_board' defines in the drivers
>> will be easier (and cleaner).
>> 
>> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
>> index 300fd84..53a05dd 100644
>> --- a/drivers/staging/comedi/comedidev.h
>> +++ b/drivers/staging/comedi/comedidev.h
>> @@ -235,6 +235,11 @@ struct comedi_device {
>>  	void (*close) (struct comedi_device *dev);
>>  };
>>  
>> +static inline const void *comedi_get_board(struct comedi_device *dev)
>> +{
>> +	return dev->board_ptr;
>> +}
>
> "traditionally" the *get* functions increment a reference count of the
> pointer it returns, which isn't happening here.

I was trying to model it after dev_get_drvdata. But I see what you mean.

> How about renaming this to just be comedi_board() instead?

Or comedi_board_ptr... Either one works for me but I do like the shorter
name you suggested.

I'll post an updated patch shortly using the comedi_board name.

Regards,
Hartley

