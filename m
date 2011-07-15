Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1GOPPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:15:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46360 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1GOPPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:15:23 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
	<20110609115934.3c53f78f@notabene.brown>
	<20110608205233.ebfedc4d.akpm@linux-foundation.org>
	<87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu>
	<20110609123843.77153b27.akpm@linux-foundation.org>
	<877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu> <21324.1307677721@jrobl>
	<871uyxa7ol.fsf@tucsk.pomaz.szeredi.hu>
	<8739ig3k93.fsf@tucsk.pomaz.szeredi.hu> <8536.1310214135@jrobl>
	<87k4bjd8pc.fsf@tucsk.pomaz.szeredi.hu> <12864.1310734928@jrobl>
	<87fwm7d74s.fsf@tucsk.pomaz.szeredi.hu> <13585.1310736814@jrobl>
Date: Fri, 15 Jul 2011 17:16:19 +0200
In-Reply-To: <13585.1310736814@jrobl> (J. R. Okajima's message of "Fri, 15 Jul
	2011 22:33:34 +0900")
Message-ID: <87sjq7bmm4.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. R. Okajima" <hooanon05@yahoo.co.jp> writes:

> By the way, you might remember that I have asked about overriding
> creditials and signals.
> When a process issues chmod, rename or something, then the internal
> copyup happens. If RLIMIT_FSIZE is set to the process, then it may
> fire SIGXFSZ and return EFBIG. It looks strange.

Yeah, good observation.  Copy-up shouldn't fail on RLIMIT_FSIZE and it
doesn't because splice ignores RLIMIT_FSIZE.

So overlayfs works correctly because of a bug in splice.  Not very
satisfactory situation.

Thanks,
Miklos
