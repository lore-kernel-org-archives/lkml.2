Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3ADW6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:58:23 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:35509 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab3ADW6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:58:17 -0500
MIME-Version: 1.0
In-Reply-To: <87k3rslg5a.fsf@xmission.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
	<CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
	<CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
	<CAKocOON8_5RNp0oQZWFoTKDscdpcwkUNe9wX+B3uG9ET4h9e9g@mail.gmail.com>
	<87k3rslg5a.fsf@xmission.com>
Date: Fri, 4 Jan 2013 14:58:15 -0800
X-Google-Sender-Auth: WMyroCzBbGN2lxUMBlRzdpxhYsA
Message-ID: <CAE9FiQUmQ35a7PVaB1=9q1yhCa391gc1LbmCfgjrOZCH6qvANw@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Shuah Khan <shuahkhan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 2:47 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Yinghai Lu it looks like your autodetection of the problem case in this
> patch is problematic and needs a rethink.  My quick skim says you are
> trying to detect failure too early in the code.  Furthermore having
> kexec on panic sized magic comments without explanation is wrong.

current amd iommu implementation have this sequence:
1. alloc buffer for swiotlb.
2. detect and initialize intel iommu or amd iommu
3. release swiotlb if swiotlb == 0 , set by ops_init.

so we need to detect that before allocating buffer for swiotlb.

>
> Shuah Khan this is motivated by kdump.  However a correct implementation
> should be about dealing with the case when there is simply not enough
> memory available below 4G for bounce buffers.
>
> If a device needs an iommu, and swiotlb is the only iommu option, and
> there is not enough memory below 4G panic'ing is entirely reasonable.
>
> Do I read this discussion right that we are waisting 64M on systems
> that have the swiotlb code but don't use the swiotlb?

No wasting.
