Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965699Ab2DLSLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:11:16 -0400
Received: from nbd.name ([46.4.11.11]:48587 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926Ab2DLSLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:11:15 -0400
Message-ID: <4F871AB8.3070302@openwrt.org>
Date: Thu, 12 Apr 2012 20:11:04 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Michael Leun <ml@elektra.leun.net>
CC: Felipe Contreras <felipe.contreras@gmail.com>,
        Michael Leun <lkml20120218@newton.leun.net>,
        Mohammed Shafi <shafi.wireless@gmail.com>,
        Ben Greear <greearb@candelatech.com>, casteyde.christian@free.fr,
        Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sergio Correia <lists@uece.net>
Subject: Re: 3.4-rc ath9k regression (Re: [ath9k-devel] 3.3.1 ath9k regression)
References: <4F7A8EB7.4060200@silka.with-linux.com> <CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com> <4F7AB6FE.3080009@silka.with-linux.com> <20120403200306.0afbb48b@xenia.leun.net> <CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com> <CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com> <20120404235104.682cfad3@xenia.leun.net> <4F7DE3A4.1040705@candelatech.com> <CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com> <4F7F52BD.7060906@candelatech.com> <20120409010816.36244f17@xenia.leun.net> <CAD2nsn3-C8ZLmUpTDeA6HuPr-+=V5KkPJb6h5e7ZJsGi4v9p0g@mail.gmail.com> <20120409122549.7469543a@xenia.leun.net> <20120409160322.6b7b8c67@xenia.leun.net> <CAD2nsn0n-VQ8ZOm69BNrbFv5HK3cdm+22yKrYprwoeFz-E2Uew@mail.gmail.com> <20120409172933.4ca4775a@xenia.leun.net> <4F86DCB1.20507@openwrt.org> <CAMP44s1t+kVdRi_zhR1Qt045KEwco_PQhpa-cC9zMWc5QOFA8Q@mail.gmail.com> <20120412173518.2ecd8418@xenia.leun.net>
In-Reply-To: <20120412173518.2ecd8418@xenia.leun.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-12 5:35 PM, Michael Leun wrote:
> On Thu, 12 Apr 2012 16:58:34 +0300
> Felipe Contreras <felipe.contreras@gmail.com> wrote:
> 
>> On Thu, Apr 12, 2012 at 4:46 PM, Felix Fietkau <nbd@openwrt.org>
>> wrote:
>> > On 2012-04-09 5:29 PM, Michael Leun wrote:
>> >> On Mon, 9 Apr 2012 19:52:45 +0530
>> 
>> >> Seems obvious to me, that this line
>> >>
>> >> if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
>> >>
>> >> makes the real difference.
>> > Please try this patch with plain 3.3.1 or 3.4-rc2 to see if it fixes
>> > this issue:
>> 
>> Nope, not here (3.3.1).
> 
> Also negative for 3.4-rc2, but that SLEEP<>AWAKE noise at the end
> stopped. Still need "iwconfig wlan0 essid <myssid>" to make it ping
> again (that not included in log below).
OK, so my fix is definitely worth submitting, since it gets rid of some
unnecessary sleep mode transitions. About the iwconfig command: are you
not using wpa_supplicant?

> Due to Felipes result and 3.4-rc2 didn't repeat my test with 3.3.1, if
> you think it would add useful information I could.
Maybe it would be useful to get some more detailed logs from that.

- Felix
