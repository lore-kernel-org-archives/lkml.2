Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2H3S2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:28:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40735 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489Ab2H3S2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:28:01 -0400
Date: Thu, 30 Aug 2012 11:27:58 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rabin Vincent <rabin@rab.in>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] regulator: disable supply regulator if it is enabled
 for boot-on
Message-ID: <20120830182757.GM4356@opensource.wolfsonmicro.com>
References: <1346251989-26537-1-git-send-email-ldewangan@nvidia.com>
 <CAH+eYFBe6c0_H6z65AfW-6BCuxrQYFVFSXrZT865JGmcvyMRCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH+eYFBe6c0_H6z65AfW-6BCuxrQYFVFSXrZT865JGmcvyMRCg@mail.gmail.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 08:24:15PM +0200, Rabin Vincent wrote:

> This does not handle the case where a regulator is not set boot_on but
> is considered on (for example, because of the lack of an is_enabled
> callback), and is later actually enabled by a consumer before
> regulator_init_complete().  In this case, the supply's use count will
> still be one more than it should be, because the "&& c->boot_on"
> condition above will fail.

> To fix this, you should probably note which regulators' supplies you
> enable in regulator_register() and use that information in the above two
> checks here in regulator_init_complete().

Yeah, I didn't read this properly yet but this was my main concern -
this should all just fall out naturally through the normal disable
process.  Doing special case bodges feels really fragile and error
prone.
