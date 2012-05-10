Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2EJQLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:11:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39301 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2EJQLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:11:09 -0400
Message-ID: <4FABE899.9040602@wwwdotorg.org>
Date: Thu, 10 May 2012 10:11:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ben Dooks <ben@trinity.fluff.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org, Igor Grinberg <grinberg@compulab.co.il>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@ardb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Handling of modular boards
References: <20120504185850.GO14230@opensource.wolfsonmicro.com> <4FA432E9.9050606@wwwdotorg.org> <20120510104311.GB30103@trinity.fluff.org>
In-Reply-To: <20120510104311.GB30103@trinity.fluff.org>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 04:43 AM, Ben Dooks wrote:
> On Fri, May 04, 2012 at 01:50:01PM -0600, Stephen Warren wrote:
>> On 05/04/2012 12:58 PM, Mark Brown wrote:
>>> Quite a few reference platforms (including Wolfson ones, which is why
>>> I'm particularly interested) use replaceable modules to allow
>>> configuration changes.  Since we can often identify the configuration at
>>> runtime we should ideally do that but currently there's no infrastructure 
>>> to help with that...
>>
>> So, I'll respond within the context of device tree, although perhaps you
>> were looking for something more general?
>>
>> I was just asked basically the same question internally to NVIDIA. One
>> option that was floated was to store the device tree in chunks and have
>> the bootloader piece them together. You'd start with the DT for the
>> basic CPU board, probe what HW was available, and then graft in the
>> content of additional DT chunks and pass the final result to the kernel.
>> The advantages here are:
>>
>> a) The DT is stored in chunks for each plugin board, so there's no bloat
>> in the DT that gets passed to the kernel; it contains exactly what's on
>> the board.
> 
> Interesting, but how does it sort ofu things like mapping GPIO lines from
> the add-in board's view to the rest of the system?

To be fully general, we'd need to have some kind of proxy GPIO object
that always exists on the main board, for the plugin boards to provide
GPIOs to, or consume GPIOs from.

The simple case of a GPIO provider being on the main board and the
consumer being on a plugin board doesn't need this. The case of the GPIO
provider being on a plugin board, and the only GPIO consumer being on
the main board might not need this.

But if the GPIO provider is on one plugin board, and the GPIO consumer
on another, we'd want to have the DT chunks for each plugin board be
completely independent, so you'd need to route everything through
something that always exists, in the motherboard's DT. I haven't really
thought how that would look yet.

I think this is probably true irrespective of whether the bootloader is
merging the DT chunks, or the kernel did it during boot, or any other
way of constructing the final complete DT.
