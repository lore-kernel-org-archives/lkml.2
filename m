Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192Ab1BLQEI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 11:04:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34572 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab1BLQED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 11:04:03 -0500
Message-ID: <4D56AF22.4070803@oracle.com>
Date: Sat, 12 Feb 2011 08:02:42 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Kurt Van Dijck <kurt.van.dijck@eia.be>
CC: akpm@linux-foundation.org, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH -next/mmotm] net/can: fix softing build errors
References: <201102110100.p1B10sDx029244@imap1.linux-foundation.org> <20110211223312.be571303.randy.dunlap@oracle.com> <20110212111344.GA328@e-circ.dyndns.org>
In-Reply-To: <20110212111344.GA328@e-circ.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D56AF69.0065:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/11 03:15, Kurt Van Dijck wrote:
> On Fri, Feb 11, 2011 at 10:33:12PM -0800, Randy Dunlap wrote:
>>
>> warning: (CAN_SOFTING_CS) selects CAN_SOFTING which has unmet direct dependencies (NET && CAN && CAN_DEV && HAS_IOMEM)
>>
>> with this partial config:
>>
>> CONFIG_CAN=m
>> # CONFIG_CAN_RAW is not set
>> # CONFIG_CAN_BCM is not set
>> # CAN Device Drivers
>> # CONFIG_CAN_VCAN is not set
>> CONFIG_CAN_SLCAN=m
>> # CONFIG_CAN_DEV is not set
>> CONFIG_CAN_SOFTING=m
>> CONFIG_CAN_SOFTING_CS=m
>> # CONFIG_CAN_DEBUG_DEVICES is not set
> I understand the output, but I don't understand the cause well enough.
> CAN_SOFTING=m has a 'depends on CAN_DEV'
> Is it then possible to have CAN_SOFTING=m _and not_ CAN_DEV ?

Yes.  From Documentation/kbuild/kconfig-language.txt:

  Note:
	select should be used with care. select will force
	a symbol to a value without visiting the dependencies.
	By abusing select you are able to select a symbol FOO even
	if FOO depends on BAR that is not set.
	In general use select only for non-visible symbols
	(no prompts anywhere) and for symbols with no dependencies.
	That will limit the usefulness but on the other hand avoid
	the illegal configurations all over.


CAN_SOFTING_CS does not depend on CAN_DEV. but it selects CAN_SOFTING,
which does depend on CAN_DEV, ... but CAN_DEV is not enabled.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
