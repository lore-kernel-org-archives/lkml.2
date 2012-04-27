Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab2D0Mbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:31:52 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:15872 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2D0Mbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:31:51 -0400
Message-ID: <4F9A91A8.4050608@atmel.com>
Date: Fri, 27 Apr 2012 14:31:36 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, <balbi@ti.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>, Matt Mackall <mpm@selenic.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Default Kconfig state for hw_random drivers
References: <20120426114229.GG3207@opensource.wolfsonmicro.com> <CAOesGMj2eZvWek86D2MKQMPY9qAsC0D2MsYyN-+RPUr5gDFn4A@mail.gmail.com>
In-Reply-To: <CAOesGMj2eZvWek86D2MKQMPY9qAsC0D2MsYyN-+RPUr5gDFn4A@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 04:17 PM, Olof Johansson :
> On Thu, Apr 26, 2012 at 4:42 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>> An Atmel hw_random driver just appeared in -next.  Since it's just a
>> regular platform device it has no dependencies on any particular
>> platform so following the behaviour of other hw_random drivers it's set
>> to default enabled if hw_random is enabled, even on non-Atmel platforms.
>>
>> This doesn't feel like the right thing to do - it'd mean that most of
>> the embedded RNGs would end up getting enabled by default which probably
>> isn't what we want.
> 
> Indeed, thanks for catching this. The driver isn't new but it had a
> previous dependency on just one AT91 chip family.
> 
> Looking at other options in the same Kconfig, it would be appropriate
> to make it depend on ARCH_AT91 instead.
> 
> Nicolas?

Hi,

I had the same kind of discussion with Felipe and Arnd in this thread:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/122248/focus=122304

The conclusion came out after Arnd's strong arguments:
http://article.gmane.org/gmane.linux.ports.arm.kernel/122962

Maybe adding a "default" directive can be an valid option?

Best regards,
-- 
Nicolas Ferre
