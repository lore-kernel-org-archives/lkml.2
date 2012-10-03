Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab2JCJD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:03:26 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab2JCJDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:03:25 -0400
Message-ID: <506BFF58.4060106@nod.at>
Date: Wed, 03 Oct 2012 11:03:20 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: artem.bityutskiy@linux.intel.com
CC: Heinz.Egger@linutronix.de, tglx@linutronix.de,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tim.bird@am.sony.com
Subject: Re: UBI: Fastmap request for inclusion (v19)
References: <1348674710-102885-1-git-send-email-richard@nod.at>  <1349252745.2017.120.camel@sauron.fi.intel.com>  <20121003103625.0bbff63c@spider.haslach.nod.at> <1349253885.2017.125.camel@sauron.fi.intel.com>
In-Reply-To: <1349253885.2017.125.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.10.2012 10:44, Artem Bityutskiy wrote:
> On Wed, 2012-10-03 at 10:36 +0200, Richard Weinberger wrote:
>> Am Wed, 03 Oct 2012 11:25:45 +0300
>> schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:
>>
>>> On Wed, 2012-09-26 at 17:51 +0200, Richard Weinberger wrote:
>>>> UBI Fastmap is an optional feature which stores the physical to
>>>> logical eraseblock relations in a checkpoint (called fastmap) to
>>>> reduce the initialization time of UBI. The current init time of UBI
>>>> is proportional to the number of physical erase blocks on the FLASH
>>>> device. With fastmap enabled the scan time is limited to a fixed
>>>> number of blocks.
>>>
>>> Aiaiai complains and linux-next build fails :-( Last time I forgot to
>>> enable the fastmap kbuild option so aiaiai checked with that option
>>> disabled. Now I enabled it with a simple hack (default n -> default y)
>>> and here are aiaiai's complaints - there is a build failure for
>>> ARCH=i386.
>>
>> Build fix for linux-next is on the way into your inbox.
>> I'm currently looking at the aiaiai output.
>
> OK, I see, goto out is missing after line 919. Please, send a short fix
> - I'll squash it in. But general error-path rework is needed for this
> function, may be separately.
>

Yeah, it looks like all issues reported by aiaiai are caused by the missing goto.
Can you deal with the patch below or do you want me to send it using git send-email?

Thanks,
//richard

---
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index be73a1d..adcb2e4 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -917,6 +917,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
  		ret = UBI_BAD_FASTMAP;
  		kfree(fmsb);
  		kfree(fm);
+		goto out;
  	}

  	ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);

