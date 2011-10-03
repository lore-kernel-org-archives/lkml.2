Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1JCJiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:38:20 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:54770 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab1JCJiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:38:14 -0400
Message-ID: <4E898284.7060906@linux.vnet.ibm.com>
Date: Mon, 03 Oct 2011 15:08:12 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Pavel Ivanov <paivanof@gmail.com>
CC: ecryptfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Full lockup when compiling kernel with "optimal" number of threads
References: <CAG1a4rvdYnOSWu3DJ+DL+Q_bfsfTv_px20vP06fBKRm6B8cwMw@mail.gmail.com>
In-Reply-To: <CAG1a4rvdYnOSWu3DJ+DL+Q_bfsfTv_px20vP06fBKRm6B8cwMw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2011 09:04 AM, Pavel Ivanov wrote:
> Hi,
> 
> I can reliably reproduce a complete machine lockup when compiling
> kernel sources with "make -j". After making some progress machine
> stops responding to anything (including CapsLock/NumLock switching or
> mouse moving) and after hard reboot nothing is left in kern.log or
> syslog. Only attaching a serial console gives me the following clues
> to what happens:
> 

[...]

> After that only doing "make distclean" allows me to compile kernel
> again. And note that when I build with "make -j 10" everything works
> fine (I have 2 CPUs with 4 cores each without hyper-threading).

How much memory does your system have? Doing so many fork()s could cause
a lot of resource conflict and memory pressure leading to heavy swapping
etc., which can ultimately hang your system, especially when your RAM
size is small. It is advisable to use make -j only on systems with lot
of RAM (> 3 or 4GB).

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
