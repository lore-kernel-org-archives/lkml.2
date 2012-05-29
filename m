Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2E2VwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 17:52:01 -0400
Received: from relay2.sgi.com ([192.48.179.30]:45753 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751605Ab2E2VwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 17:52:00 -0400
Message-ID: <4FC544FE.3000204@sgi.com>
Date: Tue, 29 May 2012 14:51:58 -0700
From: Michael Reed <mdr@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Karandeep Chahal <kchahal@ddn.com>
CC: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        dillowda@ornl.gov, roland@kernel.org, sean.hefty@intel.com
Subject: Re: [PATCH 1/1] ib_srp: Infiniband srp fast failover patch.
References: <4FC53AAA.3060203@ddn.com>
In-Reply-To: <4FC53AAA.3060203@ddn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did you subsequently reconnect the target and confirm appropriate behavior?


On 05/29/2012 02:07 PM, Karandeep Chahal wrote:
> Subject: [PATCH] Infiniband srp fast failover patch. Currently ib_srp does
>    not do anything on receiving a DREQ from the target, it
>    only sends a response back. Further it also does not
>    monitor port (down) events. I have patched srp to remove
>    scsi devices when a port down event is received or if the
>    target sends a DREQ. Currently even though the target
>    notifies the initiator of its intentions of going away, the
>    initiator ignores that information. Later the initiator
>    gets upset when the devices "suddenly" disappear resulting
>    in srp initiating an error recovery process which takes a
>    long time. This caused high failover latencies as compared
>    to fibre channel. In my experiments with RHEL 6.0 and 6.2 I
>    encountered failover time that exceeded 2 minutes and 20
>    seconds (despite tweaking /etc/multipath.conf and
>    /sys/block/<>/timeout). With this patch the failover takes
>    30 seconds. I have tested this patch with and without a
>    switch.
>
> Yours, etc.
> Karan
>
