Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab0JHEzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 00:55:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42710 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0JHEzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 00:55:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.36-rc7: kernel panic with SECURITY_TOMOYO=y
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        takedakn@nttdata.co.jp, penguin-kernel@I-love.SAKURA.ne.jp
In-Reply-To: <alpine.DEB.2.01.1010071637090.21082@trent.utfs.org>
References: <alpine.DEB.2.01.1010071534370.21082@trent.utfs.org> <alpine.DEB.2.01.1010071637090.21082@trent.utfs.org>
Message-Id: <20101008134644.8049.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  8 Oct 2010 13:55:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 7 Oct 2010 at 15:43, Christian Kujau wrote:
> > Kernel panic - not syncing: Profile uersion 0 is not supported
> 
> OK, I just saw that security/tomoyo/common.c panics when:
> 
>         if (tomoyo_profile_version != 20090903)
>                 panic("Profile version %u is not supported.\n",
>                       tomoyo_profile_version);
> 
> If it's imperative that the profile version is somewhat current (mine was 
> not, I had old tomoyo-ccstools installed), I would have expected a 
> slightly more descriptive error messages (apart from that panic), but now 
> I know. Upgraded to tomoyo-tools-2.3.0-20100820 did the trick.

I agree this zero information panic is suck.


Handa-san, please see this panic message again.

> Kernel panic - not syncing: Profile uersion 0 is not supported

Profile?
This message doesn't have any information which should we look!
And, 'profile' is wrong word. TOMOYO have to recommend to upgrade
userland tools here at minimum.

The best way is, of cource, you don't break backward compatibility.



> Call Trace:
> [efB4fd60] [c0008c88] show_stack+0x48/0x168 (unreliable)
> [ef84fda0] [c0375fe01 panic+0xa4/0x1ec
> [ef84fdf0] [c01c5f30] tomoyo_close_control+0x0/0xa4
> [efB4fe00] [c01cc2f0] tomoyo_load_policy+0xeB/0x11c




