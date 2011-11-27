Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab1K0J2U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:28:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43287 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1K0J2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:28:18 -0500
Date: Sun, 27 Nov 2011 03:28:08 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        Armin Kazmi <armin.kazmi@tu-dortmund.de>, Gerd <booster@wolke7.net>
Subject: Re: [bug?] r8169: hangs under heavy load
Message-ID: <20111127092808.GE21635@elie.hsd1.il.comcast.net>
References: <4E82C0B5.1050902@wolke7.net>
 <1317254171.4068.12.camel@deadeye>
 <20111124044137.GA18262@elie.hsd1.il.comcast.net>
 <4ECFE7A7.5070300@wolke7.net>
 <20111125201936.GA26692@elie.hsd1.il.comcast.net>
 <1322253122.2550.3.camel@edumazet-laptop>
 <20111125222211.GA13719@electric-eye.fr.zoreil.com>
 <1322262357.2550.12.camel@edumazet-laptop>
 <20111126004447.GA14744@electric-eye.fr.zoreil.com>
 <1322280423.10212.3.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1322280423.10212.3.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Le samedi 26 novembre 2011 à 01:44 +0100, Francois Romieu a écrit :

>> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
>> index 6f06aa1..54be9e1 100644
>> --- a/drivers/net/ethernet/realtek/r8169.c
>> +++ b/drivers/net/ethernet/realtek/r8169.c
>> @@ -5820,8 +5820,7 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
>>  			case RTL_GIGA_MAC_VER_11:
>>  			case RTL_GIGA_MAC_VER_22:
>>  			case RTL_GIGA_MAC_VER_26:
>> -				netif_stop_queue(dev);
>> -				rtl8169_tx_timeout(dev);
>> +				rtl8169_schedule_work(dev, rtl8169_reset_task);
>>  				goto done;
>>  			/* Testers needed. */
>>  			case RTL_GIGA_MAC_VER_17:
>
> Please Jonathan, Gerd, try this fix !

Thanks, Eric.  Unfortunately I don't have the hardware.

Gerd, would you be able to try this patch?  It works like this:

  apt-get install git build-essential
  git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  cd linux
  ... apply the fix, for example using "patch -p1" ...
  make localmodconfig; # minimal configuration
  make deb-pkg
  dpkg -i ../<name of package>
  reboot

Feel free to email me privately if you have any questions.

Regards,
Jonathan
