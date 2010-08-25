Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab0HYVJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 17:09:34 -0400
Received: from us-mx4.synaptics.com ([12.178.49.178]:48421 "EHLO
	us-mx4.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab0HYVJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 17:09:31 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Aug 2010 17:09:31 EDT
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 25 Aug 2010 12:20:03 -0700
Message-ID: <4C75843F.60400@synaptics.com>
Date: Wed, 25 Aug 2010 13:59:43 -0700
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Naveen Kumar GADDIPATI <naveen.gaddipati@stericsson.com>
CC: Allie Xiong <axiong@synaptics.com>, William Manson <WManson@synaptics.com>,
        "j.de.gram@gmail.com" <j.de.gram@gmail.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Pradeepkumar Kumar SUJUAR <pradeep.kumar.sujuar@stericsson.com>,
        Sundar R IYER <sundar.iyer@stericsson.com>
Subject: Re: [RFC PATCH 0/1] input/touchscreen: Synaptics Touchscreen Driver
References: <81C3A93C17462B4BBD7E272753C1057916DE5281A0@EXDCVYMBSTM005.EQ1STM.local>
In-Reply-To: <81C3A93C17462B4BBD7E272753C1057916DE5281A0@EXDCVYMBSTM005.EQ1STM.local>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 02:29 AM, Naveen Kumar GADDIPATI wrote:
> Hi Christopher,
>
> Some generic review comments for this patch
>
> 1. Normally, defconfig should be a separate patch. You need not
> post the entire defconfig, but only the changes to the Makefiles and
> the Kconfig files.
>
> 2. All RMI specific files can be moved to a separate driver folder
> in input/ like drivers/input/rmi/*.
>
> 3. Lots of Hungarian notation in the code. Please refer this snippet.
>
>> ------------------------------------
>> CODE CONTAINS HUNGARIAN NOTATION
>>
>> Some coding guidlines at some companies require that you type the name
>> of your variables using the infamous hungarian notation:
>> http://en.wikipedia.org/wiki/Hungarian_notation
>>
>> We have an internal coding guideline that touches on the
>> subject:
>> http://swadvice.lud.stericsson.com/guideline.aspx?nr=57&ver=latest
>>
>> According to the Linux kernel inventor Linus Torvalds in his document
>> Documentation/CodingStyle in the Linux kernel:
>>
>> "Encoding the type of a function into the name (so-called Hungarian
>> notation) is brain damaged-the compiler knows the types anyway and can
>> check those, and it only confuses the programmer."
>>
>> Remove all instances of hungariang notation in the code please.
>> Includes prefixing pointers with p_*, naming structs with s_*, enums
>> with e_*, suffixes like *32b etc etc.
>> -----------------------------------
>>
>
> We are also using the Synaptics RMI4 touch pad on our U8500 platform.
> We had to make some changes to these posted drivers to make it work on
> our platform. Also, we modified the touch screen driver to be compliant
> to the kernel coding guidelines, but as a stand alone driver though.
>
> I will soon post out an RFC for our patch which we got working on our board.
> Please do have a look and we would like you guys to incorporate these changes
> into your final patch sets as well, so that we can avoid any re-works later on
> when your patch set gets merged into the mainline kernel.

Hi Naveen,

Thanks very much for your input!

We'll be changing the patch structure with our next submission, as the 
current patch file is getting kind of large and clumsy.  We'll split the 
defconfig out into its own patch at that point.

We'll also be eliminating the Hungarian notation in the next submission.

Your suggestion regarding the location of the RMI specific files is 
interesting.  We'll defer to Dmitry on where he'd like to see those 
files placed, though.

Unfortunately, the patch you submitted appears to be based on the older 
monolithic RMI3/Android driver, which is limited in functionality and 
maintainability.  Also, your submitted patch appears to be specific to 
the U8500 platform.

The aim of the current work is to develop a platform independent modular 
driver that will support all RMI4 functionality in a generic fashion. 
We'll be more than happy to work with your team to develop support for 
the U8500 under the modular structure.  If we proceed in that direction, 
it eliminates redundant effort and the need for any rework when our 
driver gets merged into the mainline.

I think the first step there should be for your team to resubmit your 
work as modifications of the current development effort, rather than 
backporting the current effort onto the obsolete framework.  Although 
that involves upfront work for your team in the near term, it provides a 
reduction in effort all around going forward:
     - your team doesn't need to keep back-patching changes onto
       the obsolete driver structure
     - our team doesn't need to keep forward-patching U8500
       related changes into the current driver structure

In a recent email conversation with me, Dmitry indicated that he will be 
creating a development branch for this work in the near future.  That 
will greatly facilitate this effort.

					Thanks,
						Chris
