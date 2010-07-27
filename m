Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab0G0IIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:08:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41089 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab0G0IID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:08:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C4E93CC.5030109@s5r6.in-berlin.de>
Date: Tue, 27 Jul 2010 10:07:40 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux1394-devel@lists.sourceforge.net, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ieee1394 tree
References: <20100727114839.06d25309.sfr@canb.auug.org.au>
In-Reply-To: <20100727114839.06d25309.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> After merging the ieee1394 tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/firewire/nosy.c: In function 'packet_buffer_get':
> drivers/firewire/nosy.c:154: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> drivers/firewire/nosy.c:154: error: implicit declaration of function 'signal_pending'
> drivers/firewire/nosy.c:154: error: implicit declaration of function 'schedule'
> drivers/firewire/nosy.c: In function 'packet_buffer_put':
> drivers/firewire/nosy.c:221: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> drivers/firewire/nosy.c: In function 'remove_card':
> drivers/firewire/nosy.c:514: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> 
> Forgot to include something?
> 
> I have used the ieee1394 tree from next-20100726 for today.

Oh right.  Every user of <linux/wait.h> must also include
<linux/sched.h>, unfortunately.  I saw the same problem months ago with
another driver, I wonder why I did not catch it this time.

I will fix it later today.  This code is in a topic branch for a new
driver; I will rewrite that branch to stay fully bisectable.
-- 
Stefan Richter
-=====-==-=- -=== ==-==
http://arcgraph.de/sr/
