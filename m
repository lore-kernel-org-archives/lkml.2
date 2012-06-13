Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab2FMCX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 22:23:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57674 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2FMCX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 22:23:57 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD7F937.2010101@jp.fujitsu.com>
Date: Wed, 13 Jun 2012 11:21:43 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, rob@landley.net, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bhelgaas@google.com
Subject: Re: [PATCH 1/2 v2] x86: add max_addr boot option
References: <4FD5AFF2.3040306@cn.fujitsu.com> <4FD65FD4.4060705@zytor.com> <4FD6E101.3010106@cn.fujitsu.com> <d468fc51-04f6-4e88-aeaa-c4642531325e@email.android.com>
In-Reply-To: <d468fc51-04f6-4e88-aeaa-c4642531325e@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/13 1:10), H. Peter Anvin wrote:
> If what you care about is nodes, why not have an option to specify a map?
>

At the first time of our project, we discussed passing node-id as boot option.
But, we found Node-ID is just determined by the pxm ID order in SRAT. That means,
we and our firmware team need to take care of the order of SRAT. But that node-ID
v.s. SRAT relationship is just determined by implemenation, there is no spec,
we thought we can't keep this way in future.

The second thought was specifying PXM. But, with hardware-partitioning-system,
dynamic implementation of SRAT for a partutuion is very confusing...

Then, alternative idea was using mem= boot option. Because our partition system
has fixed address range per each node, it works well.

But now, we know mem= boot option is buggy....it acts as max_addr= option, we
have concerns that 'someone may fix mem= option as sane as ia64. because it's buggy".

We'd like to fix mem= boot option by ourselves and preserve old behavior with max_addr=
boot option, which ia64 has.

Thanks,
-Kame

