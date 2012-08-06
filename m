Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2HFH6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 03:58:33 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53970 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2HFH6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 03:58:31 -0400
Message-ID: <501F7904.4050206@linux.vnet.ibm.com>
Date: Mon, 06 Aug 2012 13:27:56 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@ozlabs.org
Subject: Re: how to implement platform specific per process parameter?
References: <501F514C.2090909@ozlabs.ru>
In-Reply-To: <501F514C.2090909@ozlabs.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12080607-3568-0000-0000-00000241A99E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are 4 options:

> 1. [not a kernel interface] use ptrace to execute the register changing
> command inside the specified pid. The next context switch saves the new
> value in the thread_struct. Dirty hack.
> 
> 2. Add a new syscall which would receive pid + register value and do the
> job. A bit too much.
> 
> 3. Add some hook in /proc filesystem but so far there were no platform
> specific bits, right?
> 
> 4. Implement a static node "/sys/devices/system/cpu/dscr_control".
> write() would parse the input stream, call scanf("%d %x", &pid, &dscr)
> and do the job.
> 


/sys/ interface would be appropriate I believe. But in this way we can take a new
(pid, dscr) and update thread_struct. But there should be a way to enlist all
(pid, dscr) values which are explicitly set by the user and different than that
of /sys/devices/system/cpu/dscr_default. So that we can know which process is holding
to what value of DSCR at any point of time.

 

> What is the correct approach? Thanks.
> 
> 


Regards
Anshuman

