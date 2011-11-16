Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab1KPCA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 21:00:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61168 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab1KPCA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 21:00:57 -0500
MIME-Version: 1.0
In-Reply-To: <20110629055102.GG29299@8bytes.org>
References: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
	<BANLkTi=mfMfVVOmoZd49fqFnY_kq0hxzDw@mail.gmail.com>
	<20110629055102.GG29299@8bytes.org>
Date: Wed, 16 Nov 2011 11:00:56 +0900
X-Google-Sender-Auth: K4HYwcKTK1chEGdMOiEbdlmWVWg
Message-ID: <CAHQjnONaMVSN32nQQQ9KOy8_tHpi9Kc7YkQXY9+vZ0a4hFJuWA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Introduce iommu_commit() function
From: KyongHo Cho <pullip.cho@samsung.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Avi Kivity <avi@redhat.com>, David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 2:51 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Wed, Jun 29, 2011 at 02:02:02PM +0900, KyongHo Cho wrote:
>> Hi.
>>
>> On Fri, Jun 24, 2011 at 12:31 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
>> > It needs to be called whenever a some code changed a domain (either by
>> > attaching/detaching devices or by mapping/unmapping pages in
>> > the domain).
>>
>> Do you mean we can invalidate IOTLB with this iommu_commit()?
>> We need to invalidate IOTLB without updating page table for some
>> optimized solutions.
>>
>> If a device in one domain is moved to other domain, IOTLB of the
>> device must be invalidated
>> because it contains translation information of the previous domain.
>
> The classic use-case is to do a single iommu-tlb flush after a set of
> page-table updates, but flushing iotlbs after moving devices is a
> potential use-case too, so the answer is yes.
>

Hi.

In the 'next' branch of
http://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git,
I found that iommu_commit() is removed.

Why is it removed?

BTW, the comment of struct iommu_ops still contains description about commit.

Regards,

  KyongHo
