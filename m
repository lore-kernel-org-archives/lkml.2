Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2ALBfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 20:35:43 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47467 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2ALBfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 20:35:41 -0500
X-AuditID: 9c930179-b7ba8ae00000598d-48-4f0e38e802c0
Message-ID: <4F0E38E6.4070606@lge.com>
Date: Thu, 12 Jan 2012 10:35:34 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Namhyung Kim <namhyung@gmail.com>, axboe@kernel.dk, mingo@redhat.com,
        rostedt@goodmis.org, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org, winget@google.com,
        Chanho Park <chanho61.park@samsung.com>
Subject: Re: [PATCH RESEND 9/9] block, trace: implement ioblame - IO tracer
 with origin tracking
References: <1326220106-5765-1-git-send-email-tj@kernel.org> <1326220106-5765-10-git-send-email-tj@kernel.org> <20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com> <4F0D291A.8030205@lge.com> <20120111170635.GE26832@google.com> <4F0E31D9.3080306@lge.com> <CAOS58YOMKvb5Gj5CeP6t11NHwSdbZWUJ=uC6aRxd6CxpNrwskg@mail.gmail.com>
In-Reply-To: <CAOS58YOMKvb5Gj5CeP6t11NHwSdbZWUJ=uC6aRxd6CxpNrwskg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2012-01-12 10:14 AM, Tejun Heo wrote:
> Hello,
>
> On Wed, Jan 11, 2012 at 5:05 PM, Namhyung Kim<namhyung.kim@lge.com>  wrote:
>> Yes. But that's a text-based so it might fit better to simple use cases. If
>> we need further post processing based on intents, it could be better off
>> having binary interface IMHO. And since we already use tracepoints anyway,
>> wouldn't it be good to avoid adding another layer of interface or
>> complexity?
>
> The thing is that all entries are needed for any post processing, not
> only the new ones. To use TP, either there needs to be special
> "trigger the TP for all existing entries" switch somewhere or
> ioblame/intents file needs to be read for existing entries. Even then,
> TPs aren't guaranteed to be reliable. There's no way to detect
> overflow and re-emit the event. It just isn't the right interface. The
> previous version had intents_bin file in binary format but given that
> there aren't too many of intents, binary interface didn't seem
> necessary and ripped it out. Adding it back isn't difficult at all but
> I'm not sure that's a good idea. It's not like parsing the intents
> file is difficult.
>
> Thanks.
>

Why do we need to trigger the TP for existing ones as we keep each entry 
at its creation? Maybe I'm missing something?

Thanks,
Namhyung Kim
