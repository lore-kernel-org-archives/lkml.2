Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2CTFyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 01:54:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47299 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2CTFyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 01:54:10 -0400
Message-ID: <4F681B78.9000207@gmail.com>
Date: Mon, 19 Mar 2012 22:54:00 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Linux-wireless <linux-wireless@vger.kernel.org>
CC: Felix Fietkau <nbd@openwrt.org>, Mohammed Shafi <shafi.wireless@gmail.com>,
        linux-kernel@vger.kernel.org, Linux-netdev <netdev@vger.kernel.org>
Subject: Re: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
 DMADBG_7=0x00008040
References: <4F576FD5.2050208@gmail.com> <CAD2nsn23UqshHz1ZUn8bHN0rWyOMbBHhn9V8pmCc4_aT_uGYaw@mail.gmail.com> <4F577D9B.7020402@gmail.com> <4F579A88.6030503@openwrt.org> <4F61F551.5010608@gmail.com> <4F639851.5080500@gmail.com> <4F674616.8080103@gmail.com> <CAD2nsn3xpkGenrK50YmE5D7Odg3sBEek5zKcLZF6MAm69p5RJg@mail.gmail.com> <4F674FF5.2060406@gmail.com> <4F6751B2.1030809@openwrt.org>
In-Reply-To: <4F6751B2.1030809@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 08:33 AM, Felix Fietkau wrote:
> On 2012-03-19 4:25 PM, Justin P. Mattock wrote:
>> On 03/19/2012 08:20 AM, Mohammed Shafi wrote:
>>> Hi Justin,
>>>
>>>> seems I got this when waking up from suspend, was trying to connect with NM
>>>> then all of a sudden Xorg shut off and this appeared on the screen(image
>>>> links below I could not save dmesg only pic)
>>>> http://flic.kr/p/bEhf2K
>>>> http://flic.kr/p/bEhf2x
>>>> http://flic.kr/p/bEhf2n
>>>> http://flic.kr/p/bEhf26
>>>>
>>>> I see ath9k in the image, but am unsure if its related.
>>>> kernel is: 3.3.0-rc7-next-20120316
>>>
>>> this looks like some new issue  in ath9k, lets try to recreate it here
>>>
>>>>
>>>> Justin P. Mattock
>>>>
>>>>
>>>>
>>>
>>>
>>>
>>
>> would be nice to recreate, then bisecting will be more accurate to do..
>> I am trying userspace tweaks here and there but no luck(hostapd etc..)
>> keep in mind this is for the RX DMA, the above just occured..
>> as for writing a small app I still need to try, but my C skills only go
>> so far(anything to trigger!).
> Was your kernel compiled with debug info? If so, please run gdb on the
> ath9k.ko module and enter this:
> l *ath9k_tx+start+0x284
> Then send me the output of that.
>
> - Felix
>

I changed the Cc''s so hopefully its correct..
  anyway I tried the above but might have gotten it wrong..:

Reading symbols from 
/home/kernel/linux-next/drivers/net/wireless/ath/ath9k/ath9k.o...done.
(gdb) list *ath9k_tx+0xa3
0x4673 is in ath9k_tx (drivers/net/wireless/ath/ath9k/main.c:1136).
1131		memset(&txctl, 0, sizeof(struct ath_tx_control));
1132		txctl.txq = sc->tx.txq_map[skb_get_queue_mapping(skb)];
1133	
1134		ath_dbg(common, XMIT, "transmitting packet, skb: %p\n", skb);
1135	
1136		if (ath_tx_start(hw, skb, &txctl) != 0) {
1137			ath_dbg(common, XMIT, "TX failed\n");
1138			goto exit;
1139		}
1140	
(gdb) list *ath9k_tx+start+0x284
No symbol "start" in current context.

before receiving the email to do the above code with gdb I had cleaned 
the tree out with git clean -fx so rebuilding might have misalighned 
things(but could be wrong)..

