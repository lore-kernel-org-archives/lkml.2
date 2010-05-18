Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab0ERBHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 21:07:01 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65371 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab0ERBHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 21:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Dmhd2hZUNPhxLeJbvA82HEXODPPkGWsDHnGOQnwK/sChiKjcXEt48fBrekHzNhVoKA
         nNBFROyX2uXwaLjQEMhIE0ZKY+mdKdLr5BI1MJkWVEP0mVVlahfgMKAj+b4qU2VgI8ME
         pMc+1+p0tiUYwNmO7NlxzIbBxbnwCBTmvh/rI=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1005171800050.4195@i5.linux-foundation.org>
References: <87bphpd4rt.fsf@basil.nowhere.org> <4B3270FE.5090607@compro.net>
	 <1261600243.16916.56.camel@localhost.localdomain>
	 <4B476E8D.1030308@compro.net>
	 <20100121190952.GA32523@linux-os.sc.intel.com>
	 <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl>
	 <20100125171059.GB5041@alberich.amd.com>
	 <20100517145943.GV5888@alberich.amd.com> <4BF1E5BE.9010000@gmail.com>
	 <alpine.LFD.2.00.1005171800050.4195@i5.linux-foundation.org>
Date: Mon, 17 May 2010 19:06:58 -0600
Message-ID: <AANLkTimcfkzETvhT3gQlnLprNFU76HenoOJ5sdvtK1vF@mail.gmail.com>
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
From: Robert Hancock <hancockrwd@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Yuhong Bao <yuhongbao_386@hotmail.com>, venkatesh.pallipadi@intel.com,
       markh@compro.net, dmarkh@cfl.rr.com, andi@firstfloor.org,
       alain@knaff.lu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 7:02 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 17 May 2010, Robert Hancock wrote:
>>
>> If one wanted, you could disable HPET MSI on this chipset only when a driver
>> requests an ISA DMA channel. Then if there's no floppy or other LPC DMA device
>> present, it can stay enabled. I don't know if it's worth the trouble, though.
>
> Nope, that wouldn't work.
>
> Imagine a driver that already loaded, and is already using MSI (say,
> network device). What happens now if you want to access the floppy and
> load the floppy module? Oh, you can't? Need to bring down the network
> interface, unload that module first? Not practical.
>
> Sure, in theory we can do some crazy callback for "you now need to re-do
> your interrupt registration" for all devices. In practice, I can onyl say
> "not going to happen".

It sounds like this bug only affects HPET MSI requests (presumably the
only ones that the southbridge can concern itself with), not any
others. It would require the HPET code to support having its MSI
support yanked away at runtime, though.
