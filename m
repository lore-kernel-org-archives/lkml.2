Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab1GKNnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:43:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64720 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab1GKNnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:43:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-paNCtqwJjrg3zDxq3J3h3RX+pBgeeeR3sXRpFKt_tz+w@mail.gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com> <1310370416-6322-22-git-send-email-jim.cromie@gmail.com>
 <CAO+b5-paNCtqwJjrg3zDxq3J3h3RX+pBgeeeR3sXRpFKt_tz+w@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 11 Jul 2011 07:43:13 -0600
Message-ID: <CAJfuBxz0LxnpYKqktu9bo1CzG7mj9FtwvnoOV+oTU-XB2MtFow@mail.gmail.com>
Subject: Re: [PATCH 21/21] dynamic_debug: delete pending queries
To: Bart Van Assche <bvanassche@acm.org>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 4:49 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Mon, Jul 11, 2011 at 9:46 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> delete pending queries by re-issuing it with disabled flags
>>
>> with:
>> $> echo "module foo +ap" > <debugfs>/dynamic_debug/control
>> $> echo "module foo +apt" > <debugfs>/dynamic_debug/control
>> $> echo "module foo ap=" > <debugfs>/dynamic_debug/control
>>
>> 1st command adds a pending query on foo
>> 2nd command modifies it by adding a TID flag
>> 3rd command deletes it by setting flags to 0
>>
>> Note that the pending query matches 'ap' as required by the flags-filter,
>> but additionally has 't'.  An exact match on the query-spec is required,
>> "module foo line 10-20" would not match, and wouldnt be removed.
>
> Maybe I've missed something, but do we need both 'a' and 'p' ? Would
> 'a' alone be sufficient ?

p is for printing, not appending.
unfortunate mnemonics.
maybe 'k' for keep, instead of a for pending is better.

>
> Bart.
>
