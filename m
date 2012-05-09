Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab2EIVVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:21:22 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:28019 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2EIVVU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:21:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-127.messagelabs.com!1336598430!5049397!64
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Date: Wed, 9 May 2012 16:21:15 -0500
Subject: RE: [PATCH v2] staging: comedi: remove __user annotation inside of
 struct's
Thread-Topic: [PATCH v2] staging: comedi: remove __user annotation inside of
 struct's
Thread-Index: Ac0uJDkrF+NU5a03TRylDGCgabEgfQABDjsw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698A17992@AUSP01VMBX24.collaborationhost.net>
References: <201205090936.03921.hartleys@visionengravers.com>
 <20120509204210.GA22184@kroah.com>
In-Reply-To: <20120509204210.GA22184@kroah.com>
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

On Wednesday, May 09, 2012 1:42 PM, Greg KH wrote:
> On Wed, May 09, 2012 at 09:36:03AM -0700, H Hartley Sweeten wrote:
>> Remove the __user annotations in the struct definitions in
>> comedi.h.
>> 
>> These structs are used to pass information from user-space
>> to kernel-space. The copy_from_user and copy_to_user functions
>> are used to transfer the data between the address spaces.
>> 
>> The drivers then use the information internally under the
>> assumption that they are kernel-space objects. Having the
>> __user annotations inside the structs produces a number of
>> sparse warnings of the type:
>> 
>> warning: dereference of noderef expression
>> 
>> According to Grek Kroah-Hartman:

Sorry about that typo... ;-)

>> 
>> "When the kernel exports .h files, stuff like this should work
>> "automatically", so there is no need to not put __user markings."
>
> Wait, for some reason I thought you were adding __user markings, not
> removing them from the structures.  That is why I said the above
> statement.

Ah.. Missed the "not" in your comment...

>
> Why again are you removing them?  Didn't you just cause more sparse
> warnings to pop up?

I still think they should be removed but I need to dig thru it a bit.

The structs in question are used internally in the comedi drivers after
the data has been passed into the kernel using the various ioctl's.
The ioctl code does do the copy_from/to_user correctly (kind of,
I did notice one place where the copy_from_user is referencing a
kernel pointer). But, when the driver's try to use the data, assuming
it's kernel space data, it's still annotated as __user so we get all the
"warning: dereference of noderef expression" along with a couple
other sparse warnings.

Ian Abbott did reply that he thought the patch was correct. With my
miss-read of your comment I thought you were agreeing.

Regardless, I'll keep looking it over...

Regards,
Hartley
