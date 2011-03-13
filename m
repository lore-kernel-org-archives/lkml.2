Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1CMKD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:03:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50204 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab1CMKDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=I+DBEbMSQdH6a4JgXTvRjTOj6V/PZKLvViP2YGr50oQyldULyV46Ta8qoQ1V4jN+N/
         AeB3JRSCihtG5G8G9/I5yVx5hqbOK5aekq9Vc5Ft8UfFpsEsNB1Cd8uKslsmvzts2Y80
         3kGGYoLS5KN8nrDyMLP8/NVDhWYVI9QOxZooE=
Message-ID: <4D7C9668.3000902@gmail.com>
Date: Sun, 13 Mar 2011 12:03:20 +0200
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
References: <20110310171940.GA24972@kroah.com> <4D790A20.3050105@gmail.com> <20110310180959.GA26927@kroah.com> <4D793D05.3070908@gmail.com> <20110310211519.GA11862@kroah.com> <4D79CB47.2030405@gmail.com> <20110311170313.GA10202@kroah.com> <4D7A72E3.1050407@gmail.com> <20110311193433.GB14204@kroah.com> <4D7A8419.6080107@gmail.com> <20110311203032.GA14384@kroah.com>
In-Reply-To: <20110311203032.GA14384@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 03/11/2011 10:30 PM, Greg KH wrote:
> You can also go into the /sys/class/backlight/samsung/ directory and
> mess with the backlight values in the files to see if it gets brighter
> and dimmer.  If that works, then the driver is working properly.
Thanks :)
I see some strange behavior, though.

Every time I execute this in the /sys/class/backlight/samsung directory:
sudo bash -c 'echo 1 > brightness'
brightness is reduced a little until it reaches the minimum.

After that, every time I execute this:
sudo bash -c 'echo 8 > brightness'
it increases a little until it reaches the maximum.

And each time a message appears in dmesg: "ACPI: Failed to switch the
brightness", until the brightness stops changing.

At the same time, the little Gnome brightness adjustment window appears,
showing the percentage of the brightness, which drops/raises to
minimum/maximum in only four executions of these commands. After that, while
brightness drops/raises with each execution, the percentage stays at
minimum/maximum.

Is this all normal?

Also, brightness buttons seem to invoke the Gnome brightness percentage
window, which shows it changing, but the brightness itself doesn't change.
Is it also normal? If so, is it solved in the newer Gnome and is it what you
tried to tell me before?

Sometime ago I've found this hack on some forum, which I use currently
to set the brightness:

setpci -s 00:02.0 f4.b="$HEX_BYTE"

It allows finer control of the brightness, but it seems it operates directly
on the video card PCI register. I assume there is no sane way to use
this interface from the platform driver, right?

Then, does the wireless on/off button require gnome support too?

Thank you very much :)

Sincerely,
Nick
