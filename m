Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab2F1CmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:42:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61813 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab2F1Cl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:41:57 -0400
X-IronPort-AV: E=Sophos;i="4.77,488,1336320000"; 
   d="scan'208";a="5279514"
Message-ID: <4FEBC57C.20302@cn.fujitsu.com>
Date: Thu, 28 Jun 2012 10:46:20 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 5/8] don't print message if request_resource() failed
References: <4FE97DD5.6030205@cn.fujitsu.com> <4FE97F13.3000804@cn.fujitsu.com> <alpine.DEB.2.00.1206262122160.24245@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206262122160.24245@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/28 10:42:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/28 10:42:06,
	Serialize complete at 2012/06/28 10:42:06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 06/27/2012 12:23 PM, David Rientjes Wrote:
> On Tue, 26 Jun 2012, Wen Congyang wrote:
> 
>> If register_memory_resource() fails, the caller(add_memory()) will
>> return -EEXIST, and add_memory() returns -EEXIST only when
>> register_memory_resource() fails. The function acpi_memory_enable_device()
>> doesn't treat such erro as a fetal error, and don't want this message.
>> The function that calls add_memory() has printed message if add_memory()
>> failed, so don't print message in register_memory_resource().
>>
> 
> That may be true for acpi_memory_enable_device(), but have you checked 
> other callers to add_memory()?
> 

There are four functions that call add_memory():
1. acpi_memory_enable_device()
2. memory_probe_store()
   This caller is the callback of system call write. The user can get the return
   value by errno.
3. add_memory_merged()
   This caller does not check the return value. I guess add_memory() always
   successes in this place.
4. bp_state reserve_additional_memory()
   This caller prints message if add_memory() failed.

So I think we can remove this message...

Thanks
Wen Congyang
