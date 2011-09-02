Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1IBXFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:05:09 -0400
Received: from ixia-3.edge2.lax012.pnap.net ([74.217.148.5]:31878 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756495Ab1IBXFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:05:08 -0400
Message-ID: <4E616122.3030901@ixiacom.com>
Date: Fri, 2 Sep 2011 16:05:06 -0700
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.1) Gecko/20110830 Thunderbird/6.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH 1/1 v2]: coredump: use current->group_leader->comm instead
 of current->comm
References: <4E5FBA73.2050108@ixiacom.com> <20110901195554.667c5e58@lxorguk.ukuu.org.uk> <4E5FD937.7050307@ixiacom.com> <20110902163037.GA4808@redhat.com> <4E610DAE.4080607@ixiacom.com> <20110902174806.GA9238@redhat.com>
In-Reply-To: <20110902174806.GA9238@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg, Alan,


> Who knows? But once again, we use ->comm in the very unlikely case.
>
> And let me repeat just in case. I do not argue, I agree either way.

I understand.

Before I give thought to reworking the change, perhaps some other
considerations.


The other interesting thing is that Alan brought up the relevant point
about stuff breaking.

Alan Cox wrote:
> Earl wrote:
>> Change corepattern %e and %E to use current->group_leader->comm instead of current->comm.
>
> Which might break stuff.


What are your thoughts regarding the introduction of cn_escape() in this patch ?

https://lkml.org/lkml/2011/6/7/292


While this change also has merit, it is also breaking change. There might
be code relying on %e containing embedded slashes, either directly in
core pattern:

	%e.core

or via the pipe:

	| /opt/corehandler '%e'	



Isn't the interface change introduced by cn_escape() also a concern ?


Earl
