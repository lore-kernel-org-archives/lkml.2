Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2KFOzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 09:55:48 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36321 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2KFOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 09:55:47 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1211052152250.11829@chino.kir.corp.google.com>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
	<1352156701-4038-104-git-send-email-keescook@chromium.org>
	<alpine.DEB.2.00.1211051721030.24937@chino.kir.corp.google.com>
	<CAGXu5jLq63rpM0wargy-DF6jX_ncDnjMbzjNYAYbx+5uNKmTMA@mail.gmail.com>
	<CAGXu5jKKwE+esJ9QV25vSfnVoejQxHQA7RgoKrzDa9nYMP6uXQ@mail.gmail.com>
	<alpine.DEB.2.00.1211052152250.11829@chino.kir.corp.google.com>
Date: Tue, 6 Nov 2012 06:55:46 -0800
X-Google-Sender-Auth: nmqXUySRxUt0hGVgCAmDP5Iwd4o
Message-ID: <CAGXu5j+dZba-wQP-=6LhkS_Zgnfwosjt4iz9z6S4tW4vzN1afw@mail.gmail.com>
Subject: Re: [PATCH 103/104] mm: remove depends on CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>, Mel Gorman <mel@csn.ul.ie>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 9:57 PM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 5 Nov 2012, Kees Cook wrote:
>
>> >>> diff --git a/mm/Kconfig b/mm/Kconfig
>> >>> index a3f8ddd..679945e 100644
>> >>> --- a/mm/Kconfig
>> >>> +++ b/mm/Kconfig
>> >>> @@ -1,6 +1,5 @@
>> >>>  config SELECT_MEMORY_MODEL
>> >>>       def_bool y
>> >>> -     depends on EXPERIMENTAL || ARCH_SELECT_MEMORY_MODEL
>> >>>
>> >>>  choice
>> >>>       prompt "Memory model"
>> >>
>> >> I thought you agreed to only drop EXPERIMENTAL here in
>> >> http://marc.info/?l=linux-kernel&m=135103415901094 and leave
>> >> ARCH_SELECT_MEMORY_MODEL, which you've orphaned with the above, for phase
>> >> two of your effort?
>> >
>> > Ah! Yes, thanks. I'll restore that.
>>
>> Wait, no. This is an "OR". ARCH_SELECT_MEMORY_MODEL has no affect on
>> SELECT_MEMORY_MODEL if EXPERIMENTAL is always considered on. My
>> proposal was to deal with ARCH_SELECT_MEMORY_MODEL separately. Did I
>> misunderstand something?
>>
>
> We're rehashing the same discussion as before?  I left the earlier thread
> with the understanding that this would become
>
>         depends on ARCH_SELECT_MEMORY_MODEL
>
> and then fix ARCH_SELECT_MEMORY_MODEL when people complain for
> configurations that actually allow you to configure the memory model.  It
> never should have been short-circuited by EXPERIMENTAL in the first place,
> but enabling it to be configurable for everybody and orphaning
> ARCH_SELECT_MEMORY_MODEL doesn't sound appropriate.  I think we should do
> some due diligence in actually making ARCH_SELECT_MEMORY_MODEL work so
> people are presented with a config that will work on their machines.
>
> (This is independent of the rest of the series, we can certainly remove
> EXPERIMENTAL regardless of this decision, I simply think we should be
> leaving ARCH_SELECT_MEMORY_MODEL to prevent users with
> CONFIG_EXPERIMENTAL=n from being presented with a new ability to change
> their memory model that actually doesn't work for them.)

Okay, that's cool. I misunderstood what you'd wanted here. I'll leave
ARCH_SELECT_MEMORY_MODEL in place.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
