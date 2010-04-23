Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab0DWCFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:05:53 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64887 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab0DWCFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PgBfzbCwatyoFWcj6Jc5+Oqhnq0st9UX/GoUmZ6qbRxFJCrEuxy36CfItvYwru/1WB
         6LKTz22xieCkCZPtzZwP40FeH5PWwlLx0C9RNBJE0PKXzVD540x1Oi1MaRBcTZSVUi5R
         Zk2Tbjqa0IK54lBnTXwbWrbAoGGO1Vk6jyfcg=
Message-ID: <4BD1007C.2000300@pobox.com>
Date: Thu, 22 Apr 2010 22:05:48 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.34-rc3 v2 Disable R_OK (Early ACK) on SII 3726 PMP
References: <g2ida824cf31004141843p41f7b21fz25927e3c6faeeed7@mail.gmail.com>
In-Reply-To: <g2ida824cf31004141843p41f7b21fz25927e3c6faeeed7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 09:43 PM, Grant Grundler wrote:
> In 2009, While running "cache read" performance test of drives behind
> SII PMP we encountered a "all 5 drives" timeout on more than 30% of the
> machines under test.  This patch reduces the rate by a factor of about 70.
> Low enough that we didn't care to further investigate the issue.
>
> Performance impact with any sort of "normal" use was ~2%+ CPU and less
> than 1% throughput degradation.  Worst case impact (cached read) was
> 6% IOPS reduction. This is with NCQ off (q=1) but I believe FIS based
> switching enabled in the SATA driver.
>
> The patch disables "Early ACK" in the 3726 port multiplier.
> "Early ACK" is issued when device sends a FIS to the host (via PMP)
> and the PMP sends an ACK immediately back to the device - well before
> the host gets the response. Under worst case IOPs load (cached read
> test) and more than 2 PMPs connected to a 4-port SATA controller,
> I suspect the time to service all of the PMPs is exceeding the PMPs
> ability to keep track of outstanding FIS it owes the Host. Reducing
> the number of PMPs to 2 (or 1) reduces the frequency by several orders
> of magnitude. Kudos to Gwendal for initial debugging of this issue.
> [Any errors in the description are mine, not his.]
>
> Patch is currently in production on Google servers.
>
> Signed-off-by: Grant Grundler<grundler@google.com>
> Signed-off-by: Gwendal Grignou<gwendal@google.com>
> Acked-by: Tejun Heo<tj@kernel.org>
>
> ---
>
> v2: dropped references to 4726 since I didn't test 4726,
>      moved register definition directly into libata-pmp.c, and
>      expanded the comment in the code to summarize the above description.
>
> Code below is white space mangled. Please use attached file.

applied manually, please figure out a way to send patches that can be 
applied directly using the standard automated tools (== git am) that 
everyone uses


