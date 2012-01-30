Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2A3WXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:23:16 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:46028 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2A3WXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:23:15 -0500
Message-ID: <4F271849.302@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 03:53:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] PM/Freezer: Make thaw_processes() thaw only userspace
 tasks
References: <20120130220259.9442.70091.stgit@srivatsabhat.in.ibm.com> <20120130220419.9442.39596.stgit@srivatsabhat.in.ibm.com> <20120130220919.GC27616@google.com>
In-Reply-To: <20120130220919.GC27616@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12013022-2674-0000-0000-0000032BB974
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 03:39 AM, Tejun Heo wrote:

> On Tue, Jan 31, 2012 at 03:34:57AM +0530, Srivatsa S. Bhat wrote:
>> Currently the situation is:
>>
>> freeze_processes() - freezes only userspace tasks
>> freeze_kernel_threads() - freezes only kernel threads
>> thaw_kernel_threads() - thaws only kernel threads
>> thaw_processes() - thaws *everything* (both userspace tasks and kernel threads)
>>
>> The point that thaw_processes() thaws everything is rather unintuitive
>> and can lead to bugs. So, modify thaw_processes() so that it thaws only
>> userspace processes. This way we can also have more control over what
>> exactly gets thawed in different situations.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> Maybe I'm misreading it but doesn't this introduce window where kernel
> tasks aren't thawed between this patch and the following ones?  It
> looks like this one should come later.
> 


Yes, I was aware that it introduces such a window. But I ignored it in the
interest of making the patch series sensible (as in, for example, patch
2/4 wouldn't make much sense without patch 1/4).
Maybe I will interchange patch 1 and patch 2 and just reword the patch
descriptions suitably so that they still make sense..

Thanks a lot!

Regards,
Srivatsa S. Bhat

