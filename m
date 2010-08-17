Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab0HQMMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:12:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48936 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0HQMMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:12:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZjziOmq6bdgCBpWP9n04S++IlJs9pC6+/6Ery8iTNgDMTdQNzPc0Oz2tq/QuyN8aAJ
         NUL49GAcJiVfp5woXb6nEzEwJtXmKBgS9BueqY5eBo1qJgLDjrJO9Pz6lw3ogvg31YW2
         /qri1FtUTmwlSiSG48+TBPzZVjLTAEM1sarYc=
Message-ID: <4C6A7BFD.1070604@gmail.com>
Date: Tue, 17 Aug 2010 14:09:33 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend
 to RAM
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008171319.25080.rjw@sisk.pl> <4C6A7281.3030804@gmail.com> <201008171410.21382.stephan.diestelhorst@amd.com>
In-Reply-To: <201008171410.21382.stephan.diestelhorst@amd.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 02:10 PM, Stephan Diestelhorst wrote:
> If you want me to test anything... let me know. Since I do not know
> much about the ATA code, I do not know what to change where. (A simple
> grep for sd_suspend in drivers/ata didn't turn up anything.)

Oh, sure, the following should be enough.  Thanks.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8802e48..892ccc7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2456,6 +2456,8 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 	int ret = 0;

+	return 0;
+
 	if (!sdkp)
 		return 0;	/* this can happen */

-- 
tejun
