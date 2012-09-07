Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2IGNBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:01:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60911 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2IGNBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:01:21 -0400
Date: Fri, 7 Sep 2012 14:01:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com
Subject: Re: [PATCH 00/19] First HREF Device Tree enablement patch-set
Message-ID: <20120907130114.GF29601@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <201209071241.17198.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201209071241.17198.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 12:41:16PM +0000, Arnd Bergmann wrote:
> On Friday 07 September 2012, Lee Jones wrote:
> > Based on v3.6-rc4
> > 
> > This patch consists of Device Tree related enablement for
> > ST-Ericsson's development HREF hardware reference board.
> > Most devices are very similar, if not the same to the
> > previously enabled Snowball low-cost development board.
> > These are referenced from the relevant .dtsi file and
> > merely enabled in the HREF specific Device Tree. There 
> > are also one or two minor Device Tree related fixes which
> > were stumbled upon along the way.
> 
> The patches basically look good to me (except patch 15, see
> comment there), but they are not ordered in a way that allows
> bisection. I can see two ways to do this better:
> 
> a) first do all the code changes, one by one, then add the
> fully populated device tree in the last patch.
> 
> b) as commented on patch 5, atomically change over each
> device in both the DT source and the board code.
> Also do the driver changes (i2c, tc3589x) before changing
> them in the device tree.

Just running this by you, as there is method in the madness.

Linus wanted to keep changes to the Device Tree and changes
in platform code separate, which is my reason for submitting
all of my changes to date that way.

What I do (not sure if I've achieved that here yet, I'll need
to take another look) is; make changes to the driver which
enable it for Device Tree use. Then apply the DT node and remove 
platform registration in two subsequent patches respectively. 
Then when we come to bisect and land in between them we still
have a perfectly working driver, only the second probe fails 
which the only side-effect is some warnings in the boot log.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
