Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab0IKKGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 06:06:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56788 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751075Ab0IKKGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 06:06:47 -0400
Date: Sat, 11 Sep 2010 11:06:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Woodhouse <David.Woodhouse@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] ihex: Add support for CS:IP/EIP records
Message-ID: <20100911100645.GA28571@opensource.wolfsonmicro.com>
References: <1284039626-30394-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1284193744.20200.13.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284193744.20200.13.camel@i7.infradead.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 09:29:04AM +0100, David Woodhouse wrote:

> - Which firmware blobs that are *already* in the kernel would need this?
>   Remember, we're not adding new crap to the kernel source tree; new
>   firmware images get added to linux-firmware.git instead.

None to my knowledge, however I don't understand why this would be
relevant to adding new features to ihex2fw?

> - Why make the include_jump code optional? When would we ever *not* want
>   to include such a record -- when does the input ihex file contain such
>   a record that the kernel driver *must* not see because it can't cope
>   with it?

Given that our binary ihex format discards all record type information I
would expect all existing users would be confused if they started seeing
these records so it seems safer to only generate them when required.  It
seems likely that some ihex images will contain jump addresses generated
by their toolchain which do not need to be parsed since the address is
always the same (eg, the address the device uses when brought out of
reset), though none of those in the kernel tree currently seem to.
