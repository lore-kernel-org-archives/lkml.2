Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2GXXUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 19:20:42 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:1654
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997Ab2GXXUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 19:20:40 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2fh2a8h668h839hd25hf0ah107ah10d2h)
Message-ID: <500F2DB7.50403@am.sony.com>
Date: Tue, 24 Jul 2012 16:20:23 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>
Subject: Re: [08/36] AArch64: Kernel booting and initialisation
References: <1341608777-12982-9-git-send-email-catalin.marinas@arm.com> <500DB986.7090309@codeaurora.org> <20120724162404.GB29519@arm.com> <201207241853.16625.arnd@arndb.de>
In-Reply-To: <201207241853.16625.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/12 11:53, Arnd Bergmann wrote:
> On Tuesday 24 July 2012, Catalin Marinas wrote:
>> On Mon, Jul 23, 2012 at 09:52:22PM +0100, Christopher Covington wrote:
>>> Hi Catalin and Stephen,
>>>
>>> Catalin Marinas - July 8, 2012, 9:18 a.m.
>>>> On Fri, Jul 06, 2012 at 10:32:54PM +0100, Stephen Warren wrote:
>>>>
>>>>> Also, on Tegra at least and perhaps OMAP too, there are a few parts
>>>>> of earlyprintk serial port setup (i.e. port selection) which happen
>>>>> as part of the decompressor rather than the main kernel image, so
>>>>> we'd have to re-jig that too.
>>>>
>>>> Whatever we did on AArch32, if it was useful and we want to follow a
>>>> similar model it needs porting given that the code cannot be shared. So
>>>> there is nothing to re-jig but rather implement.
>>>>
>>>> As for earlyprintk, you can initialise it in the decompressed kernel
>>>> anyway. But even though it's a useful debugging tool, it goes against
>>>> the single Image aim (at least the current printascii/addruart
>>>> implementation). I don't have a proper implementation yet.
>>>
>>> Would DCC [1] be a reasonably commonly available early printk mechanism
>>> for the single image to provide?
>>
>> Yes, this can be implemented but I think it has its own restrictions,
>> requiring a JTAG connection.
> 
> Right, which means that it's not generic and we still need to make
> a decision for a how we want to solve the underlying problem. The
> options I see are:
> 
> 1. Have no earlyprintk before loading the console drivers
> 2. Make the series from Domenico architecture independent code
> 3. Reimplement a layer like that, differently
> 4. Make it a compile-time option and allow this only for
>    low level debugging purposes but disable it in distro kernels.

I have found earlyprintk to be very valuable for debugging the many
times that boot fails for me.

Not having earlyprintk does not seem a good idea to me.  Option 4 is
perfectly acceptable for my use cases.

-Frank

