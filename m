Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2IMG71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:59:27 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49006 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2IMG7Z convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 13 Sep 2012 02:59:25 -0400
Message-Id: <5051A0A2020000780009AF6B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 13 Sep 2012 08:00:18 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Randy Dunlap" <rdunlap@xenotime.net>
Cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow gpiolib to be a module
References: <504DF63A020000780009A30B@nat28.tlf.novell.com>
 <CACRpkdbCmou3wTXJjPhSaCH0kH1VrU5n-9t7NTJOjFQs1xH+cA@mail.gmail.com>
 <50505959020000780009AC53@nat28.tlf.novell.com>
 <5050C94F.4060403@xenotime.net>
In-Reply-To: <5050C94F.4060403@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.09.12 at 19:41, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 09/12/2012 12:43 AM, Jan Beulich wrote:
>>>>> On 11.09.12 at 19:38, Linus Walleij <linus.walleij@linaro.org> wrote:
>>> On Mon, Sep 10, 2012 at 2:16 PM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> +       return gpiolib_sysfs_init() ?: gpiolib_debugfs_init();
>>>
>>> I can't parse this, sorry the gpio subsystem maintainer is too bad coder.
>>> What about something more readable?
>>>
>>> int ret;
>>>
>>> ret = gpiolib_sysfs_init();
>>> if (ret)
>>>    return ret;
>>> return gpiolib_debugfs_init();
>>>
>>> I know it doesn't look as cool but it's easier for me to understand.
>> 
>> Okay, since you're the second one to complain despite there
>> being other uses of the construct in the same source file, I'll
>> replace it, ...
> 
> 
> Does C just use the value generated from the left side of a ?:
> expression for the middle (empty) expression or does it call the
> function again (which would usually be bad)?

It's the purpose of omitting the middle expression to avoid the
second evaluation of that expression (and obviously the compiler
can't generally do this on its own when seeing the same
expression used twice).

Jan

