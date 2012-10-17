Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab2JQNiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:38:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52885 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab2JQNiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:38:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/2] mmc: core: Support all MMC capabilities when booting from Device Tree
Date: Wed, 17 Oct 2012 13:38:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Chris Ball <cjb@laptop.org>,
        Russell King <linux@arm.linux.org.uk>, linux-mmc@vger.kernel.org,
        Ulf Hansson <ulf.hansson@stericsson.com>
References: <1350306959-5843-1-git-send-email-lee.jones@linaro.org> <201210151420.29930.arnd@arndb.de> <20121015160740.GC7662@gmail.com>
In-Reply-To: <20121015160740.GC7662@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210171338.01011.arnd@arndb.de>
X-Provags-ID: V02:K0:hLi3DYlHIygbG5e5hL5i/yF1Kg/npmoj/UPSN//E5mX
 pMxb+9zn85BD0Lv/kq14NLL6kY/aK492ltJlmsoYlDulLRS5DS
 lEqAWz3dHsfpWAbkxM4VDN952RxLpuzHkKq0u7rXwHLdw9kaYe
 /JRPAT0Icq2uczSnZov6FA/ciM04n92sBilP9WLnfpJEN3DoBH
 jFCgKosF0zyUbpgPcwBkUK1qnIqBPVfPpu6LDXtlip24lBLM96
 5ovPjz3V4GXCdydk9yoZt34VfyLVWZLtXz9GUTig3UZCmvwOhA
 pvGHfJupYALA3mLIxYofJcII1EjGuawNASz4SvrKQ1YDKnVRI7
 j3d15cEKhOLJ/5yGZtOY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2012, Lee Jones wrote:
> > and so on. What are you actually missing in the properties that
> > are already there?
> 
> MMC_CAP_ERASE

This one seems to be set unconditionally on some controllers but
not on others. Why would it need to be configurable?

> MMC_CAP_UHS_SDR12
> MMC_CAP_UHS_SDR25
> MMC_CAP_UHS_DDR50

Could this be derived from max-frequency?

> MMC_CAP_1_8V_DDR

Right, I suppose we need this. Should we have a minimum and maximum
voltage added to the common properties for this?

> MMC_CAP2_DETECT_ON_ERR
> MMC_CAP2_NO_SLEEP_CMD

I don't see these ones being set anywhere, but they were both
added by Ulf. Maybe he can comment on if or why they are needed
in devicetree, rather than being set by the driver unconditionally
or for specific versions of the host controller.

	Arnd
