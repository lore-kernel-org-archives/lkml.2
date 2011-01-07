Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1AGGnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 01:43:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:65179 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab1AGGnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 01:43:39 -0500
Message-ID: <4D26B608.2060500@oracle.com>
Date: Fri, 07 Jan 2011 14:43:20 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.7
MIME-Version: 1.0
To: Joe Jin <joe.jin@oracle.com>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "gurudas.pai@oracle.com" <gurudas.pai@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "guru.anbalagane@oracle.com" <guru.anbalagane@oracle.com>,
        "greg.marsden@oracle.com" <greg.marsden@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [patch] xenfb: fix xenfb suspend/resume race
References: <20101230125616.GA31537@joejin-pc.cn.oracle.com>		<20101230164051.GC24313@dumpdata.com>		<1294139733.3831.141.camel@zakaz.uk.xensource.com>		<4D256BC7.1080501@oracle.com>	<1294300924.13733.42.camel@localhost.localdomain> <4D2579F1.50900@oracle.com>
In-Reply-To: <4D2579F1.50900@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/11 16:14, Joe Jin wrote:
> 
>>
>> No, it papers over the issue, the code should never have been allowed to
>> get this far if the connection to the backend is not yet fully resumed
>> (i.e. when irq == -1).
>>
>> The call to xenfb_send_event should have been gated further up the call
>> chain, AFAICT by the check of info->update_wanted in xenfb_refresh. This
>> suggests that the correct fix is to set info->update_wanted = 0 in
>> xenfb_resume.
>>
>> I said all this in my previous mail and you ignored it. Did you try this
>> approach?
> 

Disable xenfb refresh flag before suspend will fix this issue, sent new patch
to you by another mail, please review it.

Thanks,
Joe
