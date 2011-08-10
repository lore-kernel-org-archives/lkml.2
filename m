Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1HJKou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 06:44:50 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:17542 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1HJKot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 06:44:49 -0400
Date: Wed, 10 Aug 2011 12:41:43 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] staging: vme: allow explicit assignment of bus
 numbers
Message-ID: <20110810104143.GA14060@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>, gregkh@suse.de,
	cota@braap.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1312968830-13377-1-git-send-email-manohar.vanga@cern.ch>
 <1312968830-13377-2-git-send-email-manohar.vanga@cern.ch>
 <4E425725.7080305@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E425725.7080305@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martyn,

> I'm sorry, I'm still simply not convinced by this patch:
> 
> 1) For a single bus driver (i.e. in the situation where we have 2 bridges of
> the same type), the numbering of the buses is still dependent on the order
> that they are found in the scan.

Yes this is still a bug. But this patch doesn't address this case.

> 2) If the bridge drivers are loaded as modules, I have a feeling they will be
> loaded sequentially and therefore the order of the bridges would only change
> if the order of the loading of the drivers changed.

And this is a major problem when it comes to multiple bridges of differing
types. What I'm saying is that this patch simply fixes this one problematic
case. We can move this out as soon as we have a more robust implementation.

As of now however, I think applying this is useful as we have a decent
workaround to the problem. If you want I can make the fact of it being
applicable only to cases with differing bridges explicit in the commit
message.

--
/manohar
