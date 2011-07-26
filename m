Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab1GZQVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:21:51 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59935 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab1GZQVq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:21:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-oJX+K6Li3fPANVEFg2Kxx8Wum_iZY0pSbVEq_mRJrLPg@mail.gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
 <1311630170-26057-12-git-send-email-jim.cromie@gmail.com> <CAO+b5-oJX+K6Li3fPANVEFg2Kxx8Wum_iZY0pSbVEq_mRJrLPg@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 26 Jul 2011 10:21:15 -0600
Message-ID: <CAJfuBxwVweGD2upqtJr=WEX3tRkr8bRYZG2sPeM=N3R0Tns7HA@mail.gmail.com>
Subject: Re: [PATCH 11/25] dynamic_debug: factor show_ddebug_query out of ddebug_parse_query
To: Bart Van Assche <bvanassche@acm.org>
Cc: jbaron@redhat.com, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 1:15 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Mon, Jul 25, 2011 at 11:42 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> @@ -435,6 +448,10 @@ static int ddebug_exec_queries(char *query)
>>        char *split;
>>        int i, errs = 0, exitcode = 0, rc;
>>
>> +       prbuf_query = kmalloc(1024, GFP_KERNEL);
>> +       if (prbuf_query == NULL)
>> +               return -ENOMEM;
>> +
>>        for (i = 0; query; query = split) {
>>                split = strpbrk(query, ";\n");
>>                if (split)
>> @@ -452,6 +469,7 @@ static int ddebug_exec_queries(char *query)
>>                }
>>                i++;
>>        }
>> +       kfree(prbuf_query);
>
> The above changes invoke memory allocation and deallocation. But the
> allocated buffer isn't used anywhere - neither in this patch nor in
> any later patch ???
>
> Bart.
>


nope, that was a vestige of code before rework to use kasprintf.
now excised.

thanks.
