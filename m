Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2DITwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:52:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40198 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2DITwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:52:47 -0400
MIME-Version: 1.0
In-Reply-To: <1333939078.2508.19.camel@joe2Laptop>
References: <1333924698-3894-1-git-send-email-jim.cromie@gmail.com>
 <1333925535.2508.15.camel@joe2Laptop> <CAJfuBxz2fD2KDxpg5gZfGW4bFvuviTG709Aev0=p-ojuzRNpCQ@mail.gmail.com>
 <1333939078.2508.19.camel@joe2Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 9 Apr 2012 13:52:16 -0600
Message-ID: <CAJfuBxxBY3Mq3EnuginFw_JkK3AE15V-u6C7uvi2L03tFfHOXQ@mail.gmail.com>
Subject: Re: [00/02] add BUILD_BUG_DECL assertion (for 3.4??)
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 8, 2012 at 8:37 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2012-04-08 at 17:59 -0600, Jim Cromie wrote:
>> On Sun, Apr 8, 2012 at 4:52 PM, Joe Perches <joe@perches.com> wrote:
>> > On Sun, 2012-04-08 at 16:38 -0600, Jim Cromie wrote:
>> >
>> >> this patch (0001) adds new bug.h macro, BUILD_BUG_DECL(name, cond),
>> >> which unlike other *BUG* assertions is usable at file scope.  Its
>> >> primary purpose is to enforce identical sizes of 2 separate arrays,
>> >> which but for considerations of packing/padding/section, would be
>> >> together in a struct.


>> >> BUILD_BUG_DECL(b, ARRAY_SIZE(a) != ARRAY_SIZE(names));        // good

>> >
>> > If possible, it might be better to wrap the
>> > declarations themselves in a macro that ensures
>> > the sizes are the same.
>> >
>> > Something like:
>> >
>> > declare_same_size_arrays(
>> >        typeof array1[] = {...},
>> >        typeof array2[] = {...}
>> > );
>> >
>> >
>>
>> Unless Im mis-reading you, this has a couple disadvantages:
>>
>> - bigger patches where its added.
>> granted these are mostly whitespace, but theyre less trivial to inspect.
>
> Not a problem in my view, it moves the
> related declarations closer together.
>
>> - not useful for array definitions which are not contiguous
>> granted thats a minority case, and the definitions could often be moved,
>> but not always.
>
> Discontiguous array definitions must be ugly.

Ugly ?
too pejorative IMO

each array defn is a single statement.
there may be functions between the 2 defns being compared.

Maybe not ideal,

>
>> Do you see advantages other than stylistic ones ?
>
> Not really.
>
> Contiguous declarations.
> No need for other markings.
>
> Seems useful enough.
>

OK.  Id expect your construct to be built upon mine,
we'd still need to start with something.

Also, mine is usable for things yours isnt.
I dont have a good example, but a simple/silly one is:

BUILD_BUG_DECL( wifi_channels_must_be_14,
                  ARRAY_SIZE(channels_table) == 14 );
