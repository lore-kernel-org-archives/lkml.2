Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab2LJTJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:09:04 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:34467
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab2LJTJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:09:01 -0500
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail04.sonyusa.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh2a8h668h839h947hd25hf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1758h1765h1155h)
Message-ID: <50C63346.8000802@am.sony.com>
Date: Mon, 10 Dec 2012 11:08:54 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dipankar@in.ibm.com" <dipankar@in.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RT 2/2][RFC] let RCU stall messages escape with CONFIG_PREEMPT_RT_FULL
References: <50BED1DA.7070907@am.sony.com> <50BED305.9090308@am.sony.com> <20121210142914.GP2516@linux.vnet.ibm.com>
In-Reply-To: <20121210142914.GP2516@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/12 06:29, Paul E. McKenney wrote:
> On Tue, Dec 04, 2012 at 08:52:21PM -0800, Frank Rowand wrote:
>>
>> The printk()s in RCU stall warnings do not get flushed to the console
>> on ARM.  Add the oops_in_progress flag back into the special trylock case in
>> console_trylock_for_printk(), and set the flag using "bust_spinlocks(1)".
>> This allows the printk() output to be flushed to the console.
>>
>> Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
> 
> Is bust_spinlocks(1) appropriate for all architectures, or should this
> be conditioned on architectures that need oops_in_progress to be set?
> 
> 							Thanx, Paul

Good question.  I don't know if the architectures that do not set
oops_in_progress do not need it, or if they just overlooked it.
I'll have to look a little bit deeper.

-Frank

