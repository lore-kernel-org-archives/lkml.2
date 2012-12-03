Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab2LCXHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:07:38 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59698 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2LCXHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:07:37 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8MBbJGy7xQFqi1VXPuPNHJnoZUcxjWDkmyRKeajXGAA_Q+GA@mail.gmail.com>
References: <CA+55aFyFLG+SxRq2=wY=8tyuQzQSHkKxonXwMmCOs=CWyOo=Mg@mail.gmail.com>
 <874nk2u69u.fsf@silenus.orebokech.com> <CA+55aFxO+nOM--EJmrT+_54jF8AL2YZ7GhbwCT2cg2qxM2Md+A@mail.gmail.com>
 <CA+8MBbJGy7xQFqi1VXPuPNHJnoZUcxjWDkmyRKeajXGAA_Q+GA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Dec 2012 15:07:09 -0800
X-Google-Sender-Auth: dmrkvyOKnM4VF8wNOgNJHOjJKX4
Message-ID: <CA+55aFyAvpCKPWV9Mh34aV6Q4DRjATQky939vYaPBfx6+65Nxw@mail.gmail.com>
Subject: Re: Linux 3.7-rc8
To: Tony Luck <tony.luck@intel.com>
Cc: Romain Francoise <romain@orebokech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 2:44 PM, Tony Luck <tony.luck@intel.com> wrote:
>> Just for info, can you add a "WARN_ON_ONCE()" to handle_bad_sector()
>> just so that I see which particular path your kvm load triggers.
>
> On native ia64 (with SLES11 userspace) I see:

Interesting. I knew about the possibility of this, and had actually
*tried* to trigger this with the regular read() system call. But
couldn't, so I had assumed that it was some special path (ie
O_DIRECT). But it's just the regular read-ahead.

I guess I need to try harder. I'm guessing that there's a 4kB
filesystem there, and the block device size isn't 4kB-aligned or
something.

              Linus
