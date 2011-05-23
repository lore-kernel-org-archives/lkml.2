Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab1EWUnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:43:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab1EWUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:43:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110523193855.GA20384@kroah.com>
References: <20110523193855.GA20384@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 13:43:13 -0700
Message-ID: <BANLkTi=vUXOfZ57CT7CtAjOzYReBnp=Vvg@mail.gmail.com>
Subject: Re: [GIT PATCH] STAGING pull for .40
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 12:38 PM, Greg KH <greg@kroah.com> wrote:
> Here is the big pull request for the staging tree for your .40 tree (or
> 2.8.0, whatever you are wanting to rename it to.)

Hmm. Doing my once-a-release "try to compile everything in staging
after pulling from greg by using allyesconfig and also forcing all
staging", I get this:

  drivers/staging/brcm80211/brcmsmac/built-in.o:(.data+0xba0):
multiple definition of `wl_msg_level'
  drivers/staging/brcm80211/brcmfmac/built-in.o:(.data+0x1a94): first
defined here

which looks like another case of "can't compile two things both into
the kernel".

Looks like the BRCMSMAC / BRCMFMAC drivers need to be mutually
exclusive. Something like

  depends on m || (BRCMSMAC != y)

for BRCMFMAC?

Or they should just avoid using the same globally visible name.

I dunno.

                                Linus
