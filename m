Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1KHC6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 21:58:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52793 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1KHC6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 21:58:05 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4EB8044B.7020403@windriver.com>
References: <1320635954.10415.1.camel@phoenix> <1320636009.10415.2.camel@phoenix>
 <4EB8044B.7020403@windriver.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 8 Nov 2011 10:57:43 +0800
Message-ID: <CAF+7xWnQhfEzDMeWRAvrbxpUySEp6aUpO1BdAztcfH9Fuu=X_g@mail.gmail.com>
Subject: Re: [PATCH 2/2] mfd: include linux/module.h for ab5500-debugfs
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/8 Paul Gortmaker <paul.gortmaker@windriver.com>:
> On 11-11-06 10:20 PM, Axel Lin wrote:
>> Include linux/module.h to fix below build error:
>>
>>   CC      drivers/mfd/ab5500-debugfs.o
>> drivers/mfd/ab5500-debugfs.c:571: error: 'THIS_MODULE' undeclared here (not in a function)
>> make[2]: *** [drivers/mfd/ab5500-debugfs.o] Error 1
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>>  drivers/mfd/ab5500-debugfs.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/mfd/ab5500-debugfs.c b/drivers/mfd/ab5500-debugfs.c
>> index 6be1fe6..b7b2d348 100644
>> --- a/drivers/mfd/ab5500-debugfs.c
>> +++ b/drivers/mfd/ab5500-debugfs.c
>> @@ -4,6 +4,7 @@
>>   * Debugfs support for the AB5500 MFD driver
>>   */
>>
>> +#include <linux/module.h>
>
> This one looks incorrect.  I don't see any uses of MODULE_* or
> module_* in the file, so I'll make a commit for it to use export.h
> and retest.
>
hi Paul,
drivers/mfd/ab8500-debugfs.c does use MODULE_AUTHOR, MODULE_DESCRIPTION, etc.
I got below build error if only includes linux/export.h

  CC      drivers/mfd/ab8500-debugfs.o
drivers/mfd/ab8500-debugfs.c:632: error: expected declaration
specifiers or '...' before string constant
drivers/mfd/ab8500-debugfs.c:632: warning: data definition has no type
or storage class
drivers/mfd/ab8500-debugfs.c:632: warning: type defaults to 'int' in
declaration of 'MODULE_AUTHOR'
drivers/mfd/ab8500-debugfs.c:632: warning: function declaration isn't
a prototype
drivers/mfd/ab8500-debugfs.c:633: error: expected declaration
specifiers or '...' before string constant
drivers/mfd/ab8500-debugfs.c:633: warning: data definition has no type
or storage class
drivers/mfd/ab8500-debugfs.c:633: warning: type defaults to 'int' in
declaration of 'MODULE_DESCRIPTION'
drivers/mfd/ab8500-debugfs.c:633: warning: function declaration isn't
a prototype
drivers/mfd/ab8500-debugfs.c:634: error: expected declaration
specifiers or '...' before string constant
drivers/mfd/ab8500-debugfs.c:634: warning: data definition has no type
or storage class
drivers/mfd/ab8500-debugfs.c:634: warning: type defaults to 'int' in
declaration of 'MODULE_LICENSE'
drivers/mfd/ab8500-debugfs.c:634: warning: function declaration isn't
a prototype
make[2]: *** [drivers/mfd/ab8500-debugfs.o] Error 1
make[1]: *** [drivers/mfd] Error 2
make: *** [drivers] Error 2

Well, I don't know why I don't see these errors when I build the code last time.

Regards,
Axel
