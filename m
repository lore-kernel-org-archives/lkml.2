Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1FBQLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 12:11:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44101 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab1FBQL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 12:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bQxkJ6E1Pi/7h2Zh7Kn7Jlba0PCU7MLLFkcJVBSUZj8KgAmnBDnytGvTP3UU20bj+j
         W6Wz+t5UqvKT02biz+oFtscVV2gLp/OPgYZwfZQ85KQFIGQFNMQgw050A31HNpoXuwTB
         //O1yFWWSj02wPJXbCOThVHV029ZvNSM6G30c=
MIME-Version: 1.0
In-Reply-To: <33745.1307019429@turing-police.cc.vt.edu>
References: <1306991354-11890-1-git-send-email-eric.y.miao@gmail.com> <33745.1307019429@turing-police.cc.vt.edu>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 3 Jun 2011 00:10:14 +0800
Message-ID: <BANLkTim3tUE9B_QzsS6zvUmZwR4ts8Z3ZA@mail.gmail.com>
Subject: Re: [PATCH] leds: fix the menuconfig being wrongly displayed
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 8:57 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 02 Jun 2011 13:09:14 +0800, Eric Miao said:
>> From: Eric Miao <eric.miao@canonical.com>
>>
>> Seems when a config option does not have a dependency of the menuconfig,
>> it messes the display of the rest configs, even if it's a hidden one.
>>
>> Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>  drivers/leds/Kconfig |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>> index 23f0d5e..7066820 100644
>> --- a/drivers/leds/Kconfig
>> +++ b/drivers/leds/Kconfig
>> @@ -7,6 +7,8 @@ menuconfig NEW_LEDS
>>         This is not related to standard keyboard LEDs which are controlled
>>         via the input system.
>>
>> +if NEW_LEDS
>> +
>>  config LEDS_CLASS
>>       bool "LED Class Support"
>>       depends on NEW_LEDS
>
> Having added that 'if', do we still need that 'depends'?
>

I don't think so. We can definitely remove it. Updated as follows:

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 23f0d5e..1251e6a 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -7,9 +7,10 @@ menuconfig NEW_LEDS
          This is not related to standard keyboard LEDs which are controlled
          via the input system.

+if NEW_LEDS
+
 config LEDS_CLASS
        bool "LED Class Support"
-       depends on NEW_LEDS
        help
          This option enables the led sysfs class in /sys/class/leds.  You'll
          need this to do anything useful with LEDs.  If unsure, say N.
@@ -21,8 +22,6 @@ config LEDS_GPIO_REGISTER
          As this function is used by arch code it must not be compiled as a
          module.

-if NEW_LEDS
-
 comment "LED drivers"

 config LEDS_88PM860X
