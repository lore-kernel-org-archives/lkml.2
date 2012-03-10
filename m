Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2CJVto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 16:49:44 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62046 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab2CJVtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 16:49:42 -0500
MIME-Version: 1.0
In-Reply-To: <20120310213050.GD23916@ZenIV.linux.org.uk>
References: <20120310213050.GD23916@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 10 Mar 2012 13:49:21 -0800
X-Google-Sender-Auth: XFApWjzlTK1eqw9KzZPChkWMZQM
Message-ID: <CA+55aFwDsoJHGv03tcPgLb7DeFvdcDhmX0rfft8htMTd3aMPXQ@mail.gmail.com>
Subject: Re: [git pull] vfs fixes
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 1:30 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Jan Kara (2):
>      vfs: Fix missed wakeup in I_NEW handling

Christ. This one is too ugly to live.

I'm not pulling crap like this. It's f*^&ing stupid to take a lock,
calculate a bitqueue, and just generally be an absolute ass-hat about
things for waiting for a bit that is already set 99.999% of the time.

May I suggest just reverting that commit 250df6ed instead. It added
all these insane things for no good reason. The comment said they are
going away, but if they are just multiplying in ways like this, I
really think the damn thing needs to be reverted. Any change that
causes code like this is by definition not a good change.

                    Linus
