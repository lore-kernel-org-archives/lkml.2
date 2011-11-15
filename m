Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1KOSt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:49:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57752 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab1KOStz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:49:55 -0500
Date: Tue, 15 Nov 2011 20:49:35 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Yong Zhang <yong.zhang0@gmail.com>
cc: Shaohua Li <shaohua.li@intel.com>, Christoph Lameter <cl@linux.com>,
        Julie Sullivan <kernelmail.jms@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: INFO: possible recursive locking detected: get_partial_node()
 on 3.2-rc1
In-Reply-To: <20111115072251.GA10389@zhy>
Message-ID: <alpine.LFD.2.02.1111152049210.1888@tux.localdomain>
References: <20111109090556.GA5949@zhy> <201111102335.06046.kernelmail.jms@gmail.com> <1320980671.22361.252.camel@sli10-conroe> <alpine.DEB.2.00.1111110857330.3557@router.home> <1321248853.22361.280.camel@sli10-conroe> <20111115072251.GA10389@zhy>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011, Yong Zhang wrote:
>> Subject: slub: move discard_slab out of node lock
>>
>> Lockdep reports there is potential deadlock for slub node list_lock.
>> discard_slab() is called with the lock hold in unfreeze_partials(),
>> which could trigger a slab allocation, which could hold the lock again.
>>
>> discard_slab() doesn't need hold the lock actually, if the slab is
>> already removed from partial list.
>>
>> Reported-and-tested-by: Yong Zhang <yong.zhang0@gmail.com>
>> Reported-and-tested-by: Julie Sullivan <kernelmail.jms@gmail.com>
>> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>
> Tested-by: Yong Zhang <yong.zhang0@gmail.com>

Applied, thanks!
