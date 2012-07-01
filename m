Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2GASrk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:47:40 -0400
Received: from seven.medozas.de ([5.9.24.206]:56249 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab2GASrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:47:39 -0400
Date: Sun, 1 Jul 2012 20:47:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: John Stultz <johnstul@us.ibm.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2][RFC] Potential fix for leapsecond caused futex issue
 (v2)
In-Reply-To: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
Message-ID: <alpine.LNX.2.01.1207012039130.21627@frira.zrqbmnf.qr>
References: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2012-07-01 20:29, John Stultz wrote:
>
>An apparent  workaround for this issue is running:
>$ date -s "`date`"
>
>Credit: http://www.sheeri.com/content/mysql-and-leap-second-high-cpu-and-fix

One can run the date call even while ntpd keeps running.

>TODOs:
>* Chase down the futex/hrtimer interaction to see if this could
>be triggered in any other way.
>* Get Tglx's input/ack
>* Generate a backport for pre-v3.4 kernels

It looks like 2.6.37.6 is not affected (on a system where ntpd is 
running). That is to say, at least the mysqld instance on such a system 
did not jump to high CPU usage. I did not try your testcase.c there, 
since that would likely freak out the webapps - or the management.

Other reports on IRC include that 2.6.32-71.el6 (RHEL) is affected. 
(Backporting gone wrong, *snicker* ;)
