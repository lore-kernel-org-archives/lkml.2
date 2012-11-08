Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2KHRLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:11:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36992 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab2KHRLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:11:36 -0500
Message-ID: <509BE7C5.4030109@wwwdotorg.org>
Date: Thu, 08 Nov 2012 10:11:33 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/2] pinctrl/nomadik: make independent of prcmu driver
References: <1352375742-29611-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1352375742-29611-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 04:55 AM, Linus Walleij wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
> 
> Currently there are some unnecessary criss-cross
> dependencies between the PRCMU driver in MFD and a lot of
> other drivers, mainly because other drivers need to poke
> around in the PRCM register range.
> 
> In cases like this there are actually just a few select
> registers that the pinctrl driver need to read/modify/write,
> and it turns out that no other driver is actually using
> these registers, so there are no concurrency issues
> whatsoever.
> 
> So: don't let the location of the register range complicate
> things, just poke into these registers directly and skip
> a layer of indirection.

Do you actually need to store the run-time data in struct
nmk_pinctrl_soc_data too? I would have expected all the soc_data
pointers to remain const, and to store the runtime register pointer
somewhere else, and perhaps pass it as a separate parameter to the
relevant init functions; wouldn't that make the patch much smaller?
