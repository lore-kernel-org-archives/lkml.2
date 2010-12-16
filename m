Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0LPB2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 20:28:42 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:61237 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab0LPB2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 20:28:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=iHYvgsNv5J99C3aVc++OExrd/0N8SN/41SPQ8CddM+DLs46Awb/ESTMWNBlYhGmIrl
         znkNRSJluirU+/Kr0K4Xg5tA9sR+o7qHVzIna9E0dcHFKekAqIrZwrOS7FNz9SnBeQ4T
         TtN3myLvULqmUf6elCjutCtnVjtiqTYCm/kvE=
MIME-Version: 1.0
In-Reply-To: <20101216011425.GA17446@linux-os.sc.intel.com>
References: <cover.1292405004.git.fenghua.yu@intel.com> <46a08278c2ba21737528eb4b77391a7e8bc88000.1292405004.git.fenghua.yu@intel.com>
 <1292446118.2603.11.camel@edumazet-laptop> <20101216011425.GA17446@linux-os.sc.intel.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Thu, 16 Dec 2010 09:28:15 +0800
Message-ID: <AANLkTingt6SM+uasicwPSJRE5vYpvJ=GyFf3bbKhO72G@mail.gmail.com>
Subject: Re: [PATCH 1/3] Kernel interfaces for multiqueue aware socket
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "Tang, Xinan" <xinan.tang@intel.com>,
        Junchang Wang <junchangwang@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 9:14 AM, Fenghua Yu <fenghua.yu@intel.com> wrote:
>
> SKF_AD_QUEUE doesn't know number of rx queues. Thus user application can't
> specify right SKF_AD_QUEUE.

It is wrong. AFAIK, you can get the queue number through
/sys/class/net/eth*/queues/ or /proc/interrupts


>
> SKF_AD_QUEUE only works for rx. There is no queue bound interfaces for tx.

Do you really need queue number? The packets must be already spreaded
among CPUs, I think you means the current CPU number. Please see
SKF_AD_CPU added by Eric.

>
> I can change the patch set to use SKF_AD_QUEUE by removing the set rx queue
> interface and still keep interfaces of
> #define SIOGNUMRXQUEUE 0x8939  /* Get number of rx queues. */
> #define SIOGNUMTXQUEUE 0x893A  /* Get number of tx queues. */
> #define SIOSTXQUEUEMAPPING     0x893C  /* Set tx queue mapping. */
> #define SIOGRXQUEUEMAPPING     0x893D  /* Get rx queue mapping. */
> #define SIOGTXQUEUEMAPPING     0x893E  /* Get tx queue mapping. */
>
>>
>> Also your AF_PACKET patch only address mmaped sockets.
>>
> The new patch set will use SKF_AD_QUEUE for rx. So it won't be limited to mmaped
> sockets.
>

If you turn to SKF_AD_QUEUE, I think no patch for kernel is needed.


-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
