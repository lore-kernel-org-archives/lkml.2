Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2ILHnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:43:02 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60180 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2ILHnA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 12 Sep 2012 03:43:00 -0400
Message-Id: <50505959020000780009AC53@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 12 Sep 2012 08:43:53 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Linus Walleij" <linus.walleij@linaro.org>
Cc: "Grant Likely" <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow gpiolib to be a module
References: <504DF63A020000780009A30B@nat28.tlf.novell.com>
 <CACRpkdbCmou3wTXJjPhSaCH0kH1VrU5n-9t7NTJOjFQs1xH+cA@mail.gmail.com>
In-Reply-To: <CACRpkdbCmou3wTXJjPhSaCH0kH1VrU5n-9t7NTJOjFQs1xH+cA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.09.12 at 19:38, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Sep 10, 2012 at 2:16 PM, Jan Beulich <JBeulich@suse.com> wrote:
>> +#ifndef MODULE
>>  subsys_initcall(gpiolib_debugfs_init);
>> +#endif
>>
>>  #endif /* DEBUG_FS */
>> +
>> +#ifdef MODULE
>> +int __init gpiolib_init(void)
>> +{
>> +       return gpiolib_sysfs_init() ?: gpiolib_debugfs_init();
> 
> I can't parse this, sorry the gpio subsystem maintainer is too bad coder.
> What about something more readable?
> 
> int ret;
> 
> ret = gpiolib_sysfs_init();
> if (ret)
>    return ret;
> return gpiolib_debugfs_init();
> 
> I know it doesn't look as cool but it's easier for me to understand.

Okay, since you're the second one to complain despite there
being other uses of the construct in the same source file, I'll
replace it, ...

> There is a bug too: I don't think this compiles if you compile as
> a module but disable debugfs. Try it out.

... the more to get this one fixed. Will re-submit.

>> +}
>> +module_init(gpiolib_init);
>> +
>> +MODULE_DESCRIPTION("GPIO library");
>> +MODULE_LICENSE("GPL");
> 
> These two things don't really need to be inside an #ifdef
> right?

They don't need to be, but since we need a conditional now
anyway, it seemed reasonable to include these in there too.

Jan

