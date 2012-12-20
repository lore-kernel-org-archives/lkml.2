Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab2LTHIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 02:08:09 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46296 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2LTHH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 02:07:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,322,1355126400"; 
   d="scan'208";a="15390898"
Message-ID: <50D2B94D.10309@codeaurora.org>
Date: Wed, 19 Dec 2012 23:07:57 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
CC: Paul Walmsley <paul@pwsan.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: BUG: spinlock bad magic on CPU#0 on BeagleBone
References: <B5906170F1614E41A8A28DE3B8D121433EC9A69C@DBDE01.ent.ti.com> <alpine.DEB.2.00.1212191650430.16873@utopia.booyaka.com> <50D2224E.4060300@codeaurora.org> <B5906170F1614E41A8A28DE3B8D121433EC9B6FE@DBDE01.ent.ti.com> <50D2AF54.7050402@codeaurora.org> <B5906170F1614E41A8A28DE3B8D121433EC9B964@DBDE01.ent.ti.com>
In-Reply-To: <B5906170F1614E41A8A28DE3B8D121433EC9B964@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 10:44 PM, Bedia, Vaibhav wrote:
> On Thu, Dec 20, 2012 at 11:55:24, Stephen Boyd wrote:
>> On 12/19/2012 8:48 PM, Bedia, Vaibhav wrote:
>>> I tried out 3 variants of AM335x boards - 2 of these (BeagleBone and EVM) have DDR2
>>> and 1 has DDR3 (EVM-SK). The BUG is triggered on all of these at the same point.
>>>
>>> With Stephen's change I don't see this on any of the board variants :)
>>> New bootlog below.
>> Great! Can I have your Tested-by then? I'll wrap it up into a patch. Is
>> this is a new regression? From a glance at the code it looks to have
>> existed for quite a while now.
> I went back to a branch based off 3.7-rc4 and don't see the issue there. Not sure
> what is triggering this now.
>
> Tested-by: Vaibhav Bedia <vaibhav.bedia@ti.com>

Thanks. I was thrown off by the author date of this patch which
introduced your problem

commit 8823c079ba7136dc1948d6f6dcb5f8022bde438e
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Sun Mar 7 18:49:36 2010 -0800
Commit:     Eric W. Biederman <ebiederm@xmission.com>
CommitDate: Mon Nov 19 05:59:18 2012 -0800

    vfs: Add setns support for the mount namespace


It seems to have a 2 year gap between commit date and author date.
Either way, it looks to be isolated to the 3.8 merge window but affects
quite a few architectures. Patch to follow shortly.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

