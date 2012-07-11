Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab2GKHnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 03:43:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53046 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756540Ab2GKHnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 03:43:51 -0400
X-IronPort-AV: E=Sophos;i="4.77,566,1336320000"; 
   d="scan'208";a="5371817"
Message-ID: <4FFD2FC5.2090701@cn.fujitsu.com>
Date: Wed, 11 Jul 2012 15:48:21 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/7 v2] remove memory info from list before freeing it
References: <4FFD2F1E.10006@cn.fujitsu.com>
In-Reply-To: <4FFD2F1E.10006@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/11 15:43:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/11 15:43:43,
	Serialize complete at 2012/07/11 15:43:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We free info, but we forget to remove it from the list. It will cause
unexpected problem when we access the list next time.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 260a9c4..1f6196a 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -328,6 +328,7 @@ static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
 			if (result)
 				return result;
 		}
+		list_del(&info->list);
 		kfree(info);
 	}
 
-- 
1.7.1

