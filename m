Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2GEQJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:09:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57449 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2GEQJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <1341234662.1476.13.camel@leonhard>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
	<87fw9blyhj.fsf@sejong.aot.lge.com>
	<20120702101518.GC967@krava.redhat.com>
	<1341234662.1476.13.camel@leonhard>
Date: Thu, 5 Jul 2012 18:09:18 +0200
Message-ID: <CABPqkBTj0ziDpCfOdadVr9=hdwp0zdbJ2UgP1coZLrTUni-nvA@mail.gmail.com>
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        andi@firstfloor.org, drepper@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 3:11 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> 2012-07-02 (월), 12:15 +0200, Jiri Olsa:
>> On Mon, Jul 02, 2012 at 10:53:44AM +0900, Namhyung Kim wrote:
>> > Just a question, is there a way to know about the grouping at perf
>> > report time?
>>
>> nope, AFAIK only ID and perf_event_attr is stored for event
>> grouping is known only for record time
>>
>
> I heard that Arnaldo (or Stephane) wanted to make perf report
> group-aware or such so that it can show related events together. But to
> do that, it seems we need to change the data file format first, right?
>
Yes, you'd like something like that. The idea is to use an event to sample
and the others to compute event deltas. For instance, how many loads/stores
instructions retired for every 100k instructions retired. For that you need
grouping. The kernel supports this already, the perf tool does not.

I don't  think you need to change the file format. Everything is there
already in the headers. OF course, you perf report needs to detect
this mode and adjust the output. IF not, then it should only display
samples coming from the first event. Not clear how you'd display
the information in perf report or perf annotate at this point yet.

> Any idea?
>
>
> --
> Regards,
> Namhyung Kim
>
>
