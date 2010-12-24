Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0LXPjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 10:39:05 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:34010 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161Ab0LXPjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 10:39:03 -0500
Message-ID: <4D14BE81.6000907@metafoo.de>
Date: Fri, 24 Dec 2010 16:38:41 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] ASoC: codecs: Fix register cache incoherencies
References: <1293198484-1902-1-git-send-email-lars@metafoo.de> <20101224145706.GA16614@opensource.wolfsonmicro.com>
In-Reply-To: <20101224145706.GA16614@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2010 03:57 PM, Mark Brown wrote:
> > On Fri, Dec 24, 2010 at 02:47:55PM +0100, Lars-Peter Clausen wrote:
>> >> The multi-component patch(commit f0fba2ad1) introduced a generic register cache
>> >> framework. Most of the drivers where converted to use this new framework. But
> >
> > No it didn't - soc-cache.c has been present since the middle of 2009.
Hm. Ok, you are right, I've should have checked more closely. Only the allocation of
the register cache was moved from the drivers to the core.

So the commit messages should have been along the lines of:
	The multi-component patch(commit f0fba2ad1) moved the alloction of the
	register cache from drivers to the ASoC core. While most of the drivers were
	converted to respect this change, some still maintain their own register
	cache besides the one used and allocated by the core.
	Thus the device ends up with two from each other incoherent caches, which
	can lead to undefined behaviour.

If there are no other issues with this series, I'll resend it with adjusted commit
messages in a few days.

- Lars
