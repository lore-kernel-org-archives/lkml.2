Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0ERA4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 20:56:36 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:64342 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab0ERA4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 20:56:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kQY7ia5pfIoAWQvUouJjGdFkua+blsp0dJijgQhlra4cP/KtCeS14NamK81f62iYA7
         L+dOjeQmhHAziWuBJnnCdX65h8ZoUzbfT5rco/Lyck096Snz+IEC2yrDx6+wh0ctPWqW
         yQqZKKdX1rsJkeOThFBYP1yAnEiaEJjN7ySTg=
Message-ID: <4BF1E5BE.9010000@gmail.com>
Date: Mon, 17 May 2010 18:56:30 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Yuhong Bao <yuhongbao_386@hotmail.com>, venkatesh.pallipadi@intel.com,
       markh@compro.net, dmarkh@cfl.rr.com, andi@firstfloor.org,
       Linus Torvalds <torvalds@linux-foundation.org>, alain@knaff.lu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
References: <87bphpd4rt.fsf@basil.nowhere.org> <4B32565E.6000501@compro.net> <20091223191806.GA3336@linux-os.sc.intel.com> <4B3270FE.5090607@compro.net> <1261600243.16916.56.camel@localhost.localdomain> <4B476E8D.1030308@compro.net> <20100121190952.GA32523@linux-os.sc.intel.com> <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl> <20100125171059.GB5041@alberich.amd.com> <20100517145943.GV5888@alberich.amd.com>
In-Reply-To: <20100517145943.GV5888@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 08:59 AM, Andreas Herrmann wrote:
> On Mon, Jan 25, 2010 at 06:10:59PM +0100, Andreas Herrmann wrote:
>> On Fri, Jan 22, 2010 at 11:21:06PM -0800, Yuhong Bao wrote:
>>>
>>>> HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
>>>> side-effects on floppy DMA. Do not use HPET MSI on such platforms.
>>
>> Argh, will see what information I can find about this problem ...
>
> FYI. I've tried to trigger the publication of errata information for that
> chipset. Finally this has happened.
>
> The discussed problem is indeed due to an erratum. See erratum #27 in
> http://support.amd.com/us/Embedded_TechDocs/46837.pdf
>
> The suggested workaround for this is to disable HPET MSI if LPC
> devices are used. I doubt that there is a convenient way for Linux to
> find out whether LPC devices are used. Thus I think the only solution
> to safely avoid the problem is the currently implemented quirk to
> disable HPET MSI on this chipset.

If one wanted, you could disable HPET MSI on this chipset only when a 
driver requests an ISA DMA channel. Then if there's no floppy or other 
LPC DMA device present, it can stay enabled. I don't know if it's worth 
the trouble, though.
