Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab2AXAls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:41:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38175 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab2AXAlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:41:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120124002555.GA29534@sergelap>
References: <20120124000517.GA28878@sergelap> <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
 <20120124002555.GA29534@sergelap>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jan 2012 16:41:25 -0800
X-Google-Sender-Auth: 53Mmj2oPWrApCY-ArqDOAHGXm34
Message-ID: <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
Subject: Re: [RFC] fix devpts mount behavior
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Dave Hansen <haveblue@us.ibm.com>, sukadev@linux.vnet.ibm.com,
        Andy Whitcroft <apw@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Matt Helsley <matthltc@us.ibm.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 4:25 PM, Serge Hallyn
<serge.hallyn@canonical.com> wrote:
>
> The only place that *might* be a problem is if initramsfs does a devpts
> mount, and later init blindly mounts tmpfs on /dev and mounts a new
> devpts.  But it seems unlikely there would be any open pty's so it
> shouldn't really matter.

Right. I think the opportunity for problems should be pretty small.

And it's not like the pty itself wouldn't continue to work - it's just
that programs like /usr/bin/tty wouldn't be able to *find* it.

Although who knows - maybe there is some other subtle interaction.

> I could go ahead and test that, say, ubuntu and fedora systems boot fine
> with this change.  But of course I can't be sure there is no userspace
> out there that won't cope...

I think the only way is to try it out.

If you can test a few distros and at least validate that the approach
isn't *totally* broken, I'll apply it. It's early days in the -rc
series yet, and this does seem to be one of those things that we'd be
better off trying to do early rather than delay.

If it causes problems, we will have to revert it and look for
alternate approaches, but if it just works it would seem to be the
right thing to do.

                          Linus
