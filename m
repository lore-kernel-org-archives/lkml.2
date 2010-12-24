Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab0LYL5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 06:57:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57419 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab0LYL5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 06:57:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 1/7] msm: io: I/O register definitions for MSM8960
Date: Fri, 24 Dec 2010 14:29:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org> <201012152337.19475.arnd@arndb.de> <20101217001658.GA5880@huya.qualcomm.com>
In-Reply-To: <20101217001658.GA5880@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012241429.28901.arnd@arndb.de>
X-Provags-ID: V02:K0:zQTXAjt4LQtfb6bkN3Syn1jnVbNh5LWqG4TlX7AZxcT
 bmaCVEcMbZV4U1WXZS/Z2TKbtyO+tbqaGAZcnqp9v7PNRmsze9
 /wKK7VnVTEQiblhCHE9sSmX21d0g4oEur6xO0UH79Fq3NMT/Q2
 3Vhj3HgNmdOeduPTYidcWz+eLdYIhGioFOVgAoQo9ZGrcCwJrB
 /Xqb19gOwSyupRS6hxh4w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 December 2010, David Brown wrote:
> I agree with this goal, and I think I have a plan to get us there.
> 
> For example, the iomap constants.  To fix this, this data needs to be
> moved into platform data, or something similar.  It seems to me to
> make the most sense to move the individual devices out of the iomap
> until at least the devices used so far on 8960 are all done
> dynamically.  Then at least these constants aren't needed for this
> target.

This is something that would get a lot easier if we already had
device tree support, no idea if it's worth waiting for that for you.
Doing it with extensive platform data involves much of the same
work, but may be more of it.

> There are similar things that need to be done for irqs, and timer
> offsets.

Yes. Eric has spent a lot of time looking into all these issues,
he probably has a good overview of the potential problems.

> I'm not sure really what to do about PHYS_OFFSET.  This is kind of the
> big thing that has kept us so far from making our SOCs multiply
> selectable.  I could move this into a Kconfig option, but it would
> still need to be selected by the SOC.  It is unfortunate that most of
> our SOCs have different enough memory configurations that these are
> mostly different.  Even 8960/8660 will probably have future variants
> that are at different addresses.

I think there are people working on relocatable kernels already,
and we definitely need this for the other work in progress of
doing kernel binaries that work across different SoC families,
as well as for doing a single kernel that can be used both for
booting the system and for kdump.

You don't need to worry about PHYS_OFFSET at the platform level,
we'll get there in a few months for all ARM platforms.

> My question, then is, should we hold off on getting 8960 support into
> the kernel until enough things are improved to get rid of the 8960
> ifdefs?  We can certainly do it that way, but it will keep the code
> out of the kernel longer.

My personal recommendation would be to fix all the places that you
can do without significant reworks of the existing code, and
just add TODO comments in the other places, so we can find them
easily. There is no reason to hold up merging the code too long for
this, but I wouldn't add code now that I know needs to be changed
soon to something that can already be done easily.

	Arnd
