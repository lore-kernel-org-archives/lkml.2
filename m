Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034Ab2CTGgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 02:36:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35163 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2CTGgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 02:36:11 -0400
Message-ID: <4F682555.3020502@gmail.com>
Date: Mon, 19 Mar 2012 23:36:05 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: Linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, linux-kernel@vger.kernel.org,
        Linux-netdev <netdev@vger.kernel.org>
Subject: Re: ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
 DMADBG_7=0x00008040
References: <4F576FD5.2050208@gmail.com> <CAD2nsn23UqshHz1ZUn8bHN0rWyOMbBHhn9V8pmCc4_aT_uGYaw@mail.gmail.com> <4F577D9B.7020402@gmail.com> <4F579A88.6030503@openwrt.org> <4F61F551.5010608@gmail.com> <4F639851.5080500@gmail.com> <4F674616.8080103@gmail.com> <CAD2nsn3xpkGenrK50YmE5D7Odg3sBEek5zKcLZF6MAm69p5RJg@mail.gmail.com> <4F674FF5.2060406@gmail.com> <4F6751B2.1030809@openwrt.org> <4F681B78.9000207@gmail.com> <CAD2nsn0d-3edYGH8u+v5mhrUZBMsznDNRDkDHE-tErG8uGk84Q@mail.gmail.com> <4F68235C.5090701@gmail.com> <CAD2nsn0toAjyWw48J7oREES0=x6D72hMntP+WpAjHmR5drd-tQ@mail.gmail.com>
In-Reply-To: <CAD2nsn0toAjyWw48J7oREES0=x6D72hMntP+WpAjHmR5drd-tQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 11:32 PM, Mohammed Shafi wrote:
> On Tue, Mar 20, 2012 at 11:57 AM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> On 03/19/2012 11:19 PM, Mohammed Shafi wrote:
>>>>
>>>> (gdb) list *ath9k_tx+start+0x284
>>>> No symbol "start" in current context.
>>>
>>>
>>> hey, pls try l *(ath9k_tx_start+0x284), yesterday i did the same in
>>> the latest wireless testing tree it pointed to line 1929 of xmit.c
>>>
>>> sc->tx.seq_no +=0x10;
>>>
>>> also did few suspend/resume in my machine, nothing interesting happened
>>>
>>>>
>>>> before receiving the email to do the above code with gdb I had cleaned
>>>> the
>>>> tree out with git clean -fx so rebuilding might have misalighned
>>>> things(but
>>>> could be wrong)..
>>>>
>>>
>>>
>>>
>>
>>
>> seems gdb is not working with that code but works if I remove _start.
>> (maybe -next took this out or something)
>>
>> (gdb) l *(ath9k_tx_start+0x284)
>> No symbol "ath9k_tx_start" in current context.
>
> sorry its
>   l *(ath_tx_start+0x284)
>
>> (gdb) l *(ath9k_tx+0x284)
>> 0x4854 is in ath_paprd_activate (drivers/net/wireless/ath/ath9k/main.c:395).
>> 390                             continue;
>> 391
>> 392                     ar9003_paprd_populate_single_table(ah, caldata,
>> chain);
>> 393             }
>> 394
>> 395             ar9003_paprd_enable(ah, true);
>> 396             ath9k_ps_restore(sc);
>> 397     }
>> 398
>> 399     static bool ath_paprd_send_frame(struct ath_softc *sc, struct
>> sk_buff *skb, int chain)
>>
>> right now I am running next, will wait for the RX DMA to get a clean trace,
>> then will look to see.. as for the other issue I just rebooted and hit this
>> during bootup.
>>
>> Justin P. Mattock
>
>
>

yeah this works:

eading symbols from 
/home/kernel/linux-next/drivers/net/wireless/ath/ath9k/ath9k.o...done.
(gdb) l *(ath_tx_start+0x284)
0xcad4 is in ath_tx_start (drivers/net/wireless/ath/ath9k/xmit.c:1878).
1873			ieee80211_is_data_qos(hdr->frame_control)) {
1874			tidno = ieee80211_get_qos_ctl(hdr)[0] &
1875				IEEE80211_QOS_CTL_TID_MASK;
1876			tid = ATH_AN_2_TID(txctl->an, tidno);
1877	
1878			WARN_ON(tid->ac->txq != txctl->txq);
1879		}
1880	
1881		if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && tid) {
1882			/*
(gdb)

