Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1JUImV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 04:42:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab1JUImU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 04:42:20 -0400
Message-ID: <4EA1306B.5070001@suse.cz>
Date: Fri, 21 Oct 2011 10:42:19 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: gxt@mprc.pku.edu.cn
Cc: Axel Lin <axel.lin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: rtc-puv3: Add __devinit and __devexit markers for
 probe and remove
References: <1317824987.2674.1.camel@phoenix> <1318922541.1789.36.camel@epip-laptop> <4EA12E1D.4010504@suse.cz>
In-Reply-To: <4EA12E1D.4010504@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.10.2011 10:32, Michal Marek wrote:
> The warning message tries to hint at the solution. Just name the variable
> 
> static struct platform_driver puv3_rtc_driver
>
> and modpost will know that this is simply a list of pointers to driver
> functions, in which case the section mismatch is OK (the init function
> will only be called at init time).
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Correction: it's actually a probe function with __devinit, which on most
setups (with CONFIG_HOTPLUG=y) can be called any time, but then on those
setups the __devinit does not cause the section to be freed.
Nevertheless, naming the variable puv3_rtc_driver is the correct solution.

Michal
