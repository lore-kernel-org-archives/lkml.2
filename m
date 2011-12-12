Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1LLKBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:01:45 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:35964 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028Ab1LLKBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:01:42 -0500
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
From: Matt Fleming <matt@console-pimps.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com>
	 <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 10:01:26 +0000
Message-ID: <1323684086.3669.16.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 18:59 -0800, Linus Torvalds wrote:
> That said, if you've verified that if fails for you, I guess we should
> revert regardless. Matt, any suggestions for tests to do?

A dmesg from Keith of a working kernel would be good since the most
interesting things are the EFI memory map and the E820 memory map.

At this late -rc stage I agree it makes sense to revert this. The
CONFIG_X86_32 oops that the patch fixes has been around for years and no
one seems to have encountered it (until now), whereas this new
regression is likely to affect many more users.

Looks like there are some macbook memory map funnies that still need to
be addressed...

-- 
Matt Fleming, Intel Open Source Technology Center

