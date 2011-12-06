Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1LFVIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:08:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43346 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab1LFVIT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:08:19 -0500
MIME-Version: 1.0
In-Reply-To: <20111206205346.GK2203@ZenIV.linux.org.uk>
References: <20111206154854.GH2203@ZenIV.linux.org.uk> <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com>
 <20111206205346.GK2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 13:07:56 -0800
X-Google-Sender-Auth: x3n-YVtksB7GGaikozfnUvPjYAU
Message-ID: <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 12:53 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> The trouble is, might very well stop *NOT* at the global root.  Consider
> a race with umount -l; we have no way to tell "it had been outside of
> chroot jail" from "it had walked up to the place where ->mnt_parent had
> been already reset, sorry, no idea what it was".

Sure, but you made that case return NULL already as part of the "no
bastard" case, didn't you?

That part of the patch looked fine.

It was just the extra convolutions around 'bastard' that seemed to be
over-designed, and made for just a single use that seems very
peripheral anyway.

Apart from AppArmor, afaik nobody even really cared where they ended
up, and even AppArmor really didn't want to know - it just had this
totally crazy special case about "/sys".

                 Linus
