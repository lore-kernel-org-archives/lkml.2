Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab2EQGPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 02:15:14 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:51057 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab2EQGPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 02:15:10 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-209.messagelabs.com!1337235309!5858055!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Date: Thu, 17 May 2012 01:15:08 -0500
Subject: RE: [PATCH] staging: comedi: Convert struct addi_board
 initialization to C99 format
Thread-Topic: [PATCH] staging: comedi: Convert struct addi_board
 initialization to C99 format
Thread-Index: Ac0z00/yvqECEjXFR+W+E36nRzqqaAAIAo8D
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206986FBDDF@AUSP01VMBX24.collaborationhost.net>
References: <201205161751.56913.hartleys@visionengravers.com>,<20120517021805.GA32592@kroah.com>
In-Reply-To: <20120517021805.GA32592@kroah.com>
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

Wednesday, May 16, 2012 7:18 PM, Greg KH wrote:
> On Wed, May 16, 2012 at 05:51:56PM -0700, H Hartley Sweeten wrote:
>> Convert the struct addi_board initialization to C99 format and remove
>> all the NULL or 0 initializers. This makes maintaining and editing the
>> code simpler and less error prone.
>>
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: Mori Hess <fmhess@users.sourceforge.net>
>>
>> ---
>>
>> This patch is a bit large but should be easy enough to review.
>> It does incease the size of the source file in bytes but it reduces
>> the lines of code by 1103 lines.
>>
>> There are 6 checkpatch warnings about lines over 80 characters
>> due to the long CamelCase names for some of the functions.
>> "Fixing" these actually hurts the readability of the code. The
>> checkpatch warnings will be addressed later by renaming the
>> CamelCase functions.
>
> Nice job, this driver is a pain to read...

Thanks. I agree... I've been avoiding the addi drivers until now.
Anytime a C file has an #include "something.c" it makes me
shudder... 

I've been thinking that the addi stuff should really be broken up
into some library modules with exported symbols for the individual
addi drivers to use. I need to look a bit closer at them to see if
this would work. Right now the whole thing is a bit of a mess.

Regards,
Hartley


Regards,
Hartley