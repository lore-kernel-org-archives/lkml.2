Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1ETHqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:46:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63133 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1ETHqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dxYCv+R9j6FMAl1vH2MLgRJ2/49eThQFTXwLhI0Tb4J9vAkESy8hK57gwgnWaATOMr
         B/P+HjA2DRY26gk9y+npi3+RBPxrNSiVEqauFf3gJihfxTN2ASmEhtCh6XmHIRmstqc+
         KL5bp7aqlRcIoxr8Hl1yMRRxDXwoisKmtp/yc=
MIME-Version: 1.0
In-Reply-To: <20110520065248.GB21285@ponder.secretlab.ca>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTi=poU17RqAzp28CPjWHrN_+aFiyag@mail.gmail.com>
	<BANLkTindee6UMez8HyBUwd2H6mN-DknzPw@mail.gmail.com>
	<BANLkTik7BnJKWCsm2L3-GJPTaaiXFNSgaA@mail.gmail.com>
	<20110520065248.GB21285@ponder.secretlab.ca>
Date: Fri, 20 May 2011 09:46:06 +0200
X-Google-Sender-Auth: rTG2iLsTMRyP0kd_41cQPR-ynyo
Message-ID: <BANLkTimMzEDm1wGu4TaYnsOQAu-e=90SAg@mail.gmail.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to drivers/gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jonas Aaberg <jonas.aberg@stericsson.com>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 Grant Likely <grant.likely@secretlab.ca>:
> On Thu, May 19, 2011 at 02:25:47PM +0200, Linus Walleij wrote:
>> On Thu, May 19, 2011 at 1:38 PM, Barry Song <21cnbao@gmail.com> wrote:
>>
>> >> -arch_initcall(u300_gpio_init);
>> >> -module_exit(u300_gpio_exit);
>> >>
>> > looks like the driver can't be a real module, is the module_exit
>> > suitable? it looks strange module_exit plays together with
>> > arch_initcall.
>>
>> It's a rather common design pattern in the kernel for early
>> platform drivers. Either the dependencies are resolved by the
>> different initlevels or they are resolved in probe order with
>> loadable modules. Module load will call all initlevels in order.
>>
>> It is not elegant but it is common.
>
> but it does need to be fixed.  Unfortunately it is not simple.  What
> is needed is a generic deferral or ability for drivers to declare
> dependences on other devices beyond their immediate parent.
>
> I've thought about this a bit on and off over the last year, but I
> haven't actually sat down to try and hack anything out yet.

Sounds like it needs to do for the kernel what systemd does for
userspace in my ears. And I wholeheartedly agree it needs
fixing.

A main concern would be that these dependencies are currently
implicit, Arjan did a great job on fixing some of it by
parallellizing initilization of drivers per initlevel and sync it at at
the end of each level, doing a clean dependecy resolution
would do away with all the initlevels eventually.

Yours,
Linus Walleij
