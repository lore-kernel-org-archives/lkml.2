Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab2IJKNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:13:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55142 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab2IJKNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:13:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 00/19] First HREF Device Tree enablement patch-set
Date: Mon, 10 Sep 2012 10:13:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org> <201209071358.38598.arnd@arndb.de> <CACRpkdZ-QpHzeEBO=RFVe-8S2DG4-thhwW9iVbAMXZrOe-FnAw@mail.gmail.com>
In-Reply-To: <CACRpkdZ-QpHzeEBO=RFVe-8S2DG4-thhwW9iVbAMXZrOe-FnAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209101013.16697.arnd@arndb.de>
X-Provags-ID: V02:K0:U/udp+kIbHa8XSzFxhmSRWHF5v/RWkntmwfxJtllc8+
 A876i4CySA/U219V2cvVRu6XdapkV0OlqEMOWA52a4k0PMpTE6
 nk5CqIjUBn0bN499mz8mvirzxcUFW568xurkrnitoPvFEBETVu
 VtX0PvACu5FKbsCUfs4O6aSumtrwusm9aaoxoBsM65jkyigq7j
 kfHmGUzMc0ayNAJrM6NeD3HJmmMq1ls+jESew+sh0pNNNulj67
 YFesjcwjZrc/DtKH63DCV+2hB/lbOEaQLhuN8i4OIqZGRiPqJ8
 ckDf46gxJiCHziCZLSkuzn+xL3Pb8FbJKzL1UwPq+45BdF5c4j
 HMViNnWWuj7wVMEzuOHs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2012, Linus Walleij wrote:
> Basically that was at a point when we were changing a lot of
> subsystem trees with DT patches that were merged in out-of-order
> fashion.
> 
> Then it's better to have the DT changes to be pushed
> separately at the end of the merge window after all subtrees
> with dependent changes are merged. (Or even in the next merge
> window if there is no hurry, but we always seem to be in a hurry...)
> 
> If all the changes are in the same subtree (like ARM SoC with
> ACKs from all over the place where needed) you can do it
> this way instead, and I agree it looks better.

I think we're talking about different things:

I think it's fine to do the device driver conversion separately
from the platform changes, but doing that properly means that the
platform changes should only go in after the drivers have changed.

Inside of the platform code, I absolutely think we should change the
board file and the dts file simultaneously. When the driver offers
two ways of probing a device, this lets us change from one way to
the other without going through a phase where we use neither of them
or (worse) both at the same time.

	Arnd
