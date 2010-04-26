Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0DZKDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 06:03:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:39079 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab0DZKDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 06:03:38 -0400
Message-ID: <4BD564BE.6020700@kernel.org>
Date: Mon, 26 Apr 2010 12:02:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alex Shi <alex.shi@intel.com>, tim.c.chen@intel.com
Subject: Re: [Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vjH.sRSzLB@tosh>	 <alpine.DEB.2.00.1004221045270.1204@router.home>	 <4BD086D0.9090309@cs.helsinki.fi>	 <alpine.DEB.2.00.1004232214520.29018@melkki.cs.helsinki.fi>	 <1272265147.2078.648.camel@ymzhang.sh.intel.com> <i2m84144f021004260022nb58e3e27vd351d6646b99f265@mail.gmail.com>
In-Reply-To: <i2m84144f021004260022nb58e3e27vd351d6646b99f265@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 26 Apr 2010 10:02:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/26/2010 09:22 AM, Pekka Enberg wrote:
> On Mon, Apr 26, 2010 at 9:59 AM, Zhang, Yanmin
> <yanmin_zhang@linux.intel.com> wrote:
>>> I haven't been able to reproduce this either on my Core 2 machine.
>> Mostly, the regression exists on Nehalem machines. I suspect it's related to
>> hyper-threading machine.
> 
> OK, so does anyone know why hyper-threading would change things for
> the per-CPU allocator?

My wild speculation is that previously the cpu_slub structures of two
neighboring threads ended up on the same cacheline by accident thanks
to the back to back allocation.  W/ the percpu allocator, this no
longer would happen as the allocator groups percpu data together
per-cpu.

Thanks.

-- 
tejun
