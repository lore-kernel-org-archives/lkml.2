Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab1GZGjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:39:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48959 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1GZGjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:39:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E2E6102.3060600@jp.fujitsu.com>
Date: Tue, 26 Jul 2011 15:38:58 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: yong.zhang0@gmail.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kobayashi.kk@ncos.nec.co.jp
Subject: Re: [PATCH] proc/softirqs: only show state for online cpus
References: <1311599418-1915-1-git-send-email-yong.zhang0@gmail.com> <4E2E507F.7030607@jp.fujitsu.com> <CAM2zO=CGkVCMNZS8F6LxFi-NdYXf0fDLB_AEc00xrPvO_D02qw@mail.gmail.com>
In-Reply-To: <CAM2zO=CGkVCMNZS8F6LxFi-NdYXf0fDLB_AEc00xrPvO_D02qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/26 15:14), Yong Zhang wrote:
> 2011/7/26 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
>>> Like /proc/interrupts, no need to output data for nobody.
>>>
>>> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
>>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> If the cpu never be onlined, its statistics always 0. Then, it definitely
> 
> Yeah, so your screen may contain noise.

One question. Is this big matter?
Who see /proc/softirqs and /proc/interrupts directly? (i.e. by 'cat' command).


>> no value. In the other hand, if the cpu was offlined dynamically, we don't
>> know the user want to know the cpus's statistics or not.
> 
> Same to /proc/interrupts :)
> 
> IMHO, if user want to check the value of offline-cpu, maybe that means
> he want to check the state of the whole system, /proc/stat should be the
> right choice. /proc/{softirqs,interrupts} is just for immediate state.
>
>> Anyway, it's incompatibility change.
> 
> Yup, I should have marked the patch with RFC :)

And I should have remarked I don't dislike this patch so strongly, so
if kobayashi-san who original /proc/softirqs author ack you, I'm going
to second him.


Offtopic, /proc/interrupt should be protected by get_online_cpus().
Otherwise the header (i.e. cpu number) and the actual statistics fields
can be mismatched likes following. Am I missing something?

           CPU0       CPU1       CPU2
  0:   14286646   14747155          0   IO-APIC-edge      timer
  1:          6          6   IO-APIC-edge      i8042

                                 ^
                                 |
                               cpu2 was offlined dynamically at the same time.



