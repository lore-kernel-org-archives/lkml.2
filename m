Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1HKMNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:13:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62518 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab1HKMNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:13:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110811042319.GP2203@ZenIV.linux.org.uk>
References: <1312151063.18010.25.camel@i7.infradead.org>
	<20110731224834.GC2203@ZenIV.linux.org.uk>
	<20110731225801.GD2203@ZenIV.linux.org.uk>
	<1312153988.18010.39.camel@i7.infradead.org>
	<CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
	<20110801043207.GE2203@ZenIV.linux.org.uk>
	<CAFLxGvwxQ2VeqkDpkiVks35DHxZFvAP5nKUtD7i4Z32291otOg@mail.gmail.com>
	<20110809233817.GL2203@ZenIV.linux.org.uk>
	<20110810040445.GM2203@ZenIV.linux.org.uk>
	<20110810174432.GN2203@ZenIV.linux.org.uk>
	<20110811042319.GP2203@ZenIV.linux.org.uk>
Date: Thu, 11 Aug 2011 14:13:22 +0200
Message-ID: <CAFLxGvwE8FGcRtY6v=6jqatZEUwvbBc0ki43jiTYsUp9e_uiAQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not SUBARCH_i386
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>, Arnaud Lacombe <lacombar@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 6:23 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Aug 10, 2011 at 06:44:32PM +0100, Al Viro wrote:
>
>> Fixed and pushed (um-header.git #master); however, looking around that area
>> shows more races ;-/
>
> Such as, for example, seriously broken handling of free_winch(): delaying
> free_irq() until after return from IRQ handler is nice, but not enough -
> freeing struct winch itself (or winch->stack, for that matter) is also best
> left until after free_irq().  Normal way to do that is schedule_work()...
> Fixed and pushed...
>
> Folks, I don't know what to do with all that stuff; as far as I'm concerned
> the ideal variant would be to have functioning git tree maintained by Richard.
> Is that possible?  I can ask to start pulling um-header.git into linux-next,
> but I would very much prefer to avoid that, TYVM...  If nothing else, ACK/NAK
> on the stuff in there should be done by architecture maintainer(s).
>

Sorry for the delay.
Writing my theses consumes a lot of my time...

I've already started reviewing and testing your changes.
Currently they life in my local git repo.
But a git.kernel.org repo is on the way!

Later I'll submit all changes to akpm.

-- 
Thanks,
//richard
