Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2EKPFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:05:33 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:38390 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082Ab2EKPFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:05:31 -0400
Message-ID: <4FAD2AB6.7030403@ti.com>
Date: Fri, 11 May 2012 18:05:26 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120509 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        broonie@opensource.wolfsonicro.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TWL6040: fix build error
References: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com> <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com> <4FACB9D7.5090100@ti.com> <20120511072049.GA9088@core.coreip.homeip.net> <4FAD1C38.5050907@windriver.com>
In-Reply-To: <4FAD1C38.5050907@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/11/2012 05:03 PM, Paul Gortmaker wrote:
> Hi Dmitry,
> 
> It should be limited to the platforms where the hardware is available,
> so that coverage builds aren't needlessly spending cycles building
> stuff that can't possibly ever be used.  Also if it is limited to
> ARM, then we can't have an ARM bug like this one mask the x86_64
> allyesconfig build from uncovering possible errors that we really
> care about seeing.

The cleanest way to do this is to make the twl6040 MFD
(CONFIG_TWL6040_CORE) to depend on ARM (or on OMAP). That way none of
the drivers depending on it will got built on non ARM platforms.

-- 
Péter
