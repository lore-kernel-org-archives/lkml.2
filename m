Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab3ABNlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:41:04 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:64641 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656Ab3ABNlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:41:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsGAG6Zu08Y1OVO/2dsb2JhbABEgXuyFoEIghUBAQU4HgYSCgEQCwsNCRYPCQMCAQIBERYeBgoDAQcCh3sBDQGnXogCChmBC4h7iwiFPAOIQoIWikOFT4ohgweBQQ
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="211190683"
Message-ID: <50E438F7.7040403@gmail.com>
Date: Wed, 02 Jan 2013 08:41:11 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:18.0) Gecko/20100101 Firefox/18.0 SeaMonkey/2.15
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.8-rc1 - another regression on USB :-(
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com> <50D764BA.1030501@gmail.com> <CA+55aFwButY7LcOH2XCh1Q8fKi2KQiNS_Caj4O9cHzb4C=TKGw@mail.gmail.com> <20121223232748.GA23804@kroah.com>
In-Reply-To: <20121223232748.GA23804@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> On Sun, Dec 23, 2012 at 02:35:49PM -0800, Linus Torvalds wrote:
>> Woody,
>>   Any chance you can bisect this? It's not going to be hugely pleasant
>> (with 11k+ commits in between 3.7 and 3.8-rc1 you'll have to compile
>> and test at least 14 kernels), but it would help enormously. Of
>> course, maybe some USB person can guess what would cause the device to
>> go offline..
>>
>> Added Greg and the linux-usb mailing list to the participants list:
>> the images are in the original email on lkml, but there isn't anything
>> particularly interesting there, it really just seems to be an
>> unexpected and spurious USB disconnect, resulting in "USB disconnect,
>> device number 2" followed by "Rejecting I/O to offline device".
> I don't see any images on lkml, sorry.
>
> The kernel log for when the disconnect happened would be great to get.
>
> The kernel can't cause a device to disconnect, that's an electrical
> thing usually, is this perchance a flaky device/connection?  Or has it
> always worked on older kernels?
>
> What host controller is being used here (xhci, ehci, etc.?)
>
> thanks,
>
> greg k-h
Greg, Linus,
It sounds insane, but after banging on the issue I have found out that 
USB problem is caused (also in vanilla kernel) with a config change:
USB-all built as modules - bad USB
USB core built in, UHCI/EHCI modules -  semi functional - but 1Mb/s transfer
USB core and UHCI EHCI built-in - bingo - no issues.

Could anybody duplicate that, or is it somehow my setup???

Thanks, Woody

