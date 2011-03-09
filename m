Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab1CIR43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:56:29 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:33411 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128Ab1CIR42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:56:28 -0500
Date: Wed, 9 Mar 2011 18:56:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Marek <mmarek@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, bp@amd64.org
Subject: Re: [PATCH -v5] kbuild: Add extra gcc checks
Message-ID: <20110309175625.GA29181@merkur.ravnborg.org>
References: <20110301083529.GA767@liondog.tnic> <20110309144504.GA1096@sepie.suse.cz> <20110309151134.GA15730@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309151134.GA15730@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another, related, very nice kbuild feature would be to allow for arch maintainers to 
> mark certain files as "should only build fine without warnings" - i.e. -Werror 
> should be the default. There would be a Kconfig feature to opt out of this, 
> CONFIG_CC_IGNORE_WARNINGS=y or so. This would allow for people to still build the 
> kernel with old (or buggy) versions of GCC.

To add -Werror for all files conditionally you can do:

    ccflags-$(CONFIG_WERROR) += -Werror

For individual files we can then drop -Werror like this:

    CFLAGS_REMOVE_foobar.o := -Werror

So it should be doable with the existing infrastructure.

	Sam
