Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab2EGXki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 19:40:38 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:15319
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757743Ab2EGXkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 19:40:01 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bhz2fh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4FA85D5D.2070103@am.sony.com>
Date: Mon, 7 May 2012 16:40:13 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Brian Swetland <swetland@google.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: android: logger: Allocate logs dynamically at
 boot
References: <4FA4673C.7010209@am.sony.com> <20120504233707.GA24213@kroah.com>	<4FA8195E.2010706@am.sony.com> <CANqkERCQixuCe9vfeDncHikED-bVwZ3APr=mo6WfQBcGf4rz_g@mail.gmail.com>
In-Reply-To: <CANqkERCQixuCe9vfeDncHikED-bVwZ3APr=mo6WfQBcGf4rz_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 03:13 PM, Brian Swetland wrote:
> On Mon, May 7, 2012 at 11:50 AM, Tim Bird <tim.bird@am.sony.com> wrote:
>> On 05/04/2012 04:37 PM, Greg KH wrote:
>>> On Fri, May 04, 2012 at 04:33:16PM -0700, Tim Bird wrote:
>>>> +#define MAX_LOGS    5
>>>> +struct logger_log *logs_array[MAX_LOGS];
>>>
>>> You are going to make this a list and not a static array in the
>>> future, right?
>>
>> Would that be better?  The for-loop is IMHO simpler than a
>> list walk for finding matches.  I anticipate that the size of
>> this array should never (famous last words) be bigger than about
>> 20 entries, even in the dynamic-allocation-per-application
>> case.  And that's a ways off in implementation.
>>
>> I'll be happy to switch to a linked list once it looks like we're
>> going to have more than 5 entries.  Or I can switch to a linked
>> list now if you think it's better form to code for the longer-term
>> anticipated features.
>>
>> Not a big deal to me either way.
> 
> I'd also favor a list approach. It won't break unexpectedly when
> somebody inevitably adds that 6th log or whatever, and the list
> traversal cost only occurs during open(), which is not a frequent
> operation -- most users keep the log driver open for the process
> lifespan (both readers and writers).

OK - I'll convert to a list and send an updated patch soon.
 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

