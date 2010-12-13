Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0LMHHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 02:07:10 -0500
Received: from a.relay.invitel.net ([62.77.203.3]:49589 "EHLO
	a.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0LMHHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 02:07:08 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 02:07:08 EST
Date: Mon, 13 Dec 2010 08:01:06 +0100
From: Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH v2 1/2] video, sm501: add OF binding to support SM501
In-reply-to: <20101211143454.ccc5e296.rdunlap@xenotime.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linuxppc-dev@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Reply-to: hs@denx.de
Message-id: <4D05C4B2.5030005@denx.de>
Organization: DENX Software Engineering
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1292049075-1809-1-git-send-email-hs@denx.de>
 <20101211143454.ccc5e296.rdunlap@xenotime.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Randy,

Randy Dunlap wrote:
> On Sat, 11 Dec 2010 07:31:15 +0100 Heiko Schocher wrote:
> 
>> - add commandline options:
>>   sm501.fb_mode:
> 
>     sm501.mode:

Sorry, type, should be "sm501fb.mode", thanks!

>>     Specify resolution as "<xres>x<yres>[-<bpp>][@<refresh>]"
>>   sm501.bpp:

Here too, "sm501fb.bpp"

>>     Specify bit-per-pixel if not specified mode
>>
>> ---
>>
>>  Documentation/kernel-parameters.txt          |    7 +
>>  Documentation/powerpc/dts-bindings/sm501.txt |   30 +++
>>  drivers/mfd/sm501.c                          |  141 ++++++++------
>>  drivers/video/sm501fb.c                      |  264 +++++++++++++++++---------
>>  include/linux/sm501.h                        |    8 +
>>  5 files changed, 299 insertions(+), 151 deletions(-)
>>  create mode 100644 Documentation/powerpc/dts-bindings/sm501.txt
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index cdd2a6e..6341541 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -2301,6 +2301,13 @@ and is between 256 and 4096 characters. It is defined in the file
>>  			merging on their own.
>>  			For more information see Documentation/vm/slub.txt.
>>  
>> +	sm501.bpp=	SM501 Display driver:
>> +			Specify bit-per-pixel if not specified mode
> 
> 			Specifiy bits-per-pixel if not specified by 'mode'
> 
>> +
>> +	sm501fb.mode=	SM501 Display driver:
> 
> Shouldn't that be sm501.mode ?

No, the name of the source file is sm501fb.c -> sm501fb is right here.
As the sm501 is a multifunction device, the "fb" is more precise here.

>> +			Specify resolution as
>> +			"<xres>x<yres>[-<bpp>][@<refresh>]"
>> +
>>  	smart2=		[HW]
>>  			Format: <io1>[,<io2>[,...,<io8>]]
> 
> 
> However, I think that these shouldn't be added to Documentation/kernel-parameters.txt
> but should be added to the Documentation/fb/ sub-directory either by adding to
> Documentation/fb/modedb.txt or by adding a new file Documentation/fb/sm501.txt.

Ok, do this. Thanks for the review!

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
