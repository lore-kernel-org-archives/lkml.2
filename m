Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab1DLHN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:13:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37330 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab1DLHNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qOQU4k3rLZGqsUXJWClkqS3hitGm/MqWiAFZw8eyxvcnUvcQRmq1pkG/3nF2lBFxE4
         sMs0UwN4x2rPWAfdhb8P5Kk1d09vzL/pNGTgxs5mQi+J8TnezRXZJd8rybNZMy22/oZ6
         pL8mEf6O5YY+8XwAoeZwXzXE6lDQ/cVYzfLyw=
Date: Tue, 12 Apr 2011 16:13:18 +0900
From: Tejun Heo <tj@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Brian Gerst <brgerst@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86-64, NUMA: reimplement cpu node map initialization
 for fake numa
Message-ID: <20110412071318.GA10425@mtj.dyndns.org>
References: <20110412040037.GK9673@mtj.dyndns.org>
 <20110412133842.6A37.A69D9226@jp.fujitsu.com>
 <20110412153212.B514.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412153212.B514.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, KOSAKI.

On Tue, Apr 12, 2011 at 03:31:42PM +0900, KOSAKI Motohiro wrote:
> Unfortunately, don't work.
> full dmesg is below.
...
> [    0.220979] ERROR: groups don't span domain->span
> [    0.222122] divide error: 0000 [#1] SMP
> [    0.222975] last sysfs file:
> [    0.222975] CPU 0
> [    0.222975] Modules linked in:
> [    0.222975]
> [    0.222975] Pid: 1, comm: swapper Not tainted 2.6.39-rc1+ #2 FUJITSU-SV   

Hmmm... looks like the added condition didn't trigger at all.  I'm
travelling until the end of the next week and can only test using qemu
which I don't think supports sibling topology.  Can you please add
some printks in the sibling link function and find out why the
condition isn't triggering?  Thank you.

-- 
tejun
