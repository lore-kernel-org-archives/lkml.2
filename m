Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab1AKSN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:13:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932276Ab1AKSNy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:13:54 -0500
MIME-Version: 1.0
In-Reply-To: <1294768668.2435.177.camel@doink>
References: <20110107075831.GA14915@amd> <1294763679.2435.72.camel@doink>
 <AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com> <1294768668.2435.177.camel@doink>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Jan 2011 10:13:32 -0800
Message-ID: <AANLkTikomwroDXYmtA1crJeEdcpo_T1-g=O1zhHie4sC@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
To: aelder@sgi.com, Ian Kent <raven@themaw.net>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Ian to cc - the BUG_ON() in d_set_d_op() triggers on autofs4,
see lkml thread for more details if you care ]

On Tue, Jan 11, 2011 at 9:57 AM, Alex Elder <aelder@sgi.com> wrote:
>
> Looking at it quickly, I don't think that would matter for
> the case at hand.  I.e., that might be safer but it doesn't
> address the fact that these fields are getting initialized
> multiple times.

You're right - without looking closer or thinking about it any more, I
was thinking mkdir etc would create the new dentry, but it can easily
be a pre-existing negative one. So it's not like mkdir is always going
to be something new that can just be initialized.

So yeah, no race or anything like that required - just regular acceses.

That said, if we make sure that the d_op gets cleared (or the dentry
dropped) when something turns negative, and a negative lookup never
sets d_op, it should all basically work.

Can you figure out the exact sequence that causes this? Is it enough
to just mount something once?

                 Linus
