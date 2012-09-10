Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2IJNtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:49:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60369 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2IJNtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:49:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 00/19] First HREF Device Tree enablement patch-set
Date: Mon, 10 Sep 2012 13:49:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org> <201209101013.16697.arnd@arndb.de> <CACRpkdbPwiaF8tfEE7NNd_KE3VGtVx-pPwL-HObhh3fRYXqH=g@mail.gmail.com>
In-Reply-To: <CACRpkdbPwiaF8tfEE7NNd_KE3VGtVx-pPwL-HObhh3fRYXqH=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209101349.08857.arnd@arndb.de>
X-Provags-ID: V02:K0:FVwr2tmnECAGW8Lj7/Z9GTvibC+W/BVhHyYXAjwxT7/
 0T7kmWtgmHXjTUn34LhzHJ9X33SN8UAskYa7ZNKx6m1lX6/OVX
 92oC4t2yAIWAaeAUHj3R7WTGP+9ITEr2gXVq1LWKvhPQLpI9WO
 zLGzeJkUBPFxIwRNiRcMDsVfwKY3g0OFkMH3LfUigJxvNiWmQK
 L45K3hgDgiQPuyXSataF2gJd0I9Ge9/u7HGJFwHAsVY22F4x1G
 anQUSzyPml6sOXgBXg6p/2E89Fm8hrRVXuFp0tS7qbzKCo/rzV
 4ZMoVNJrKvLpsj2ZzHlhhcE/5260ltp/kFJRxOtihmDHxB9VCw
 A2yAgtlqoILpCqLZgZrg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2012, Linus Walleij wrote:
> > When the driver offers
> > two ways of probing a device, this lets us change from one way to
> > the other without going through a phase where we use neither of them
> > or (worse) both at the same time.
> 
> Maybe unrelated, but as usual it works as long as there are no
> DMA channels or callback functions :-/
> 
> The MMC, PL022 patches in this patch set: both need
> AUXDATA and DT data simultaneously due to DMA channels
> and callbacks passed in as AUXDATA.

Yes, that's another discussion. When this happens, we obviously
keep the platform data (or add a new version of it), but I'd still
use one patch to add the node to the device tree and simultaneously
add the auxdata and remove the static device registration.

	Arnd
