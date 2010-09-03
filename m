Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab0ICCRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:17:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44689 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab0ICCRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:17:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cKqsQUddXZwgeWhXwkGWvM1nvGdxAIYfQs0Lu57G7vA79Sn7IDdsBRWD66PBcS8gg0
         OIFB2Owg3nBjj6i5W046o8hIObbyE1+qaIAJUYDbHRxpzuhfxlMNg7hgAjYoKbaNRhHN
         TPmsxq+dwgn17zmb/LEbOipzAyQSXlqexbWB0=
MIME-Version: 1.0
In-Reply-To: <20100902121853.e90f6c53.randy.dunlap@oracle.com>
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com>
	<20100902121853.e90f6c53.randy.dunlap@oracle.com>
Date: Fri, 3 Sep 2010 03:17:42 +0100
Message-ID: <AANLkTimwS=DPvZMWP3LScLVaVM-9X_BrKgRYW5ay=NRa@mail.gmail.com>
Subject: Re: [RFC] Fix typos
From: Phillip Lougher <phil.lougher@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 8:18 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 2 Sep 2010 16:05:14 -0300 Lucas De Marchi wrote:
>
>> Hi,
>>
>> I'd like to know if it's worth fixing all typos found in comments,
>> documentation and sometimes code. A first attempt to do that you can
>> find at http://people.profusion.mobi/~lucas/kernel-typos-fix.patch
>>
>> This was done by using the list of common typos available at
>> http://en.wikipedia.org/wiki/Wikipedia:Lists_of_common_misspellings
>>
>> I already removed some false positives, but there are more. Before
>> going ahead and verifying all of them, I'd like to know whether this
>> would be a good patch.
>
> Hi,
>
> I'd take most of the corrections in Documentation/, but in general,
> I don't think that it's a good idea without some careful review.
>

Seconded, even the files in Documentation/ (while mostly English text)
mix code and other technical/non-English details which throw up false
positives.

I reviewed the changes to the Documentation/ files and found the
following false positives

Documentation/DocBook/kernel-hacking.tmpl

- * Sun people can't spell worth damn. "compatability" indeed.
+ * Sun people can't spell worth damn. "compatibility" indeed.

-        .asciz "compatability"
+        .asciz "compatibility"

These misspellings are deliberate, and are in context to the file.

Documentation/hwmon/via686a

-        Jonathan Teh Soon Yew <j.teh@iname.com>
+        Jonathan Teh Soon Yew <j.the@iname.com>

teh is a name

Documentation/filesystems/vfat.txt

                 <slot #3, id = 0x43, characters = "h is long">
-                <slot #2, id = 0x02, characters = "xtension whic">
+                <slot #2, id = 0x02, characters = "xtension which">
                 <slot #1, id = 0x01, characters = "My Big File.E">

"xtension.whic" is correct, it is part of the string "My Big
File.Extension which is long" which has been split, the missing 'h' is
on the previous line.

Documentation/vm/pagemap.txt

-the read on an 8-byte boundary (e.g., if you seeked an odd number of bytes
+the read on an 8-byte boundary (e.g., if you sought an odd number of bytes

Thought seeked is bad English it is correct in this context where
you've done a seek operation.

The following are a couple of correctly found mistakes, but where
there's problems with the fix.

Documentation/filesystems/ntfs.txt

-to the "Target Device" or if you specified multipled target devices to all of
+to the "Target Device" or if you specified multiplied target devices to all of

multipled is a typo for multiple, not multiplied.

Documentation/scsi/aha152x.txt

-namely the address space is limited to upto 255 heads, upto 63 sectors
+namely the address space is limited to up to 255 heads, upto 63 sectors

What happened here?  It fixed the first 'upto' but missed the second 'upto'.


Documentation/powerpc/dts-bindings/can/sja1000.txt

-For futher information, please have a look to the SJA1000 data sheet.
+For further information, please have a look to the SJA1000 data sheet.

That can be further corrected to

+For further information, please have a look at the SJA1000 data sheet.

Phillip
