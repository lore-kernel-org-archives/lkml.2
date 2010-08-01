Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0HAKVv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 06:21:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64836 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0HAKVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 06:21:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wAVxqq+F10PMVEwGnC8pa5VDcJz9uGk4fgD/pukim+IAs8ay5ru18pwlyW13R/Y8ET
         3/ABSs/dj9xjSpC2G21fhFpFGoW1xwaQoV/WXHcJcRXPLmBT75duTqHSjFHLV8Z7PVwt
         5M0rSRyYYkm4ielmx+LcmOpVPUipzCPjhwSvg=
MIME-Version: 1.0
In-Reply-To: <20100801092859.GA12213@merkur.ravnborg.org>
References: <AANLkTik1p0oK=-msd0a-4wA88Z-Cv29qHVNUYeEETcJD@mail.gmail.com>
	<1280647233-2578-1-git-send-email-nir.tzachar@gmail.com>
	<20100801092859.GA12213@merkur.ravnborg.org>
Date: Sun, 1 Aug 2010 13:21:47 +0300
Message-ID: <AANLkTimXahVmYCo+UJYDkK_qQxCz0HByBGV9WoJtXWkP@mail.gmail.com>
Subject: Re: [PATCH] nconfig: add search support
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mmarek@suse.cz, rdunlap@xenotime.net, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, trapdoor6@gmail.com,
        justinmattock@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 1, 2010 at 12:28 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sun, Aug 01, 2010 at 10:20:33AM +0300, nir.tzachar@gmail.com wrote:
>> From: Nir Tzachar <nir.tzachar@gmail.com>
>>
>> Remove the old hotkeys feature, and replace by a regular string search.
>> >From nconfig help:
>>
>> Pressing '/' triggers search mode. nconfig does regular string match, case
>> insensitive, starting at the begining of each menu line.
>> Pressing Enter highlights the next match, Backspace removes one character from
>> the match string. Pressing either '/' again or ESC exits search mode.
>>
>> Rebind the '/' key (which allowed to search for symbols) to F8
>>
>> Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
>
> Got following warning when I build:
> scripts/kconfig/nconf.c: In function ât_mext_matchâscripts/kconfig/nconf.c:512: warning: implicit declaration of function âblankâ
>
> The searching works great! And good to see the capitilazation gone.

Perhaps now we can make nconfig the default?? ;)

> But it is ackward that I have to press ESC to leave searcing.
>
> I can navigate up/down, but entering a menu should terminate search.
> Also pressing enter (to select a symbol) should terminate search.
>
> I also tried to do first search using "/", then search for a symbol using F8.
> Again search was not terminated when I came back.
>
> There is likely much more cases...

Sure, but we need to come up with a good description of the behavior
we desire. As we did not discuss it, I just went ahead and implemented
a POC.

As to your input, the main problem with terminating a search is how to
still allow iteration between possible matches. We can let Return
terminate the search and use a different key (say, 'p') to navigate to
the next match. However, I dislike this idea, but if no one can come
up with something prettier, I'll implement it.

>        Sam

Cheers.
