Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1I2Ohx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:37:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53771 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab1I2Ohw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:37:52 -0400
MIME-Version: 1.0
In-Reply-To: <CADi559EcS_iyXgw4qZm5RFVZG2oWiFQ-4w489FEn6YGdViPaXg@mail.gmail.com>
References: <20110929070940.GA2838@udknight.homenetwork> <CA+55aFzjAinwRcw-xd4U8tR+bDdpf2h2kP=cEd5hw+K6ZPt3QQ@mail.gmail.com>
 <CADi559EcS_iyXgw4qZm5RFVZG2oWiFQ-4w489FEn6YGdViPaXg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Sep 2011 07:37:31 -0700
X-Google-Sender-Auth: hlSZzS-Mn2KzsLXAJ5mjqYrFj1o
Message-ID: <CA+55aFyP5NcNTuHTjrBY9MFbGM793TiMs6Ejnk8+aU=LYefKFg@mail.gmail.com>
Subject: Re: [PATCH] init:main.c: start 'usermodehelper_enable()' a little early
To: wang yanqing <udknight@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 1:57 AM, wang yanqing <udknight@gmail.com> wrote:
>
> maybe uvesafb has some specific thing that it requires a userspace
> helper application called 'v86d' to work!
> I will try to make uvesafb workaround it, but i don't know whether it
> will work, and splash boot *really* need
> early init.

Ok. I guess we cannot avoid this. I really would have preferred to run
the kernel init routines without usermodehelper enabled, but it looks
like reality doesn't care about my wishes.

Your "move it up to before all initcalls" works, and seems to be the
simplest solution. I considered doing this when we mount the root
filesystem, but depending on config options that is in multiple
places. We could do the usermode helper enable as a
rootfs_initcall()..

I'm nervous about this. Enabling the usermode helpers too early can
re-introduce the bug where we do it *much* too early before everything
is initialized. But yes, uvesafb clearly does depend on being able to
execute v86d from the root filesystem.

So I  think I'll just have to apply your patch. The alternatives look uglier.

Thanks for the report and the debug help,

            Linus
