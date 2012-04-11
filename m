Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab2DKWZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:25:34 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:54050 "EHLO violet"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933500Ab2DKWZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:25:33 -0400
Date: Thu, 12 Apr 2012 00:21:24 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Svenning =?utf-8?B?U8O4cmVuc2Vu?= <sss@secomea.com>
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andreas Mohr <andi@lisas.de>
Subject: Re: via-rhine: Problem with lost link after a while
Message-ID: <20120411222124.GA20605@electric-eye.fr.zoreil.com>
References: <CACPM=kWa=UWuCMaYAtVMGJ7pzCy-PfyNRWBSuJnTZGtssU0W6g@mail.gmail.com> <20120410204249.GA26627@electric-eye.fr.zoreil.com> <CACPM=kWsU8QZOHqwEThTQCuSSvaTDoxO1d17EyoW=+kx8QG3vw@mail.gmail.com> <20120410225534.GA28480@electric-eye.fr.zoreil.com> <4F8553BF.6030303@secomea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F8553BF.6030303@secomea.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Svenning Sørensen <sss@secomea.com> :
[...]
> Regarding the "Tx descriptor busy" test: no, I didn't see it
> trigger, I just put it there just in case because I suspected there
> could be a race due to the lock-free tx path.
> But I'm glad if you're confident that it can't happen :)

Almost :o)

Without the patch it may happen in mainline. Once the napi Tx completion
function checks if queueing is stopped before enabling it, it should not
happen though. The patch should fix the race where queuing is not enabled
as well.

That being said, I would welcome a pony^W^W some testing on a multi-core
system with lots of Tx and enough irq from a different (non via-rhine)
source to starve the softirq processing.

-- 
Ueimor
