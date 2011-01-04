Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab1ADU4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:56:21 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42553 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1ADU4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:56:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fXvZYJtZo+uSNMKlJ5FqOgiyUtSBmyVnNSvISkJOZej8cPgfX5j8cpNxvvwxqsQ5Ff
         q2/fQaRSlTJukbypSrBgDkktw2ZvsdXLwL+l1ZYXesEK7SWM1u2Yf6I1aI6NegJn7q8D
         BJe14twavMCV9DOvuc9vcpQYdHsgl/ZSW9jew=
MIME-Version: 1.0
In-Reply-To: <AANLkTikOsULOVq01CEiPuoK4-sFTk+KWJiLY0wnzUZ17@mail.gmail.com>
References: <20110104061821.GA25886@gherkin.frus.com>
	<AANLkTikOsULOVq01CEiPuoK4-sFTk+KWJiLY0wnzUZ17@mail.gmail.com>
Date: Tue, 4 Jan 2011 22:56:18 +0200
X-Google-Sender-Auth: mD-3E8RGgRdGRZXtWje2LqiBlZc
Message-ID: <AANLkTikyX3F+NjHVTGVV6rKyJhZQCcb3150-91La0rHs@mail.gmail.com>
Subject: Re: [BUG] implicit declaration of kfree/kzalloc in i2c-i801.c on Alpha
From: Pekka Enberg <penberg@kernel.org>
To: Matt Turner <mattst88@gmail.com>
Cc: Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, mcree@orcon.net.nz,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 9:37 PM, Matt Turner <mattst88@gmail.com> wrote:
> On Tue, Jan 4, 2011 at 1:18 AM, Bob Tracy <rct@gherkin.frus.com> wrote:
>> Another 2.6.37-rc8 build failure on alpha:
>>
>> (...)
>>  CC [M]  drivers/i2c/busses/i2c-i801.o
>> drivers/i2c/busses/i2c-i801.c: In function 'i801_probe':
>> drivers/i2c/busses/i2c-i801.c:737: error: implicit declaration of function 'kzalloc'
>> drivers/i2c/busses/i2c-i801.c:737: warning: assignment makes pointer from integer without a cast
>> drivers/i2c/busses/i2c-i801.c:855: error: implicit declaration of function 'kfree'
>> make[3]: *** [drivers/i2c/busses/i2c-i801.o] Error 1
>> make[2]: *** [drivers/i2c/busses] Error 2
>> make[1]: *** [drivers/i2c] Error 2
>> make: *** [drivers] Error 2
>>
>> --Bob
>
> Is this specific to alpha? I wonder why we don't see this on other platforms?

The x86 version of <asm/pci.h> includes <linux/slab.h> which hides the
problem on x86 at least. There was a big cleanup of implicit
<linux/slab.h> inclusions few months ago which has exposed the
problem.

It's a bug in the driver, just add the include there.

                        Pekka
