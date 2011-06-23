Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab1FWJro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:47:44 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48273 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942Ab1FWJrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:47:42 -0400
Message-ID: <4E030BA6.8060407@ahsoftware.de>
Date: Thu, 23 Jun 2011 11:47:18 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: gregkh@suse.de, Nicolas Pitre <nico@fluxnic.net>,
        linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Alan Stern <stern@rowland.harvard.edu>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: ehci: use packed,	aligned(4) instead of removing
 the packed attribute
References: <Pine.LNX.4.44L0.1106201240240.2113-100000@iolanthe.rowland.org>	<alpine.LFD.2.00.1106201306210.2142@xanadu.home>	<4DFF85D6.1090104@ahsoftware.de> <201106202207.23104.arnd@arndb.de>
In-Reply-To: <201106202207.23104.arnd@arndb.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.06.2011 22:07, schrieb Arnd Bergmann:
> On Monday 20 June 2011 19:39:34 Alexander Holler wrote:
>> That packed without an additional aligned() caused errors on ARM with
>> gcc 4.6 is another problem which got (currently) fixed by removing packed.
>
> Packed caused errors because it is *wrong*. The code as it was used undefined
> behavior in the language.

I don't see why using just packed was wrong. The problem occured because 
the latest gcc now uses or inforces aligned(1) for a packed struct 
without any aligned and because of that the assignment in readl() is 
done byte by byte. I'm missing the required arm knowledge and experience 
to discuss this further, I don't have a reason to look further into that 
and never wanted to make any judgement about the cause.

>> But this introduces imho doubts and uncertainty about if padding bytes
>> could be between the members, therefore I would prefer to use packed
>> with aligned instead of removing the packed.
>
> Packing was never an issue here, please stop talking about it.

Sorry, I never wanted to talk about the issue itself (I've already said 
that), I just wanted to bring in some additional clarity for people 
looking at the code.

I think if there is a packed,aligned(4) most people reading that are 
able to imaging how the struct looks like, whereas nothing (without 
packed) might leave doubts which than requires to read compiler docs or 
the generated code, if one searches a problem in that area.

Maybe my english is that bad that nobody understood that.

But it's ok. For me, that discussion was long over, two people already 
said that they prefer the struct without any packed.

About the background:
I've posted that patch, because I though I might have been the source of 
the removal of packed instead of using packed along with aligned, 
because I first posted such (removing the packed) at the mailing list 
for u-boot and only later on thought that using what was hinted to me 
over a third person (packed, aligned(4), which means the one who 
originally found and fixed the problem used packed, aligned(4) too) 
might be better (what I than posted there too).

Sorry for becoming that verbose, I normally don't gabble that much and I 
would like it if I never would have posted that silly patch.

Regards,

Alexander
