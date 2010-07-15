Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab0GOAqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:46:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56591 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab0GOAn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WhnDvRmVh8/zgAyoVKR1Nw6Fn6gtTheaV4yWXe+GpW9in8ZTT0X4qCY91C43fzvk1n
         nHkNTpqdas5uVHgbHxdDO6GdZRbMAIc7yJUi78Fh/+mUblNfVt/j7JIe4MMZ9Do7rigS
         3KU+RQA7UTZQ3xqbcN4oreHHdajfuylkiFDkQ=
Message-ID: <4C3E59CD.7050901@lwfinger.net>
Date: Wed, 14 Jul 2010 19:43:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bugzilla # 16395: Regression in 2.6.35-rc4 since commit 0b28bac5aef7bd1ab213723df031e61db9ff151a
 on HP Mini 110 Netbook
References: <4C3E4F2F.3090404@lwfinger.net> <201007141707.37234.dmitry.torokhov@gmail.com>
In-Reply-To: <201007141707.37234.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 07:07 PM, Dmitry Torokhov wrote:
> On Wednesday, July 14, 2010 04:58:39 pm Larry Finger wrote:
>> Since the commit in the title, a kernel built on an HP Mini 110 Netbook no
>> longer has keyboard input. The main difference is that CONFIG_SERIO_I8042
>> is no longer defined. When this equal yes, the keyboard works. The faulty
>> commit was located by bisection and has been verified by reverting the
>> patch.
>>
>> Further investigation shows that the faulty hunk is
>>
>> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
>> index 3bfe8fa..256b9e9 100644
>> --- a/drivers/input/serio/Kconfig
>> +++ b/drivers/input/serio/Kconfig
>> @@ -22,7 +22,7 @@ config SERIO_I8042
>>           tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
>>           default y
>>           depends on !PARISC&&  (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST)&&  \
>> -                  (!SUPERH || SH_CAYMAN)&&  !M68K&&  !BLACKFIN
>> +                  (!SUPERH || SH_CYes, AYMAN)&&  !M68K&&  !BLACKFIN&&
>> !X86_MRST help
>>             i8042 is the chip over which the standard AT keyboard and PS/2
>>             mouse are connected to the computer. If you use these devices,
>>
>> Reverting this one hunk alone results in a working system. Obviously, this
>> Netbook does not have X86_MRST set.
>
>
> You meant to say "does have CONFIG_X86_MRST set", right?

Yes. I got lost in the negative logic. Since !X86_MRST is false, then X86_MRST 
has to be defined. In fact, .config has CONFIG_X86_MRST=y.

Larry


