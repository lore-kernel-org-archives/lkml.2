Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1B0Q0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:26:01 -0500
Received: from 75-145-127-229-Colorado.hfc.comcastbusiness.net ([75.145.127.229]:55464
	"EHLO gw.co.teklibre.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752076Ab1B0QZ7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:25:59 -0500
From: d@taht.net (Dave =?utf-8?Q?T=C3=A4ht?=)
To: sedat.dilek@gmail.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
        bloat-devel@lists.bufferbloat.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ANNOUNCE: debloat-testing kernel git tree
Organization: Teklibre - http://www.teklibre.com
References: <20110225222210.GA3618@tuxdriver.com>
	<AANLkTingkcc-dvs_8Nr0vYXdXvuDHEn6sz14tnHzLp8W@mail.gmail.com>
	<87fwr9jxya.fsf@cruithne.co.teklibre.org>
	<AANLkTinpG-xAC-VV-j7EBJB522+BqCyyFd_6N3KEr2Cf@mail.gmail.com>
	<8739n9ii7z.fsf@cruithne.co.teklibre.org>
	<AANLkTi=Cp7N4xqPyU6KWF6DOzFytxaA2BeoXhnhsZ6dp@mail.gmail.com>
Date: Sun, 27 Feb 2011 09:25:56 -0700
In-Reply-To: <AANLkTi=Cp7N4xqPyU6KWF6DOzFytxaA2BeoXhnhsZ6dp@mail.gmail.com>
	(Sedat Dilek's message of "Sun, 27 Feb 2011 17:01:27 +0100")
Message-ID: <87tyfph2az.fsf@cruithne.co.teklibre.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@googlemail.com> writes:

> On Sun, Feb 27, 2011 at 4:56 PM, Dave Täht <d@taht.net> wrote:
>> Sedat Dilek <sedat.dilek@googlemail.com> writes:
>>
>>> On Sun, Feb 27, 2011 at 4:31 PM, Dave Täht <d@taht.net> wrote:
>>>>
>>>> Sedat Dilek <sedat.dilek@googlemail.com> writes:
>>
>>> Are you planning debloat feature for 2.6.39?
>>
>> Depends on how many testers we get and what the results are.
>>
>> I feel the eBDP stuff will not be ready during this release cycle. SFB
>> and CHOKe are in net-next, so, probably. Various driver patches -
>> particularly those that increase the available dynamic range via
>> ethtool, (e.g lowering the bottommost TX queue limit to, like, 4,
>> especially for home gateways) may make it out if people look harder into
>> the issue.
>
> OK, thanks for the explanations.
>
> Concerning "more drivers":
> What would I have to do to modify ath5k?
> I looked into the ath9k patch in debloat-testing GIT and it was to mod
> some (TX/BUF) values only.

Yes, reducing your TX buffer size greatly is the first, best, and
easiest patch.

For wireless routers and cable home gateways especially, this research
shows that the total un-managed buffers in your system should be less
than 32.

http://www.cs.clemson.edu/~jmarty/papers/PID1154937.pdf

I found their data convincing, and there are dozens of other papers that
we are sorting out on the bufferbloat.net web site.

(PLEASE Note the key word there is un-managed)

0 would be the best value. :/

In the case of wireless, you also have retries to take into account.
I'd argue in those cases, that what I say above is that the number
should be FAR less than 32.

Now, whether there is a good compromise between throughput and latency
in that range in a DMA TX queue + TXQUEUE, remains to be seen. 

> Not sure if ath9k is/was "well" prepared or only a good choice by the
> testers/committers as they own such a device.

My test network is mostly ath9k - the nanostation M5s and the WNDR5700
router described here:

http://www.bufferbloat.net/projects/bloat/wiki/Experiment_-_Bloated_LAGN_vs_debloated_WNDR5700

There are people looking into the ath6kl, but you're the first to step
up with the ath5k. :) Maybe the folk over at #ath6kl on irc can help.

The ath9k patch improves latency under load enormously - I can run voip
over it AND do big transfers and stream audio via samba... Which I
couldn't before - and DNS, ND, NTP, babel, etc behave much better, but
the currently hard coded nature of the TX queue limit does put an upper
limit on packet aggregation that the eBDP folk are trying to resolve
more generically.

In practice, at "normal" 180Mbit rates, with the new queue depth of 3, I
get most of the benefits of packet aggregation without the lag.

I do see higher packet loss than I would like, at present.

>
> - Sedat -

-- 
Dave Taht
http://nex-6.taht.net
