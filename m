Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab2IGMlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:41:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62804 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab2IGMlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:41:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 00/19] First HREF Device Tree enablement patch-set
Date: Fri, 7 Sep 2012 12:41:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071241.17198.arnd@arndb.de>
X-Provags-ID: V02:K0:EMHJRmAw6kLa0khhTheGATzaMT6vVOm8ivrKQ3ptoVb
 Sl4mr/ApkTsMYvd/qkHMpDa8xYjJag6dscH0wtfX0KHLPsx9Lv
 1w+3boW7x4oGh2bsDhqWzSxjNfqylqG3ZUDpRi43wYRYZNC7OR
 TDJ0OTay4OF7kD0gJrBCYiTajbs7F6pZCmi06LKA8pvJcmxYsK
 weuK03Gk323zC5aMJssAmMNycKRwW94Wcx6rkOIMocCn+F7gur
 JU/YHYRniAxiIdTcaOYEUMjUog+CgRJVCMmdEhj6bYotp7Zrde
 IoQk4hKUe7/fzoMarDNw3bA7WkMcSvRSuoc9fS2B3xtB+1jPid
 YYi99+5rB+LtmLW8AvGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Lee Jones wrote:
> Based on v3.6-rc4
> 
> This patch consists of Device Tree related enablement for
> ST-Ericsson's development HREF hardware reference board.
> Most devices are very similar, if not the same to the
> previously enabled Snowball low-cost development board.
> These are referenced from the relevant .dtsi file and
> merely enabled in the HREF specific Device Tree. There 
> are also one or two minor Device Tree related fixes which
> were stumbled upon along the way.

The patches basically look good to me (except patch 15, see
comment there), but they are not ordered in a way that allows
bisection. I can see two ways to do this better:

a) first do all the code changes, one by one, then add the
fully populated device tree in the last patch.

b) as commented on patch 5, atomically change over each
device in both the DT source and the board code.
Also do the driver changes (i2c, tc3589x) before changing
them in the device tree.

	Arnd
