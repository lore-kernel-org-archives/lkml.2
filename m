Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2ILRmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:42:13 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:58191 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753641Ab2ILRmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:42:09 -0400
Message-ID: <5050C94F.4060403@xenotime.net>
Date: Wed, 12 Sep 2012 10:41:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow gpiolib to be a module
References: <504DF63A020000780009A30B@nat28.tlf.novell.com> <CACRpkdbCmou3wTXJjPhSaCH0kH1VrU5n-9t7NTJOjFQs1xH+cA@mail.gmail.com> <50505959020000780009AC53@nat28.tlf.novell.com>
In-Reply-To: <50505959020000780009AC53@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 12:43 AM, Jan Beulich wrote:

>>>> On 11.09.12 at 19:38, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Mon, Sep 10, 2012 at 2:16 PM, Jan Beulich <JBeulich@suse.com> wrote:
>>> +#ifndef MODULE
>>>  subsys_initcall(gpiolib_debugfs_init);
>>> +#endif
>>>
>>>  #endif /* DEBUG_FS */
>>> +
>>> +#ifdef MODULE
>>> +int __init gpiolib_init(void)
>>> +{
>>> +       return gpiolib_sysfs_init() ?: gpiolib_debugfs_init();
>>
>> I can't parse this, sorry the gpio subsystem maintainer is too bad coder.
>> What about something more readable?
>>
>> int ret;
>>
>> ret = gpiolib_sysfs_init();
>> if (ret)
>>    return ret;
>> return gpiolib_debugfs_init();
>>
>> I know it doesn't look as cool but it's easier for me to understand.
> 
> Okay, since you're the second one to complain despite there
> being other uses of the construct in the same source file, I'll
> replace it, ...


Does C just use the value generated from the left side of a ?:
expression for the middle (empty) expression or does it call the
function again (which would usually be bad)?


-- 
~Randy
