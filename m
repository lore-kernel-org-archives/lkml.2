Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1HAPaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:30:55 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42896 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab1HAPat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:30:49 -0400
Message-ID: <4E36C693.6000705@lwfinger.net>
Date: Mon, 01 Aug 2011 10:30:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Jaroslaw Fedewicz <jafd@netstyle.com.ua>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [Bug?] Machine hangs, rtl8192se possible cause
References: <CAFdoEiT54o+NQKO=dAcOXgyf6GJ1E51w_H_p7PJyRmynz8Sbzg@mail.gmail.com>
In-Reply-To: <CAFdoEiT54o+NQKO=dAcOXgyf6GJ1E51w_H_p7PJyRmynz8Sbzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2011 08:26 AM, Jaroslaw Fedewicz wrote:
> Hello,
>
> I own a Thinkpad Edge 13 (AMD, machine type 0197) laptop, which is
> shipped with a Realtek 8192 SE WLAN card.
>
> The WLAN support with this particular card was never brilliant under
> Linux, first with (very) flakey drivers from Realtek which would stop
> transmitting packets every so often or panic after a few hours of
> usage. The in-tree drivers are better in this respect, but I'm
> experiencing mysterious hangups every once in a while. The machine is
> effectively dead and has to be power-cycled — no oops, no kernel
> panic, no nothing, it just hangs and that's it.
>
> I'm sure this is not a regression because the hangups were right there
> from the start.
>
> The last meaningful message which might be helpful was: "wait for
> BIT(6) return value X" (I don't remember what X was, it was a while
> ago and only once).
>
> I don't know if there are other means to debug (netconsole over eth0?)
> those hangs. The only other thing I know for sure that I can get a
> week long uptime if I blacklist rtl8192se.ko from loading.
>
> If I can provide any additional information to track the bug (or a
> faulty piece of hardware?) down, please tell me. Google tells me
> nobody reported this before, or it was just me feeding incorrect
> keywords.
>
> Thanks for your kind attention.
>
> P. S. Tried netconsole before, got nothing to pinpoint the error. The
> only recurring pattern I could see in it was that almost every time
> the machine hanged was after ip6tables initialized, at least it was
> the last message in the log.
>
> P. P. S. I don't track netdev@ and linux-wireless@ lists, so please Cc: me.

What kernel are you using? The only problems I've had were some kernel panics 
due to improper handling of memory allocation failures with the receive skb's, 
but they have been fixed.

It can be difficult to use netconsole to debug problems with wireless devices.

As you prevent rtl8192se from loading automatically, the logging console may 
provide some clues. Use the following command to load the driver:

sleep 10 ; modprobe rtl8192se

During the 10 second sleep, use CTRL-ALT-F10 to switch consoles and see if any 
messages appear.

Please use 'lspci -nn' to determine which version of the card you have.

Thanks,

Larry
