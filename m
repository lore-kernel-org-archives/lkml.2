Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2GJPAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:00:44 -0400
Received: from smtp201.dfw.emailsrvr.com ([67.192.241.201]:45705 "EHLO
	smtp201.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab2GJPAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:00:43 -0400
Message-ID: <4FFC4399.3050407@calxeda.com>
Date: Tue, 10 Jul 2012 10:00:41 -0500
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, sparclinux@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: bisected regression since 3.5-rc5 - hang on boot on some sparc64
 machines
References: <alpine.SOC.1.00.1207091627480.17307@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1207091627480.17307@math.ut.ee>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 06:09 AM, Meelis Roos wrote:
> A regression since 3.5-rc5 stops Sun Fire V100 and Sun Netra X1 sparc64 
> machines from booting, hanging after enabling serial console. Several 
> different other sparc64 systems work fine with 3.5-rc6. prtconf and full 
> dmesg below.
> 
> Bisecting leads to
> 107a84e61cdd3406c842a0e4be7efffd3a05dba6 is the first bad commit
> commit 107a84e61cdd3406c842a0e4be7efffd3a05dba6
> Author: Thierry Reding <thierry.reding@avionic-design.de>
> Date:   Thu Jun 14 09:12:35 2012 +0200
> 
>     of: match by compatible property first
>     
>     When matching devices against an OF device ID table, the first string of
>     the compatible property that is listed in the table should match,
>     regardless of its position in the table.
>     
>     Cc: Grant Likely <grant.likely@secretlab.ca>
>     Cc: Rob Herring <rob.herring@calxeda.com>
>     Cc: devicetree-discuss@lists.ozlabs.org
>     Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>     Signed-off-by: Rob Herring <rob.herring@calxeda.com>

The problem is match combinations of compatible plus name and/or type
fail to match correctly. I have a fix for this, but given how late it is
for 3.5 I think it is best to revert this for now. There could be other
cases that rely on the current although wrong behavior. I will post an
updated version for 3.6.

Linus, Please revert 107a84e61cdd3406c842a0e4be7efffd3a05dba6.

Rob
