Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab0JGX5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:57:34 -0400
Received: from trent.utfs.org ([194.246.123.103]:32810 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab0JGX5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:57:33 -0400
Date: Thu, 7 Oct 2010 16:57:32 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: takedakn@nttdata.co.jp, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: 2.6.36-rc7: kernel panic with SECURITY_TOMOYO=y
In-Reply-To: <alpine.DEB.2.01.1010071534370.21082@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1010071637090.21082@trent.utfs.org>
References: <alpine.DEB.2.01.1010071534370.21082@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010 at 15:43, Christian Kujau wrote:
> Kernel panic - not syncing: Profile uersion 0 is not supported

OK, I just saw that security/tomoyo/common.c panics when:

        if (tomoyo_profile_version != 20090903)
                panic("Profile version %u is not supported.\n",
                      tomoyo_profile_version);

If it's imperative that the profile version is somewhat current (mine was 
not, I had old tomoyo-ccstools installed), I would have expected a 
slightly more descriptive error messages (apart from that panic), but now 
I know. Upgraded to tomoyo-tools-2.3.0-20100820 did the trick.

Sorry for the noise...

Christian.
-- 
BOFH excuse #86:

Runt packets
