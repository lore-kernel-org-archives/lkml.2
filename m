Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab2HUW4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 18:56:10 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:37885 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775Ab2HUW4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 18:56:08 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.228;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail01v.am.sony.com;RD:mail01.sonyusa.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI1443I1432Izz1202hzz8275bhz2fh2a8h668h839hf0ah107ah10d2h)
Message-ID: <50341210.9040803@am.sony.com>
Date: Tue, 21 Aug 2012 15:56:16 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Michael Thalmeier <michael.thalmeier@hale.at>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <rostedt@goodmis.org>, <stable-rt@vger.kernel.org>
Subject: Re: [PATCH RT 2/2] fix printk flush of messages
References: <4FB44EF1.9050809@am.sony.com> <4FB44FD0.4090800@am.sony.com> <loom.20120821T161458-427@post.gmane.org>
In-Reply-To: <loom.20120821T161458-427@post.gmane.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added recipients...

On 08/21/12 07:30, Michael Thalmeier wrote:
> Frank Rowand <frank.rowand <at> am.sony.com> writes:
> 
>>
>>
>> Updates console-make-rt-friendly.patch
>>
>> #ifdef CONFIG_PREEMPT_RT_FULL, printk() output is never flushed by
>> printk() because:
>> ...
>>
>> On system boot some printk() output is flushed because register_console()
>> and tty_open() call console_unlock().
>>
>> This change also fixes the problem that was previously fixed by
>> preempt-rt-allow-immediate-magic-sysrq-output-for-preempt_rt_full.patch
>>
>> Signed-off-by: Frank Rowand <frank.rowand <at> am.sony.com>
>>
>> ---
>>  kernel/printk.c |    2 	1 +	1 -	0 !
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: b/kernel/printk.c
>> ===================================================================
>> --- a/kernel/printk.c
>> +++ b/kernel/printk.c
>> @@ -847,7 +847,7 @@ static int console_trylock_for_printk(un
>>  	int retval = 0, wake = 0;
>>  #ifdef CONFIG_PREEMPT_RT_FULL
>>  	int lock = !early_boot_irqs_disabled && !irqs_disabled_flags(flags) &&
>> -		!preempt_count();
>> +		(preempt_count() <= 1);
>>  #else
>>  	int lock = 1;
>>  #endif
>>
>>
> 
> I have seen that this patch is applied in the 3.4 stable rt series.
> As we are using the 3.0 stable rt kernel I have tested this patch on this
> kernel series (on a Freescale i.MX31 based board) and have not found any
> problems so far.
> Is there something I have missed why this patch has not found its way
> in the 3.0 series ?
> 
> Thanks in advance,
> Michael

