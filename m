Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2FZJLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:11:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40922 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab2FZJLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:11:41 -0400
X-IronPort-AV: E=Sophos;i="4.77,476,1336320000"; 
   d="scan'208";a="5266003"
Message-ID: <4FE97DD5.6030205@cn.fujitsu.com>
Date: Tue, 26 Jun 2012 17:16:05 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 0/8] some fixes about acpi_memhotplug
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/26 17:11:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/26 17:11:53,
	Serialize complete at 2012/06/26 17:11:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wen Congyang (8):
  fix memory leak when memory device is unbound from the module
    acpi_memhotplug
  free memory device if acpi_memory_enable_device() failed
  remove memory info from list before freeing it
  donot allow to eject the memory device if it is being used
  don't print message if request_resource() failed
  bind the memory device when the driver is being loaded
  auto bind the memory device which is hotpluged before the driver is
    loaded
  release memory resources if hotadd_new_pgdat() failed

 drivers/acpi/acpi_memhotplug.c |  106 ++++++++++++++++++++++++++++++----------
 mm/memory_hotplug.c            |    3 +-
 2 files changed, 81 insertions(+), 28 deletions(-)
