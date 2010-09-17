Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0IQQSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 12:18:52 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58070 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266Ab0IQQSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:18:51 -0400
Subject: Re: [RFC][PATCH 0/1] kmemleak: Fix false positive with alias
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: linux-kernel@vger.kernel.org, ext-phil.2.carmody@nokia.com,
        linux-omap@vger.kernel.org
In-Reply-To: <20100810.184903.214240645.Hiroshi.DOYU@nokia.com>
References: <1276841055-13843-1-git-send-email-Hiroshi.DOYU@nokia.com>
	 <1277736372.25271.102.camel@e102109-lin.cambridge.arm.com>
	 <20100629.074423.71111160.Hiroshi.DOYU@nokia.com>
	 <20100810.184903.214240645.Hiroshi.DOYU@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 17 Sep 2010 17:18:47 +0100
Message-ID: <1284740327.32322.24.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2010 16:18:47.0371 (UTC) FILETIME=[01A8E9B0:01CB5684]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-10 at 18:49 +0300, Hiroshi DOYU wrote:
> Now there's not much difference with the attached patch, a new version
> of alias.
> 
> / # modprobe kmemleak-special-test use_alias=0
> / # time echo scan > /sys/kernel/debug/kmemleak
> real    0m 2.30s
> user    0m 0.00s
> sys     0m 2.30s
> 
> / # modprobe kmemleak-special-test use_alias=1
> / # time echo scan > /sys/kernel/debug/kmemleak
> real    0m 3.91s
> user    0m 0.00s
> sys     0m 3.91s

So to understand - the first case is memory scanning without any aliases
configured. The second case is the alias scanning using a separate
prio_tree. The impact seems to be quite big.

But I wouldn't complicate the code with the callback mechanism,
especially when loadable modules are considered. Is the pointer
conversion always linear? Maybe we can just add an offset to the
scan_area structure that is used for conversion rather than a callback.

Another advantage of the linear offset would be that we can avoid the
call for removing the conversion.

Is this feasible for your needs? No point really in making it too
generic if the simple offset would (hopefully) do.

-- 
Catalin

