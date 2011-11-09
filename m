Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1KIKfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:35:43 -0500
Received: from brockman.in8.de ([85.214.220.56]:42406 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab1KIKfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:35:42 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Nov 2011 05:35:42 EST
Message-ID: <4EBA560B.1070509@jan-o-sch.net>
Date: Wed, 09 Nov 2011 11:29:31 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>, Arne Jansen <sensille@gmx.net>,
        Andrea Gelmini <andrea.gelmini@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com> <4EB7A6CC.5030502@gmx.net> <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com> <4EB7D2D8.2060505@gmx.net> <CAK-xaQbmY2Z3OJyQ211cUQn0CM2ho2U+UgpRKK9bUzxhEu6hzQ@mail.gmail.com> <4EB8DEAC.7000906@gmx.net> <20111109010701.GI4149@shiny> <20111109074847.GA16742@infradead.org>
In-Reply-To: <20111109074847.GA16742@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.11.2011 08:48, schrieb Christoph Hellwig:
> On Tue, Nov 08, 2011 at 08:07:01PM -0500, Chris Mason wrote:
>> Looks like bio_add_page() is failing and we're getting the enomem from
>> there.  LVM is only letting us put one page in each bio.
>
> Yes, at the moment all bio based DM targets only allow single page I/O.

Wait. If I got that correctly, each bio_add_page needs special ENOMEM 
treatment (assuming the target could always be a device mapper target), 
right?

"grep bio_add_page fs/btrfs/*.c" will make you unhappy.

-Jan
