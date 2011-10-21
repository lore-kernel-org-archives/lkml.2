Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1JUIcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 04:32:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab1JUIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 04:32:34 -0400
Message-ID: <4EA12E1D.4010504@suse.cz>
Date: Fri, 21 Oct 2011 10:32:29 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: gxt@mprc.pku.edu.cn
Cc: Axel Lin <axel.lin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: rtc-puv3: Add __devinit and __devexit markers for
 probe and remove
References: <1317824987.2674.1.camel@phoenix> <1318922541.1789.36.camel@epip-laptop>
In-Reply-To: <1318922541.1789.36.camel@epip-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.10.2011 09:22, Guan Xuetao wrote:
> Hi Axel,
> The patch yield following warnings:
> 
> WARNING: drivers/rtc/built-in.o(.data+0x90): Section mismatch in
> reference from the variable puv3_rtcdrv to the
> function .devinit.text:puv3_rtc_probe()
> The variable puv3_rtcdrv references
> the function __devinit puv3_rtc_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the
> variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
> *_console
[...]
> 
> For puv3_rtc_probe, I think it should be in the white-list, but warnings
> are yielded.
> For puv3_rtc_remove, the warning could be disappeared by modifying
> __devexit to __exit, however is it proper?

The warning message tries to hint at the solution. Just name the variable

static struct platform_driver puv3_rtc_driver

and modpost will know that this is simply a list of pointers to driver
functions, in which case the section mismatch is OK (the init function
will only be called at init time).

Michal
