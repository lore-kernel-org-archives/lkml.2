Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab2GERpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:45:34 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:48777 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab2GERpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:45:32 -0400
Message-ID: <4FF5D2B7.6080602@hp.com>
Date: Thu, 05 Jul 2012 10:45:27 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: mst@redhat.com, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 0/5] Multiqueue virtio-net
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1341484194-8108-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 03:29 AM, Jason Wang wrote:

>
> Test result:
>
> 1) 1 vm 2 vcpu 1q vs 2q, 1 - 1q, 2 - 2q, no pinning
>
> - Guest to External Host TCP STREAM
> sessions size throughput1 throughput2   norm1 norm2
> 1 64 650.55 655.61 100% 24.88 24.86 99%
> 2 64 1446.81 1309.44 90% 30.49 27.16 89%
> 4 64 1430.52 1305.59 91% 30.78 26.80 87%
> 8 64 1450.89 1270.82 87% 30.83 25.95 84%

Was the -D test-specific option used to set TCP_NODELAY?  I'm guessing 
from your description of how packet sizes were smaller with multiqueue 
and your need to hack tcp_write_xmit() it wasn't but since we don't have 
the specific netperf command lines (hint hint :) I wanted to make certain.

Instead of calling them throughput1 and throughput2, it might be more 
clear in future to identify them as singlequeue and multiqueue.

Also, how are you combining the concurrent netperf results?  Are you 
taking sums of what netperf reports, or are you gathering statistics 
outside of netperf?

> - TCP RR
> sessions size throughput1 throughput2   norm1 norm2
> 50 1 54695.41 84164.98 153% 1957.33 1901.31 97%

A single instance TCP_RR test would help confirm/refute any non-trivial 
change in (effective) path length between the two cases.

happy benchmarking,

rick jones
