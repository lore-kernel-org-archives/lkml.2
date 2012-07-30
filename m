Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2G3Kam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:30:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64347 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab2G3Kak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:30:40 -0400
X-IronPort-AV: E=Sophos;i="4.77,679,1336320000"; 
   d="scan'208";a="5510371"
Message-ID: <50166379.4090305@cn.fujitsu.com>
Date: Mon, 30 Jul 2012 18:35:37 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [RFC PATCH v5 12/19] memory-hotplug: introduce new function arch_remove_memory()
References: <50126B83.3050201@cn.fujitsu.com> <50126E2F.8010301@cn.fujitsu.com> <20120730102305.GB3631@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20120730102305.GB3631@osiris.boeblingen.de.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/30 18:31:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/30 18:31:14,
	Serialize complete at 2012/07/30 18:31:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 07/30/2012 06:23 PM, Heiko Carstens Wrote:
> On Fri, Jul 27, 2012 at 06:32:15PM +0800, Wen Congyang wrote:
>> We don't call __add_pages() directly in the function add_memory()
>> because some other architecture related things need to be done
>> before or after calling __add_pages(). So we should introduce
>> a new function arch_remove_memory() to revert the things
>> done in arch_add_memory().
>>
>> Note: the function for s390 is not implemented(I don't know how to
>> implement it for s390).
> 
> There is no hardware or firmware interface which could trigger a
> hot memory remove on s390. So there is nothing that needs to be
> implemented.

Thanks for providing this information.

According to this, arch_remove_memory() for s390 can just return -EBUSY.

Thanks
Wen Congyang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

