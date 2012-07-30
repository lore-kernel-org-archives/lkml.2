Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2G3Bws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 21:52:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65153 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab2G3Bwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 21:52:45 -0400
X-IronPort-AV: E=Sophos;i="4.77,676,1336320000"; 
   d="scan'208";a="5504765"
Message-ID: <5015EA0D.9050501@cn.fujitsu.com>
Date: Mon, 30 Jul 2012 09:57:33 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [RFC PATCH v5 05/19] memory-hotplug: check whether memory is
 present or not
References: <50126B83.3050201@cn.fujitsu.com>	<50126D44.7070608@cn.fujitsu.com> <CA+8MBbL+G=xqkWU4xGF3_Ra7KoeoHuzL6QYcRiKqtVZoOBfLdQ@mail.gmail.com>
In-Reply-To: <CA+8MBbL+G=xqkWU4xGF3_Ra7KoeoHuzL6QYcRiKqtVZoOBfLdQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/30 09:53:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/30 09:53:19,
	Serialize complete at 2012/07/30 09:53:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 07/28/2012 04:17 AM, Tony Luck Wrote:
> On Fri, Jul 27, 2012 at 3:28 AM, Wen Congyang <wency@cn.fujitsu.com> wrote:
>> +static inline int pfns_present(unsigned long pfn, unsigned long nr_pages)
>> +{
>> +       int i;
>> +       for (i = 0; i < nr_pages; i++) {
>> +               if (pfn_present(pfn + 1))
> 
> Typo? I think you meant "pfn + i"

Typo error.

Thanks for pointing it out.
Wen Congyang

> 
>> +                       continue;
>> +               else
>> +                       return -EINVAL;
>> +       }
>> +       return 0;
>> +}
> 
> -Tony
> 

