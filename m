Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0LALRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:17:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:45967 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab0LALRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:17:46 -0500
Message-ID: <4CF62EE0.7040607@kernel.org>
Date: Wed, 01 Dec 2010 12:17:52 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
References: <20101022012302.GA7487@havoc.gtf.org> <20101129180755.GK15818@bombadil.infradead.org> <4CF506A6.4020200@kernel.org> <20101130153839.GM15818@bombadil.infradead.org> <4CF52652.4030802@kernel.org> <20101130163150.GA25668@bombadil.infradead.org> <20101130175317.GB25668@bombadil.infradead.org> <20101130210938.GF25668@bombadil.infradead.org>
In-Reply-To: <20101130210938.GF25668@bombadil.infradead.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 11:17:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/30/2010 10:09 PM, Kyle McMartin wrote:
>> Ok, running it, I haven't seen the issue across three suspends... Will
>> update when it inevitably happens.
> 
> [10273.011241] ata1.00: internal command failure: stat=0xef
> ehi_desc="irq_stat 0x00400001, PHY RDY changed"

Hmmm, so it's a timing problem.  For some reason, a PHY event is being
reported after reset is complete which unfortunately gets reported
while DIPM command is in progress.  Hmmm... what's broken is that the
PHY event happens after reset is complete.  Can you please attach the
output of "lspci -nn" and "hdparm -I /dev/sda"?  Looks a lot like a
timing issue.  Maybe we'll have to add a delay somewhere.  :-(

-- 
tejun
