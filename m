Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2JBPDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:03:31 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4675 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab2JBPD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:03:28 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Subject: Re: tg3 driver upgrade (Linux 2.6.32 -> 3.2) breaks IBM
 Bladecenter SoL
From: "Michael Chan" <mchan@broadcom.com>
To: "Ferenc Wagner" <wferi@niif.hu>
cc: netdev@vger.kernel.org, "Matt Carlson" <mcarlson@broadcom.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Rob Herring" <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
In-Reply-To: <87a9w5dqle.fsf@lant.ki.iif.hu>
References: <87txuhho5z.fsf@lant.ki.iif.hu>
 <1349083982.5420.16.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <87a9w5dqle.fsf@lant.ki.iif.hu>
Date: Tue, 2 Oct 2012 08:03:05 -0700
Message-ID: <1349190185.5420.21.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7C75DE593OW1035910-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 14:07 +0200, Ferenc Wagner wrote:
> I'm done with bisecting it: the first bad commit is:
> 
> commit dabc5c670d3f86d15ee4f42ab38ec5bd2682487d
> Author: Matt Carlson <mcarlson@broadcom.com>
> Date:   Thu May 19 12:12:52 2011 +0000
> 
>     tg3: Move TSO_CAPABLE assignment
>     
>     This patch moves the code that asserts the TSO_CAPABLE flag closer
> to
>     where the TSO capabilities flags are set.  There isn't a good
> enough
>     reason for the code to be separated.
>     
>     Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
>     Reviewed-by: Michael Chan <mchan@broadcom.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks, I'll look into this.
> 
> On the other hand, losing the SoL console even temporarily during boot
> (as it happens with a minimal kernel before this commit) isn't nice
> either.  I'll try to look after that, too, just mentioning it here... 

This is expected as the driver has to reset the link and you'll lose SoL
for a few seconds until link comes back up.  We can look into an
enhancement to not touch the link if it is already in a good state when
the driver comes up.


