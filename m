Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab1JTK6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 06:58:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55595 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1JTK6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 06:58:18 -0400
Subject: Re: [PATCH 12/21 v2] m68k: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@snapgear.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAMuHMdVpAhJDhTDSwRWb7s4KvMGzh+twL7DhH1Ww=ZNK9aNE2w@mail.gmail.com>
References: <1318925407.6414.22.camel@x61.thuisdomein>
	 <4E9D6C05.9040106@snapgear.com> <1318941043.6414.35.camel@x61.thuisdomein>
	 <4E9FB0D6.9080301@snapgear.com>
	 <CAMuHMdVpAhJDhTDSwRWb7s4KvMGzh+twL7DhH1Ww=ZNK9aNE2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 12:58:13 +0200
Message-ID: <1319108293.8405.21.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 08:54 +0200, Geert Uytterhoeven wrote:
> BTW, a few of the *_SCC symbols became orphaned, too.

Yes, MVME147_SCC, MVME162_SCC and BVME6000_SCC look unused. I missed
those because of these lines:
config SERIAL_CONSOLE
        bool "Support for serial port console"
        depends on [..] MVME147_SCC || [...] MVME162_SCC || BVME6000_SCC [...]

The scripts I used aren't smart enough to evaluate a second instance of
these symbols. One of the simple heuristics they used was: "mentioned a
second time in any of the Kconfig files means it is used".

I haven't yet discovered a smarter way to do this. In this case that
might be: if any other usage of the symbol in the Kconfig doesn't
"select" any other symbol it is unused (provided, of course, there's no
instance of CONFIG_$symbol in any non-Kconfig file) . But I don't know
if that will work. Moreover, this requires an actual parser of the
Kconfig syntax. I've chosen to keep things as dumb as possible, and use
as little understanding of the Kconfig syntax as possible. I still found
quite a number of unused symbols with an acceptable signal to noise
ratio. False-negatives like these are the downside.


Paul Bolle

