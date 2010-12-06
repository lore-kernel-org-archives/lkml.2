Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0LFSCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:02:00 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35170 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab0LFSB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:01:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EIZEythjlIxz1FKJLsBe22Z6plfHZGqJQOETXIdpQnHGDClvmYxujE1gTpSz9SZ9aI
         y6A11o5FTLF+r1qc/GD+hr2IEVGVNHiwRA7yY7/1pt56Z2KZJNwwj1WdO/0wRRhN+I3q
         k8cnK8vS8qGYAXIj7E6NZ41ZNKW01Z6S7ZK8E=
MIME-Version: 1.0
In-Reply-To: <AANLkTimm1Xn4wwNAoDJ4hjnOmBOnxBgcsCzVEJTEag97@mail.gmail.com>
References: <20101204135732.GA12774@sepie.suse.cz>
	<AANLkTimeyo==XJWUaUs8EzJvA8azkk3sw9FXQhMjuo6M@mail.gmail.com>
	<20101205081108.9bdb7504.randy.dunlap@oracle.com>
	<AANLkTimm1Xn4wwNAoDJ4hjnOmBOnxBgcsCzVEJTEag97@mail.gmail.com>
Date: Mon, 6 Dec 2010 18:01:58 +0000
X-Google-Sender-Auth: 0Pa7GKevAFFRty0C3pucFFRs-ew
Message-ID: <AANLkTimXRBz7-mz_E_xdc85pGi7ExMy67XfDVF7jEt+Y@mail.gmail.com>
Subject: Re: [GIT] kbuild and kconfig fixes for 2.6.37-rc5
From: Catalin Marinas <catalin.marinas@arm.com>
To: trapdoor6@gmail.com
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        brueckner@linux.vnet.ibm.com, lacombar@gmail.com, mchehab@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2010 16:51, trapDoor <trapdoor6@gmail.com> wrote:
> On Sun, Dec 5, 2010 at 4:11 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On Sun, 5 Dec 2010 15:42:46 +0000 trapDoor wrote:
>>
>>> Hello,
>>> I couldn't wait and I merged the changes into my copy of mainline
>>> tree. The merge was successful, no conflicts and the merge-diffstat
>>> was exactly the same as above. However, when  running oldconfig on the
>>> patched kernel I still get lots of warnings:
>>>
>>> warning: (GPIO_RDC321X && PCI && GPIOLIB) selects MFD_RDC321X which
>>> has unmet direct dependencies (MFD_SUPPORT && PCI)
>>> warning: (I2C_ISCH && I2C && PCI || GPIO_SCH && GPIOLIB && PCI ||
>>> GPIO_VX855 && GPIOLIB || GPIO_RDC321X && PCI && GPIOLIB ||
[...]
>>> MFD_JZ4740_ADC && MFD_SUPPORT && MACH_JZ4740 || MFD_TPS6586X &&
>>> MFD_SUPPORT && I2C=y && GPIOLIB && GENERIC_HARDIRQS || MFD_VX855 &&
>>> MFD_SUPPORT && PCI) selects MFD_CORE which has unmet direct
>>> dependencies (MFD_SUPPORT)
>>
>> That's 2 warnings.  I have sent a patch for the first one.
>> Looks like I need to resend it.
>
> I was actually impressed by the amount of lines produced by those two
> warnings :) I'd call it 'a lot'.

This could be simplified to only show the first option of every '&&'
expression, something like below:

warning: I2C_ISCH selects MFD_CORE...
warning: GPIO_SCH selects MFD_CORE...

But I couldn't figure out whether the expression reduction code in
kbuild reorders the options or not.

-- 
Catalin
