Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2E2JCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:02:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60529 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab2E2JCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:02:03 -0400
MIME-Version: 1.0
In-Reply-To: <1338258732.20487.171.camel@deadeye>
References: <1338226278-13336-1-git-send-email-torne@google.com>
	<1338258732.20487.171.camel@deadeye>
Date: Tue, 29 May 2012 10:02:01 +0100
Message-ID: <CAEV-rjeEKMNs2N8KEatCi+guFKihgFok4k4nDnd=vTQ5x7iStg@mail.gmail.com>
Subject: Re: [PATCH V2] MMC: core: cap MMC card timeouts at 2 seconds.
From: "Torne (Richard Coles)" <torne@google.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: cjb@laptop.org, linus.walleij@linaro.org, jh80.chung@samsung.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2012 03:32, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Mon, 2012-05-28 at 18:31 +0100, Torne (Richard Coles) wrote:
>> From: "Torne (Richard Coles)" <torne@google.com>
>>
>> MMC CSD info can specify very large, ridiculous timeouts, big enough to
>> overflow timeout_ns on 32-bit machines. This can result in the card
>> timing out on every operation because the wrapped timeout value is far
>> too small.
>>
>> Fix the overflow by capping the result at 2 seconds.  Cards specifying
>> longer timeouts are almost certainly insane, and host controllers
>> generally cannot support timeouts that long in any case.
>>
>> 2 seconds should be plenty of time for any card to actually function;
>> the timeout calculation code is already using 1 second as a "worst case"
>> timeout for cards running in SPI mode.
>
> Needs a 'Signed-off-by'.

Oops, sorry. I'm still getting used to the patch workflow. Will resend.

-- 
Torne (Richard Coles)
torne@google.com
