Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab0IIPKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 11:10:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37946 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0IIPKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 11:10:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type;
        b=CO46N695VeOFS1La3BkIDMLoMYhtN02syrp2LZm5oBlWdXyqdg8b1rNH3xN8bLwc/v
         j6f8am/6N5UZTBoZ3lH2v+c/eGAE0fvJ5Sydu0kFLI2ND9mHlGO0qgWOWE7yhlSE9Kie
         qGj71Mg/NfcKyYVKg1SV+jBBTrDQ2r1IxBepg=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 9 Sep 2010 17:10:34 +0200
Message-ID: <AANLkTi=uzLJxDbd+uJAww-b5aP10gd8gbGVG19HS46ue@mail.gmail.com>
Subject: mm/Kconfig: warning: (COMPACTION && EXPERIMENTAL && HUGETLB_PAGE &&
 MMU) selects MIGRATION which has unmet direct dependencies (NUMA || ARCH_ENABLE_MEMORY_HOTREMOVE)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while build latest 2.6.36-rc3 I get this warning:

[ build.log]
...
warning: (COMPACTION && EXPERIMENTAL && HUGETLB_PAGE && MMU) selects
MIGRATION which has unmet direct dependencies (NUMA ||
ARCH_ENABLE_MEMORY_HOTREMOVE)
...

Here the excerpt of...

[ mm/Kconfig ]
...
# support for memory compaction
config COMPACTION
        bool "Allow for memory compaction"
        select MIGRATION
        depends on EXPERIMENTAL && HUGETLB_PAGE && MMU
        help
          Allows the compaction of memory for the allocation of huge pages.
...

I have set the following kernel-config parameters:

$ egrep 'COMPACTION|HUGETLB_PAGE|MMU|MIGRATION|NUMA|ARCH_ENABLE_MEMORY_HOTREMOVE'
linux-2.6.36-rc3/debian/build/build_i386_none_686/.config
CONFIG_MMU=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_IOMMU_API=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_MMU_NOTIFIER=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_IOMMU_STRESS is not set

Looks like I have no NUMA or ARCH_ENABLE_MEMORY_HOTREMOVE set.

Ok, it is a *warning*...

Kind Regards,
- Sedat -
