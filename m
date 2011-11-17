Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1KQCgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 21:36:05 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:52707 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755281Ab1KQCgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 21:36:03 -0500
Message-ID: <4EC472A1.6000407@xenotime.net>
Date: Wed, 16 Nov 2011 18:34:09 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux RDMA <linux-rdma@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: linux-next: Tree for Nov 16 (infiniband: ib_srpt.c)
References: <20111116133342.3eb15cac16f4c081dc6ed009@canb.auug.org.au>
In-Reply-To: <20111116133342.3eb15cac16f4c081dc6ed009@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 06:33 PM, Stephen Rothwell wrote:
> Hi all,


When CONFIG_BUG is not enabled:

next-2011-1116/drivers/infiniband/ulp/srpt/ib_srpt.c: In function 'srpt_cm_dreq_recv':
next-2011-1116/drivers/infiniband/ulp/srpt/ib_srpt.c:2761:3: error: implicit declaration of function '__WARN'


jbd2 has a similar issue (still unpatched).  One of the comments in that thread
was that ext4 probably should use WARN_ON() instead of __WARN().

Or (Arnd said):
Hmm, my feeling is that we shouldn't do that either, and that jbd2 should
be changed. If we want a function that does what __WARN() does today, we
should probably make a conscious decision about what we want it to be called
and not have it start with "__". <end Arnd>


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
