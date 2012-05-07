Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab2EGTNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:13:55 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:52016
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757572Ab2EGTNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:13:54 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzzz2fh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4FA81EFC.5000405@am.sony.com>
Date: Mon, 7 May 2012 12:14:04 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Brian Swetland <swetland@google.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: android: logger: Allocate logs dynamically at
 boot
References: <4FA4673C.7010209@am.sony.com> <20120504233707.GA24213@kroah.com> <4FA8195E.2010706@am.sony.com> <20120507185852.GA1838@kroah.com>
In-Reply-To: <20120507185852.GA1838@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 11:58 AM, Greg KH wrote:
> On Mon, May 07, 2012 at 11:50:06AM -0700, Tim Bird wrote:
>> On 05/04/2012 04:37 PM, Greg KH wrote:
>>> On Fri, May 04, 2012 at 04:33:16PM -0700, Tim Bird wrote:
>>>> +#define MAX_LOGS	5
>>>> +struct logger_log *logs_array[MAX_LOGS];
>>>
>>> You are going to make this a list and not a static array in the
>>> future, right?
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
> For now, it's fine, just in the future I imagine, if you are going to
> continue down the patch of this type of api and interface, you will want
> to make it dynamic.

I'm still working out how this might integrate into the syslog API
(and with Kay's recent work).  It's unclear if this will be the
ultimate data structure holding these entries or not - or if something
different will take its place.  In any event, I'll keep
this in mind if we stay with this data structure.

> 
>>>> -static int __init init_log(struct logger_log *log)
>>>> +static int __init add_log(struct logger_log *log)
>>>>  {
>>>> -	int ret;
>>>> +	int i;
>>>>
>>>> +	for (i = 0; i < MAX_LOGS; i++) {
>>>> +		if (logs_array[i] == 0) {
>>>> +			logs_array[i] = log;
>>>> +			return 0;
>>>> +		}
>>>> +	}
>>>> +	return -1;
>>>> +}
>>>
>>> I see you didn't run your patch through sparse :(
>>
>> Indeed - shame on me. :-(
>>
>>> Care to fix up the sparse warnings and resend?
>> OK - this patch has 2 sparse issues, and there were
>> 2 already in the code.  Do you want me to send the
>> other 2 sparse fixes as an independent patch, or could
>> I cheat and throw them in this one?
> 
> Fix your patch first and resend it.  You can send the 'fix up sparse
> warnings' patch after it if you want to.

OK - will do.

> I don't want to add new patches that add new checkpatch and sparse
> problems, the goal of having the code in the staging tree is that it
> gets better over time, not worse :)

hehe.  Yes. :-)

BTW, I have a whitespace cleanup for one of my previous patches.  I'm unsure
if I should send this in, or wait until the code in question is affected
by another patch.  I thought the standard kernel policy was to not do
standalone whitespace cleanup patches (especially trivial ones).  But
is that the same policy for staging?

I'm happy to submit something now, or wait for a more appropriate time
in the future, and just watch for the right opportunity.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

