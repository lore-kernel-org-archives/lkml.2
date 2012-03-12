Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab2CLC2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 22:28:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59220 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab2CLC2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 22:28:35 -0400
MIME-Version: 1.0
In-Reply-To: <4F5D5D90.8020401@gmail.com>
References: <4F5D4C4E.1060800@gmail.com> <CAGRGNgX-RDRFNXKTXf=qw7h4bQNypHx0Hgvjd7rvXu9T43f4WQ@mail.gmail.com>
 <4F5D5D90.8020401@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 12 Mar 2012 13:28:14 +1100
Message-ID: <CAGRGNgX37DgMzbTjdhQ5LRD_6JwQi8tyN_6VVzYzwQ-KAat4jA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mac80211: improve PID rate control mechanism by
 avoiding rate oscillation problem
To: wei <yinwei168@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Mon, Mar 12, 2012 at 13:21, wei <yinwei168@gmail.com> wrote:
> Thank you, Julian.

No problem =)

> On 12/03/12 11:14, Julian Calaby wrote:
>>> @@ -271,14 +473,17 @@ rate_control_pid_get_rate(void *priv, st
>>>                info->control.rates[0].count =
>>>                        txrc->hw->conf.long_frame_max_tx_count;
>>>        else
>>> -               info->control.rates[0].count =
>>> -                       txrc->hw->conf.short_frame_max_tx_count;
>>> -
>>> +               info->control.rates[0].count = 2;
>> Should this be a constant or something? Why is this being set to 2?
>
> According to the principle of how PID works, the default FLR is 14% and it attempts to decrease the rate if the FLR is higher than 14%. Let us assume that the current FLR is 14%, Then the probability for two consecutive failed attempts should be 14% * 14% = 0.0196 = 1.96%. The probability is very low. So I think we should not try further retransmission at this rate and fall back as soon as possible. Another reason is that the number of probes at the proposed rate is set to MAX_PROBES = 3 in the implementation, which means we will have 6 attempts at the probing rate. If the current rate is the lowest, say 1 Mbit/s, in 120 ms (a rate adaptation period in PID), the maximum number of attempts is around 8--9. I think I should limit the number of probes within the maximum attempts that can be achieved in one rate adaptation period.
>
> We could switch back to the configured value. But I need to change the maximum number of probes, MAX_PROBES.

You should either use a constant (i.e. #define
PID_SHORT_FRAME_MAX_PROBES 2) or put this reasoning in a comment
there, otherwise people may question why you've set the count to 2.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
