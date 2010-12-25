Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab0LYVAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 16:00:51 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48976 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0LYVAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 16:00:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nZH/tcZGbUA6aGMwuHxsaBy5R6cGR0VCEZc98uYu8CrggJBLT6i2C+aE5WbatmWCU+
         tBEXr/lY7r5yzfbMeKqs+4DIu8l8BB6H8fBQz5LbbDwc1VBHAq3mGRuUsGAwzp4ASOVX
         r4JK2bEdec73scwbgahJlDSPQOWSKWl166aEc=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012252144030.10759@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012252125410.10759@swampdragon.chaosbits.net>
	<AANLkTi=Y4wDG6+AY1=8NuFLGuCidgqaU1LginfB1YpZH@mail.gmail.com>
	<alpine.LNX.2.00.1012252144030.10759@swampdragon.chaosbits.net>
Date: Sat, 25 Dec 2010 22:00:48 +0100
Message-ID: <AANLkTi=yFm+kwXJbFrotTNmWky1J7O8=qVg7rhq=HxZG@mail.gmail.com>
Subject: Re: [PATCH] 3c59x: Don't assign when a comparison is intended
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: netdev@vger.kernel.org,
        Steffen Klassert <klassert@mathematik.tu-chemnitz.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 9:45 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Sat, 25 Dec 2010, richard -rw- weinberger wrote:
>
>> On Sat, Dec 25, 2010 at 9:30 PM, Jesper Juhl <jj@chaosbits.net> wrote:
>> > Hi,
>> >
>> > In drivers/net/3c59x.c::vortex_probe1() we have this code:
>> >
>> >        if (gendev) {
>> >                if ((pdev = DEVICE_PCI(gendev))) {
>> >                        print_name = pci_name(pdev);
>> >                }
>> >
>> >                if ((edev = DEVICE_EISA(gendev))) {
>> >                        print_name = dev_name(&edev->dev);
>> >                }
>> >        }
>> >
>> > I believe these assignments were intended to be comparisons.
>> > If I'm correct, then here's a patch to fix that up.
>>
>> I don't think so. Look at the extra brackets.
>>
>> The code can also written as:
>>
>> pdev = DEVICE_PCI(gendev);
>> if(pdev)
>>   print_name = pci_name(pdev);
>>
>
> Arrgh, I completely missed that - damn.
> You are correct I think and my patch is wrong.
> Thanks for taking a look.

BTW: gcc is smart enough to catch such typos.

if(x = 3){
 ...
}

...would trigger a warning like this one:
"warning: suggest parentheses around assignment used as truth value"

>
> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>

-- 
Thanks,
//richard
