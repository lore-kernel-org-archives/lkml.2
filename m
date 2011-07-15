Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057Ab1GOH7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 03:59:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21872 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965011Ab1GOH7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 03:59:36 -0400
Message-ID: <4E1FF33A.8090101@oracle.com>
Date: Fri, 15 Jul 2011 15:58:50 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Daniel Stodden <Daniel.Stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        "annie.li@oracle.com" <annie.li@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH resubmit] xen-blkfront: Don't send closing  notification
 to backend in blkfront_closing()
References: <4E1CEB34.5090907@oracle.com>	 <1310631209.634.444.camel@zakaz.uk.xensource.com>	 <4E1EAEE9.80605@oracle.com> <1310634779.634.480.camel@zakaz.uk.xensource.com>
In-Reply-To: <1310634779.634.480.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E1FF349.0095:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/11 17:12, Ian Campbell wrote:
> On Thu, 2011-07-14 at 09:55 +0100, Joe Jin wrote:
>> On 07/14/11 16:13, Ian Campbell wrote:
>>> On Wed, 2011-07-13 at 01:47 +0100, Joe Jin wrote:
> 
>>>
>>> I'm wondering if we might not be better off deferring the disconnect on
>>> the backend side until the frontend enters XenbusStateClosed instead of
>>> doing it in closing.
>>
>> Yes this fix from backend side works too, also this looks reasonable than 
>> fix in frontend.
> 
> I guess there is either a missing "more" or "less" in that sentence ;-)
> 
> The nice thing about a backend fix is that you don't need to go round
> propagating the fix into distros etc and updating existing deployed
> guests (not to mention non-Linux frontends).

Indeed ;)

> 
> I actually thought blkback had something like this already in older
> "classic" Xen kernels but it seems like the patch never made it out of
> the XCP patch queue :-(. See
> http://xenbits.xen.org/hg/XCP/linux-2.6.32.pq.hg/file/tip/CA-7672-blkback-shutdown.patch
> (which appears to also incorporate a toolstack directed graceful
> shutdown of some sort as well as deferring the device close).
> 
> Daniel, do you know of any plans to extricate that stuff from the XCP
> patch queue for upstream? Are there any other patches (e.g. incremental
> fixes) in that pq which should go along with it?

Looking forward push this patch to upstream!

Joe 

