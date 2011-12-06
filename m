Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab1LFOdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:33:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51781 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab1LFOdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:33:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAJL_dMtgP+BqFn3aGVBbGDJ+kMyGiEC_NmDURzh4mU=Jo=qZVA@mail.gmail.com>
References: <CAPLs8y9omncDbLE_KNoKOLLbfwHjWYUJX_i7cC4bLiJsyPbtZQ@mail.gmail.com>
 <CAJL_dMtgP+BqFn3aGVBbGDJ+kMyGiEC_NmDURzh4mU=Jo=qZVA@mail.gmail.com>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Tue, 6 Dec 2011 16:33:10 +0200
Message-ID: <CAPLs8y8vhioqc3CPrD7ugmVkR2DjKWNm8+T5j9QQnrxi=BgvdA@mail.gmail.com>
Subject: Re: v6: faster tree-based sysctl implementation
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 4:11 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> time modprobe dummy numdummies=1000FATAL: Error inserting dummy
> (/lib/modules/3.2.0-3-generic/kernel/drivers/net/dummy.ko): Operation
> not permitted

Generally when you get "Operation not permitted" you should try with sudo.
This is the man-page: http://xkcd.com/149/ :)


> What are the practical problems you solve with this ?
> Name one or more.


Sysctl uses a slow algorithm: O(N^2) for insertions, O(N) for lookup,
with a relatively big constant.
The performance is acceptable when N is small, but sometimes it can
grow to bigger values.
One case where N can grow to very large values is when you add network
interfaces.

Some companies (like IXIACOM which sponsored this work at the
beginning of this year) have use-cases in which they need 10^3..10^6
network interfaces. The current sysctl implementation is unacceptable
for them.

@Damien Millescamps might have some input on where he needs better
sysctl performance as he prompted me to re-send this patch series.

This algorithm is O(N * logN) for insert and O(logN) for lookup.


> You add more code. This is not good. If you reduce the code, then it
> will be interesting.

Thank you. I know that, but it's easier said than done. I'd welcome
some feedback in what could be simplified in my patches :)

-- 
 .
..: Lucian
