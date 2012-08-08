Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab2HHCIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 22:08:23 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37942 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab2HHCIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 22:08:22 -0400
Message-ID: <5021CA31.7000405@oracle.com>
Date: Wed, 08 Aug 2012 10:08:49 +0800
From: "zhenzhong.duan" <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>
Subject: Re: [PATCH] Parallelize mtrr init between cpus
References: <5020C3D7.2070407@oracle.com> <5021432F.2030907@zytor.com>
In-Reply-To: <5021432F.2030907@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



  2012-08-08 00:32, H. Peter Anvin wrote:
> On 08/07/2012 12:29 AM, zhenzhong.duan wrote:
>> Current code serialize mtrr init with set_atomicity_lock.
>> Mtrr init is quite slow when we bootup on a hvm with large mem, vcpus
>> and pci passthroughed devices(eg. 24 vcpus + 90G mem).
>> It took about ~30 mins to bootup, after patch, it took ~2 min.
> When you're saying "HVM" do you mean "Xen HVM"?  How does it behave on
> native hardware?
>
> 	-hpa
Yes, I mean Xen HVM. Bootup at same speed as before on baremetal.
