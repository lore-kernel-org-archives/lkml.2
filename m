Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2EaUrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:47:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50158 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2EaUrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:47:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Subject: Re: [RFC PATCH 0/5] omap: add ocp2scp as a misc driver
Date: Thu, 31 May 2012 20:46:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com
References: <1338375394-16268-1-git-send-email-kishon@ti.com> <201205310922.18550.arnd@arndb.de> <CAAe_U6J3p9Lh9g82tSSLxOJ7nqrozdRe11zV_v2rqTuMYPjbyA@mail.gmail.com>
In-Reply-To: <CAAe_U6J3p9Lh9g82tSSLxOJ7nqrozdRe11zV_v2rqTuMYPjbyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205312046.14823.arnd@arndb.de>
X-Provags-ID: V02:K0:pDsIDD3JCIO6a6wJdW36LEp7hHMB3iXiSYAjX4Pg6Gr
 WpTHtep9p7uv2d+MjCPbBprmMJszhwx2tBDZfY9Egli+ZNzwdu
 zfYTBwXauSpIjyOXQpP7nmwL2G5Wseq80Y5Gzhk1YYoY7W4Js6
 lvz0/aaAnvaXpjhRsaA29R/s0ED/s7iRJI1fTxtc+aqiPEBUGN
 xH/wTyYFwCKQLHOxKa02G5GcuscCHUyE/VCJ1kSFB8+hlqMtpE
 uqZkmG1Ny7kCxVi2TBMpPVWXfkYbNLBirEC3y6xggYukxSUwG0
 bmryUJXf+lPyFIn/j+1tOrWba9M46y/piNxtuecVcLY2me6CwB
 81vK8XzzNsfERZun3duI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 May 2012, ABRAHAM, KISHON VIJAY wrote:
> > I would mark the multiplexed device compatible with "simple-bus", which
> > results in the child devices automatically getting added.
> 
> hmm.. ocp2scp has a sysconfig register and it also has a module mode
> by which it can be enabled/disabled. I was making use of pm_runtime
> API's to control these registers (Apart from creating child devices,
> the driver also has a call to pm_runtime_enable). 

I see. 

> I'm not sure if with
> "simple-bus" we'll be able to do those. I have to check on that.

How about making it compatible with both "simple-bus" and something
that handles the pm_runtime requirements?

I don't understand enough of what needs to be done for pm_runtime
across a lot of devices, but I'd hope that it should be possible
to do that in a generic way based on the device definition.

	Arnd
