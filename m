Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2GKHlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 03:41:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40568 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab2GKHlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 03:41:01 -0400
X-IronPort-AV: E=Sophos;i="4.77,566,1336320000"; 
   d="scan'208";a="5371786"
Message-ID: <4FFD2F1E.10006@cn.fujitsu.com>
Date: Wed, 11 Jul 2012 15:45:34 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 0/7 v2] some fixes about acpi_memhotplug
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/11 15:40:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/11 15:40:52,
	Serialize complete at 2012/07/11 15:40:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1 to v2:
1. address David Rientjes and Konrad Rzeszutek Wilk's comment

Note:
Patch 2, 3, 7 have been acked by David Rientjes.

Wen Congyang (7):
  fix memory leak when memory device is unbound from the module
    acpi_memhotplug
  free memory device if acpi_memory_enable_device() failed
  remove memory info from list before freeing it
  don't allow to eject the memory device if it is being used
  bind the memory device when the driver is being loaded
  auto bind the memory device which is hotpluged before the driver is
    loaded
  release memory resources if hotadd_new_pgdat() failed

 drivers/acpi/acpi_memhotplug.c |  123 ++++++++++++++++++++++++++++++----------
 mm/memory_hotplug.c            |    2 +-
 2 files changed, 93 insertions(+), 32 deletions(-)

