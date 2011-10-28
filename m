Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1J1TuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 15:50:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39232 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab1J1TuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 15:50:13 -0400
Message-ID: <4EAB0772.40404@garzik.org>
Date: Fri, 28 Oct 2011 15:50:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: linus.walleij@linaro.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        swarren@nvidia.com, Olof Johansson <olof@lixom.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>, bs14@csr.com
Subject: Zero-length ARM headers in git HEAD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gents,

In the following kernel commits,

	9c587c05d715ca8461342c2cb3b4a67036b5c22b
	ea5abbd215b749b2ff14397a47a5e65741c67bf4
	cc890cd78acd7ab03442907d354b6af34e973cb3

the file ...$platform/mach/gpio.h is replaced with an empty file.  This 
disagrees with kernel tradition and kernel makefiles, where zero length 
files are intentionally deleted when "make distclean" is executed.

As a result, git sequences such as "make distclean ; git checkout 
master" may fail, because several files are present in the index but not 
on disk, making it appear as if modifications have been made:

	$ git checkout master
	D	arch/arm/mach-lpc32xx/include/mach/gpio.h
	D	arch/arm/mach-tegra/include/mach/gpio.h
	D	arch/arm/mach-u300/include/mach/gpio.h

An update, either (a) making these files non-zero length or (b) deleting 
the files in git would be appreciated.  Reading the commit descriptions, 
it appears (a) is the correct path?

	Jeff



