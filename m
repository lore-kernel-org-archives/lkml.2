Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0KFJbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 05:31:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34784 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab0KFJbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 05:31:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CD52059.7010503@s5r6.in-berlin.de>
Date: Sat, 06 Nov 2010 10:31:05 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] SCSI host lock push-down
References: <20101105002409.GA21714@havoc.gtf.org>
In-Reply-To: <20101105002409.GA21714@havoc.gtf.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> An alternate arrangement, not presented by this patch, might
> be preferred:  in order to make it clear that queuecommand
> locking has changed, one could s/queuecommand/queuecommand_nl/ in
> Scsi_Host_Template, in order to guarantee that drivers are either
> (a) upgraded or (b) broken at compile time.  Compile-time detection of
> new locking may be desirable, and I'll volunteer to change my patch to
> do that, if community members prefer that route instead of below.

I followed only a fraction of the related discussion.  Thus I wonder why a
renaming of scsi_host_template.queuecommand was not part of these attempts
from the very outset.

Given the choice between compile-time breakage of unconverted drivers and
silent invalidation of potential locking assumptions at runtime, the
preferable way forward is quite clear IMO.

(Since no coexistence period of .queuecommand and .queuecommand_nl or
.unlocked_queuecommand is planned, how about you rename it to .queue_command?
Follows Linux naming conventions more closely.)
-- 
Stefan Richter
-=====-==-=- =-== --==-
http://arcgraph.de/sr/
