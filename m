Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934267Ab1ESSx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:53:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41041 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933895Ab1ESSxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YTxlbaWbRjFaplDZlHQ3q5bU/WqJDJC9ZXE5z70aq5HIGyudd52VL4aTs+qljfoJ5g
         Cki1hWCyjV+txJPq6OrXC0kQk/nLApDNtmxW4/ZG8V1uwFIFRsEiqfLjauEOyGVdxGq2
         rFn8nHtB/vGoLKdRV87XBuxEaj1GrXoi1ybnw=
MIME-Version: 1.0
In-Reply-To: <20110519182753.GA23865@suse.de>
References: <BANLkTikwjL-3m110CcRs+-KLdZpH0rOTsQ@mail.gmail.com>
	<20110519182753.GA23865@suse.de>
Date: Thu, 19 May 2011 20:53:53 +0200
Message-ID: <BANLkTi=5HHCVUANbqJWQe7wZKVPBqM6RrQ@mail.gmail.com>
Subject: Re: samsung-laptop backlight control not working
From: David Herrmann <dh.herrmann@googlemail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 8:27 PM, Greg KH <gregkh@suse.de> wrote:
> On Thu, May 19, 2011 at 08:18:16PM +0200, David Herrmann wrote:
>> Hi
>>
>> I tried the new samsung-laptop driver with samsung backlight support.
>
> What kernel are you trying?  We have some recent patches to the driver
> to try to resolve some of these issues on your laptop.

I use linus' tree. 2.6.39

>> It is detected as:
>> [109282.931433] samsung_laptop: found laptop model 'N150P/N210P/N220P'
>>
>> However, backlight support is kind of weird:
>> "echo 1 >/sys/class/backlight/samsung/brightness"
>> does not set brightness to 1 but instead reduces brightness for 1.
>> That is, if my current brightness setting is 8, I need to call "echo 1
>> >..." 7 times to get brightness value 1.
>>
>> "cat /sys/class/backlight...."
>> returns 1 after the first try, though.
>>
>> "echo 3 >..."
>> reduces brightness also for 1 but stops at brightness level 3 if I
>> repeat the command.
>>
>> dmesg shows the following for every "echo" I call:
>> [110690.073783] ACPI: Failed to switch the brightness
>>
>> Furthermore "echo 0 >..." doesn't disable backlight but instead
>> behaves like a brightness setting below 1.
>
> Yeah, don't echo 0 there, that doesn't work to well.  I have some
> patches here that you can try if you want, just let me know.

That would be great! I have really no idea about acpi so I can't fix
it myself. If you could give me some git tree where I can find them, I
could test them.

>> However, I know the following works on my machine:
>> setpci -s 00:02.0 F4.B=255
>> It accepts a setting between 0-255 and 255 is full brightness and 0 is
>> backlight off.
>
> Don't do that, the video driver will not like you as you are changing
> things without telling the bios that something is really happening.
>
> Of course you can continue to do this, it's just strongly not
> recommended.

Ouh, I didn't know that. It was recommended in some distro wiki so I
tried it and it worked. Anyway, I thought it might give you some
information about the N210 model.

> thanks,
>
> greg k-h

Thanks
David
