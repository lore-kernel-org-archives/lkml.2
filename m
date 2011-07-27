Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1G0R2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:28:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34045 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab1G0R2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:28:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-o1vZLResL9LzquZw5qu50evzfGAXNQ8fU0dVZZ5iX6+Q@mail.gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
 <1311630170-26057-19-git-send-email-jim.cromie@gmail.com> <CAO+b5-o1vZLResL9LzquZw5qu50evzfGAXNQ8fU0dVZZ5iX6+Q@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 27 Jul 2011 11:28:16 -0600
Message-ID: <CAJfuBxy8gqCDNJrhh1EWnBe2zUazvzji66g=0KTfA9b6FPn45A@mail.gmail.com>
Subject: Re: [PATCH 18/25] dynamic_debug: describe_flags with '=[pmflta_]*'
To: Bart Van Assche <bvanassche@acm.org>
Cc: jbaron@redhat.com, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 1:37 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Mon, Jul 25, 2011 at 11:42 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> Change describe_flags() to emit '=[pmflta_]+' for current callsite
>> flags, or just '=_' when they're disabled.  Having '=' in output
>> allows a more selective grep expression, in contrast '-' may appear
>> in filenames, line-ranges, and format-strings.  '=' also has better
>> mnemonics, saying; "the current setting are equal to <flags>".
>>
>> The default allows grep "=_" <dbgfs>/dynamic_debug/control
>> to see disabled callsites while avoiding the many occurrences of " = "
>> seen in format strings.
>>
>> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>

>> @@ -102,11 +103,12 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
>>        int i;
>>
>>        BUG_ON(maxlen < 4);
>> +       *p++ = '=';
>>        for (i = 0; i < ARRAY_SIZE(opt_array); ++i)

>
> The "BUG_ON(maxlen < 4)" tests whether a buffer overflow can occur
> before starting to write in the buffer. Since the above code affects
> the number of characters that can be written in the output buffer,
> shouldn't that statement be updated or replaced ?
>
> Bart.
>

Ack.
Ive just enlarged buffer and check to 10.
strictly, only 9 is needed, but Im feeling generous.

thanks for the close reading.

updated git://github.com/jimc/linux-2.6.git  dyndbg-next
