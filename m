Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2EIKUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 06:20:15 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49547 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab2EIKUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 06:20:13 -0400
Message-ID: <4FAA44D7.1040209@mev.co.uk>
Date: Wed, 9 May 2012 11:20:07 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120414 Thunderbird/11.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: remove __user annotation inside of struct's
References: <201205081641.00358.hartleys@visionengravers.com> <ADE657CA350FB648AAC2C43247A983F0020698A1774D@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698A1774D@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-09 00:55, H Hartley Sweeten wrote:
> On Tuesday, May 08, 2012 4:41 PM, H Hartley Sweeten wrote:
>>
>> The structs' comedi_insn, coomedi_insnlist, comedi_cmd,
>> comedi_chaninfo, and comedi_rangeinfo are all passed to
>> the kernel from user space using ioctl commands. They
>> are then copied to kernel space using copy_from_user()
>> before the data is passed to the drivers.
>>
>> The __user annotation should not be used with variables
>> inside the struct. This produces a lot of sparse warnings
>> like:
>>
>> warning: dereference of noderef expression
>>
>> Signed-off-by: H Hartley Sweeten<hsweeten@visionengravers.com>
>> Cc: Ian Abbott<abbotti@mev.co.uk>
>> Cc: Mori Hess<fmhess@users.sourceforge.net>
>> Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>>
>> ---
>>
>> Note: This patch exposes some new warnings about different
>> address space. These will be addressed.
>
> Please ignore this patch.
>
> It appears the annotations in the struct definitions are correct.

Personally, I think you were on the mark with the patch.  It's better to 
avoid using __user in comedi.h so it can be used as-is in user-space. 
All of the structures in comedi.h are used in user-space (although 
Comedilib uses its own version of comedi.h without all the typedef 
eliminations that have been done in "staging") and some of them are also 
deep-copied into kernel-space objects of the same type, where the 
pointers in the structs would no longer be user-space pointers.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
