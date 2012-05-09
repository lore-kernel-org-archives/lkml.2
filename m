Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061Ab2EIPws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:52:48 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:63162 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184Ab2EIPwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:52:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-127.messagelabs.com!1336578765!5014676!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 9 May 2012 10:52:34 -0500
Subject: RE: [PATCH] staging: comedi: remove __user annotation inside of
 struct's
Thread-Topic: [PATCH] staging: comedi: remove __user annotation inside of
 struct's
Thread-Index: Ac0t73pPX9hUq5RPTEiyW1D1TnDbHgAC3AgA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698A17862@AUSP01VMBX24.collaborationhost.net>
References: <201205081641.00358.hartleys@visionengravers.com>
 <ADE657CA350FB648AAC2C43247A983F0020698A1774D@AUSP01VMBX24.collaborationhost.net>
 <4FAA44D7.1040209@mev.co.uk> <20120509142436.GC11695@kroah.com>
In-Reply-To: <20120509142436.GC11695@kroah.com>
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

On Wednesday, May 09, 2012 7:25 AM, gregkh@linuxfoundation.org wrote:
> On Wed, May 09, 2012 at 11:20:07AM +0100, Ian Abbott wrote:
>> On 2012-05-09 00:55, H Hartley Sweeten wrote:
>>> On Tuesday, May 08, 2012 4:41 PM, H Hartley Sweeten wrote:
>>>>
>>>> The structs' comedi_insn, coomedi_insnlist, comedi_cmd,
>>>> comedi_chaninfo, and comedi_rangeinfo are all passed to
>>>> the kernel from user space using ioctl commands. They
>>>> are then copied to kernel space using copy_from_user()
>>>> before the data is passed to the drivers.
>>>>
>>>> The __user annotation should not be used with variables
>>>> inside the struct. This produces a lot of sparse warnings
>>>> like:
>>>>
>>>>warning: dereference of noderef expression
>>>>
>>>> Signed-off-by: H Hartley Sweeten<hsweeten@visionengravers.com>
>>>> Cc: Ian Abbott<abbotti@mev.co.uk>
>>>> Cc: Mori Hess<fmhess@users.sourceforge.net>
>>>> Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>>>>
>>>> ---
>>>>
>>>> Note: This patch exposes some new warnings about different
>>>> address space. These will be addressed.
>>>
>>> Please ignore this patch.
>>>
>>> It appears the annotations in the struct definitions are correct.
>> 
>> Personally, I think you were on the mark with the patch.  It's
>> better to avoid using __user in comedi.h so it can be used as-is in
>> user-space. All of the structures in comedi.h are used in user-space
>> (although Comedilib uses its own version of comedi.h without all the
>> typedef eliminations that have been done in "staging") and some of
>> them are also deep-copied into kernel-space objects of the same
>> type, where the pointers in the structs would no longer be
>> user-space pointers.
>
> When the kernel exports .h files, stuff like this should work
> "automatically", so there is no need to not put __user markings.
>
> So please, yes, continue to work to get this correct, it is very
> essencial to ensure we don't mess stuff up.

Greg,

Based on the discussion I assume this patch is ok then. Do you
want me to repost it?

I'll work on fixing the other issues with the user <-> kernel transitions.

Regards,
Hartley
