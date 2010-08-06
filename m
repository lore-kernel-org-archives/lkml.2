Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981Ab0HFTqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:46:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969Ab0HFTqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:46:04 -0400
MIME-Version: 1.0
In-Reply-To: <20100806204552.7cb80fd0@lxorguk.ukuu.org.uk>
References: <20100805213528.GA13794@kroah.com> <AANLkTikhq6FF4j+w-TXrPeq05NhvbhgqhJkW7tCw2+3c@mail.gmail.com> 
	<20100806185147.GB23853@suse.de> <20100806204552.7cb80fd0@lxorguk.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 12:38:36 -0700
Message-ID: <AANLkTimGoG97dtp_hmHBJwwo1stzZxLoKs4_jr+eQ=gJ@mail.gmail.com>
Subject: Re: [GIT PATCH] TTY patches for 2.6.36
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 12:45 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> Wouldn't it make more sense to simply turn it on as Linus suggested ?

I really do want the whole "there can be only one" highlander part.

Go all Christopher Lambert on it, and cut it off at the head so that
it cannot resurface even by mistake. IOW, remove the config option
entirely, and remove the #ifdef's that switch between the BKL and
mutex case.

Otherwise somebody will enable the BKL code, and we'll miss the
testing for that case. And getting testing is what the whole merge
window is all about.

I also don't want the BKL to show up in grep, even if the config
option for it were to be impossible to enable. If we've gotten far
enough that we can get rid of the BKL in the tty layer, we really
should get rid of it. Not leave it in some zombie limbo state.

                    Linus
