Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab1CJKZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:25:16 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:35418 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1CJKZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:25:14 -0500
Date: Thu, 10 Mar 2011 11:25:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, bp@amd64.org
Subject: Re: [PATCH -v5] kbuild: Add extra gcc checks
Message-ID: <20110310102511.GA30886@merkur.ravnborg.org>
References: <20110301083529.GA767@liondog.tnic> <20110309144504.GA1096@sepie.suse.cz> <20110309151134.GA15730@elte.hu> <20110309175625.GA29181@merkur.ravnborg.org> <20110310090444.GA25522@elte.hu> <4D78971C.6090107@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D78971C.6090107@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One way without extending the current rules could be:
> 
> ifdef CONFIG_CC_WERROR
> Werror := -Werror
> endif
> 
> CFLAGS_sched.o := $(Werror)
> CFLAGS_another.o := $(Werror)
> 
> What do you think?

We could extend kbuild to support something like this:

    ccflags-<filename>-y := -Werror

Sample:

    ccflags-sched.o-$(CONFIG_WERROR) := -Werror

The above is a nice counterpart to the existing ccflags-y.
And we could then deprecate CLFAGS_<filename> as we have today.

To remove options we could use:

ccflags-<filename>-remove-y := -pg

This is a replacement of the undocumented CFLAGS_REMOVE_<filename> variant.

Today:
    ifdef CONFIG_FUNCTION_TRACER
    CFLAGS_REMOVE_lockdep.o = -pg
    endif

Could be replaced with:

   ccflags-lockdep.o-remove-$(CONFIG_FUNCTION_TRACER) := -pg

The ifdef often cover more than one file so we save less lines in
reality than the example says.


All looks rather trivial to implement.
But it is maybe a bit too cryptic?

	Sam
