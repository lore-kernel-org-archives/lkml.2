Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab2JERCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:02:38 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42633 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab2JERCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <1349455743.6755.57.camel@gandalf.local.home>
References: <1349253783-21612-7-git-send-email-andriy.shevchenko@linux.intel.com>
	<1349254399-22742-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1349455743.6755.57.camel@gandalf.local.home>
Date: Fri, 5 Oct 2012 20:02:36 +0300
Message-ID: <CAHp75Vc1a-4LtuTun=urBLvroLqsok4zeW-Fqm-uDK9izmsR6w@mail.gmail.com>
Subject: Re: [PATCHv2.5] trace: reuse kbasename() functionality
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 7:49 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2012-10-03 at 11:53 +0300, Andy Shevchenko wrote:
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  kernel/trace/trace_uprobe.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
>> index 03003cd..c7ba4f6 100644
>> --- a/kernel/trace/trace_uprobe.c
>> +++ b/kernel/trace/trace_uprobe.c
>> @@ -22,6 +22,7 @@
>>  #include <linux/uaccess.h>
>>  #include <linux/uprobes.h>
>>  #include <linux/namei.h>
>> +#include <linux/string.h>
>>
>>  #include "trace_probe.h"
>>
>> @@ -263,16 +264,15 @@ static int create_trace_uprobe(int argc, char **argv)
>>
>>       /* setup a probe */
>>       if (!event) {
>> -             char *tail = strrchr(filename, '/');
>> +             char *tail;
>>               char *ptr;
>>
>> -             ptr = kstrdup((tail ? tail + 1 : filename), GFP_KERNEL);
>> -             if (!ptr) {
>> +             tail = kstrdup(kbasename(filename), GFP_KERNEL);
>
> I don't see kbasename() anywhere. Is this based off of other patches?
It's introduced by first patch in the series.

-- 
With Best Regards,
Andy Shevchenko
