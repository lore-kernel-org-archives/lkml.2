Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab2EHCqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 22:46:48 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43319 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab2EHCqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 22:46:47 -0400
Date: Tue, 8 May 2012 10:46:12 +0800
From: Richard Yang <weiyang@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>,
        Wei Yang <weiyang.kernel@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: One problem in reassign pci bus number?
Message-ID: <20120508024612.GA11485@richard>
Reply-To: Richard Yang <weiyang@linux.vnet.ibm.com>
References: <CAE9FiQUVNA_jdRfsSR9Rv47aa6JX-HKET0z3SfK19wT=Fcd9Cg@mail.gmail.com>
 <20120504024721.GA6775@richard>
 <CAE9FiQUz2w815gU5vY5b0BPf+1pz_pafgzqVKizJC++z27RTaQ@mail.gmail.com>
 <20120504045205.GA21624@richard>
 <CAE9FiQWM4OTFp5NN+KOXxNREQxNWipDjWbbPPiHHJsb6yFmuiQ@mail.gmail.com>
 <20120506151715.GA7773@richard>
 <CAE9FiQWsSWK-_zGe1ggaKuZu+RJ1kb1zuTEokdxqFSbE3UjNRw@mail.gmail.com>
 <CAE9FiQXKjxLDLeh8TXU_OCNwFt+UMv3qFjcPrKcPcorA1YmkdQ@mail.gmail.com>
 <20120507011722.GA8122@richard>
 <CAE9FiQUpcJdAvK=wisNc_zq5c9zDtgEM=MNugDcHN9h3=ZPUcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUpcJdAvK=wisNc_zq5c9zDtgEM=MNugDcHN9h3=ZPUcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12050716-1396-0000-0000-0000011C2E71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 07:04:09PM -0700, Yinghai Lu wrote:
>On Sun, May 6, 2012 at 6:17 PM, Richard Yang <weiyang@linux.vnet.ibm.com> wrote:
>> so this free space will be combined with the free space got from
>> parent, form a big space to meet the requirement.
>>
>> This is the general idea about probe_resource()?
>>
>> And this is the design decision to find the free space at the end
>> of top, even at the start we have more free space?
>
>no, probe_resource will get from start if space is big enough.
>
>if not, it will try to extend top.

Hmm... for example we still have this
               parent[70-160]
brother1[70-80]  res[90-150]  brother2[151-160]
                   ->child[105-140]

if we call probe_resource(res, new_res, 16, par, 1, 0xff,
IORESOURCE_PCI_FIXED);

I think this call is used to allocate a res of size 16 under res.
When there is no enough free space, it will expend res, and res->parent.

While in this situation, res doesn't have enough free space. so it need
to expend itself. 

In the probe_resource() it tries to extend res on the right side. 
So even there is enough space between brother1 and res, I think the
probe_resource() will not return 0.

Do you think my analysis is correct?
>
>Yinghai

-- 
Richard Yang
Help you, Help me

