Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2KPPhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:37:23 -0500
Received: from void.printf.net ([89.145.121.20]:58392 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab2KPPhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:37:21 -0500
From: Chris Ball <cjb@laptop.org>
To: Trey Ramsay <tramsay@linux.vnet.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        Rich Rattanni <rattanni@gmail.com>,
        Radovan Lekanovic <lekanovic@gmail.com>
Subject: Re: [PATCH 1/1] mmc: Bad device can cause mmc driver to hang
References: <87k3tpkz53.fsf@octavius.laptop.org>
	<1353079901-8773-1-git-send-email-tramsay@linux.vnet.ibm.com>
Date: Fri, 16 Nov 2012 10:37:12 -0500
In-Reply-To: <1353079901-8773-1-git-send-email-tramsay@linux.vnet.ibm.com>
	(Trey Ramsay's message of "Fri, 16 Nov 2012 09:31:41 -0600")
Message-ID: <876255bluf.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trey,

On Fri, Nov 16 2012, Trey Ramsay wrote:
> There are infinite loops in the mmc code that can be caused by bad hardware.
> The code will loop forever if the device never comes back from program mode,
> R1_STATE_PRG, and it is not ready for data, R1_READY_FOR_DATA.
>
> A long timeout will be added to prevent the code from looping forever.
> The timeout will occur if the device never comes back from program
> state or the device never becomes ready for data.
>
> Signed-off-by: Trey Ramsay <tramsay@linux.vnet.ibm.com>

Thanks, looks good!

Have you thought about what's going to happen after this path is hit?
Are we just going to start a new request that begins a new ten-minute
hang, or do we notice the bad card state somewhere and refuse to start
new I/O?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
