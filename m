Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2FSVyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 17:54:03 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:42865
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137Ab2FSVyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 17:54:01 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.228;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail01v.am.sony.com;RD:mail01.sonyusa.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI1432Izz1202hzzz2fh2a8h668h839hd25hf0ah)
Message-ID: <4FE0F4B3.5090705@am.sony.com>
Date: Tue, 19 Jun 2012 14:52:51 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rowand, Frank" <Frank_Rowand@sonyusa.com>
CC: Aaditya Kumar <aaditya.kumar.30@gmail.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "C.Emde@osadl.org" <C.Emde@osadl.org>,
        "jkacur@redhat.com" <jkacur@redhat.com>,
        "Bird, Tim" <Tim.Bird@am.sony.com>,
        "Ohara, Takuzo" <Takuzo.Ohara@ap.sony.com>,
        "Iibuchi, Kan (TDG)" <Kan.Iibuchi@jp.sony.com>
Subject: Re: [RFC][RT][PATCH] mm: Do not use stop_machine() for __zone_pcp_udpate()
 for CONFIG_PREEMPT_RT_FULL
References: <CAEtiSauEdKP3Jsi_O6Q=yc9AWkSKDvNrLe0faicQWJGqdKxLwg@mail.gmail.com> <4FE0D70F.2000607@am.sony.com>
In-Reply-To: <4FE0D70F.2000607@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/12 12:46, Frank Rowand wrote:
> Adding to the distribution list: the author of the patch that included
> the call to stop_machine() (commit 112067f0905b2de862c607ee62411cf47d2fe5c4).
> 
> On 06/19/12 11:32, Aaditya Kumar wrote:
>> The code path of __zone_pcp_update() has following locks, which in
>> CONFIG_PREEMPT_RT_FULL=y are rt-mutex.
>>   - pa_lock locked by cpu_lock_irqsave()
>>   - zone->lock locked by free_pcppages_bulk()
>>
>> Since __zone_pcp_update() is called from stop_machine(), so with

< snip >

... and just for the record, adding the author (Shaohua Li) did not
work, I got an email reject from Intel.

-Frank

