Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0IIPPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 11:15:24 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40013 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0IIPPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 11:15:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:content-type:content-transfer-encoding;
        b=smYpkeXZAZrOA2mm0EDKNaRpdCZr1S38ukZVV+wlCZXspLqq/ZFcbRvpIy5g7XygqY
         elZSWGsRHP3F1R0OP7myfVE+1/vp/lJeaZWNHb19oh/xMq5fasxP13jKmnADcoqNxAdj
         YtHHMfUo2lV3bHM3bIU/PDBOGry9pOYS6Yz0E=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTi=uzLJxDbd+uJAww-b5aP10gd8gbGVG19HS46ue@mail.gmail.com>
References: <AANLkTi=uzLJxDbd+uJAww-b5aP10gd8gbGVG19HS46ue@mail.gmail.com>
Date: Thu, 9 Sep 2010 17:15:22 +0200
Message-ID: <AANLkTinoR=ZeCqcqSuoY884y_7MNB50B7RiwY4B+Fycc@mail.gmail.com>
Subject: Re: mm/Kconfig: warning: (COMPACTION && EXPERIMENTAL && HUGETLB_PAGE
 && MMU) selects MIGRATION which has unmet direct dependencies (NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh, forgot...

[ mm/Kconfig ]
...
#
# support for page migration
#
config MIGRATION
        bool "Page migration"
        def_bool y
        depends on NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE
        help
          Allows the migration of the physical location of pages of processes
          while the virtual addresses are not changed. This is useful in
          two situations. The first is on NUMA systems to put pages nearer
          to the processors accessing. The second is when allocating huge
          pages as migration can relocate pages to satisfy a huge page
          allocation instead of reclaiming.
...

- Sedat -

On Thu, Sep 9, 2010 at 5:10 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi,
>
> while build latest 2.6.36-rc3 I get this warning:
>
> [ build.log]
> ...
> warning: (COMPACTION && EXPERIMENTAL && HUGETLB_PAGE && MMU) selects
> MIGRATION which has unmet direct dependencies (NUMA ||
> ARCH_ENABLE_MEMORY_HOTREMOVE)
> ...
>
> Here the excerpt of...
>
> [ mm/Kconfig ]
> ...
> # support for memory compaction
> config COMPACTION
>        bool "Allow for memory compaction"
>        select MIGRATION
>        depends on EXPERIMENTAL && HUGETLB_PAGE && MMU
>        help
>          Allows the compaction of memory for the allocation of huge pages.
> ...
>
> I have set the following kernel-config parameters:
>
> $ egrep 'COMPACTION|HUGETLB_PAGE|MMU|MIGRATION|NUMA|ARCH_ENABLE_MEMORY_HOTREMOVE'
> linux-2.6.36-rc3/debian/build/build_i386_none_686/.config
> CONFIG_MMU=y
> # CONFIG_IOMMU_HELPER is not set
> CONFIG_IOMMU_API=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_MMU_NOTIFIER=y
> CONFIG_HUGETLB_PAGE=y
> # CONFIG_IOMMU_STRESS is not set
>
> Looks like I have no NUMA or ARCH_ENABLE_MEMORY_HOTREMOVE set.
>
> Ok, it is a *warning*...
>
> Kind Regards,
> - Sedat -
>
