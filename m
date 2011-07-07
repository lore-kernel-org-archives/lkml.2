Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab1GGTos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:44:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42582 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1GGTor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:44:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-pxk_5+gvR6N8_vW5zMTn1RZW0ghBRGZiMVGqWOoXYTiA@mail.gmail.com>
References: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
 <151c1f3fc402d2f19f95e44de07cdc04917f7278.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
 <CAO+b5-pxk_5+gvR6N8_vW5zMTn1RZW0ghBRGZiMVGqWOoXYTiA@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Thu, 7 Jul 2011 13:44:17 -0600
Message-ID: <CAJfuBxzx-SYfh8jhtxABGdVJD_SsaY3kx2q+F6vcTA5P1vCeWA@mail.gmail.com>
Subject: Re: [PATCH 02/10] dynamic_debug: Consolidate prefix output to single routine
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Baron <jbaron@redhat.com>, gregkh@suse.de, joe@perches.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 12:14 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Wed, Jul 6, 2011 at 7:24 PM, Jason Baron <jbaron@redhat.com> wrote:
>>
>> From: Joe Perches <joe@perches.com>
>>
>> Adding dynamic_dev_dbg duplicated prefix output.
>> Consolidate that output to a single routine.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>> Signed-off-by: Jason Baron <jbaron@redhat.com>
>> ---
>>  lib/dynamic_debug.c |   38 ++++++++++++++++++--------------------
>>  1 files changed, 18 insertions(+), 20 deletions(-)
>>
>> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
>> index 5c5f8f9..758e922 100644
>> --- a/lib/dynamic_debug.c
>> +++ b/lib/dynamic_debug.c
>> @@ -428,15 +428,10 @@ static int ddebug_exec_query(char *query_string)
>>        return 0;
>>  }
>>
>> -int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
>> +static int dynamic_emit_prefix(const struct _ddebug *descriptor)
>>  {
>
> How about renaming dynamic_emit_prefix() into ddebug_emit_prefix() ?
> Personally I prefer the latter name over the former.
>
> Bart.
>

WRT naming, Id like dyndbg, esp as exposed on kernel cmdline, parameters..

dyndbg.query=....
dyndbg.verbose=1
/sys/modules/dyndbg/parameters/verbose

does this run up against ABI issues ?
