Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0LHKGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:06:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:35245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab0LHKGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:06:52 -0500
Message-ID: <4CFF58D2.4040006@kernel.org>
Date: Wed, 08 Dec 2010 11:07:14 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Jian Peng <jipeng@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver
References: <E18F441196CA634DB8E1F1C56A50A874319F70C1F2@IRVEXCHCCR01.corp.ad.broadcom.com> <4CFEE569.4030204@gmail.com>
In-Reply-To: <4CFEE569.4030204@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 10:06:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2010 02:54 AM, Robert Hancock wrote:
> On 12/07/2010 01:43 AM, Jian Peng wrote:
>> Recently, while bringing up a new AHCI host controller, I found out
>> that current AHCI driver (in 2.6.37-rc3) may violate AHCI spec in
>> function libahci.c: ahci_start_engine().
>>
>> From end of section 10.1.2 in AHCI 1.3 spec, it claims
>>
>> Software shall not set PxCMD.ST to '1' until it is determined that
>> a functional device is present on the port as determined by
>> PxTFD.STS.BSY = '0', PxTFD.STS.DRQ = '0', and PxSSTS.DET = 3h.
>>
>> It seems working well on most controller without this extra
>> checking, but does cause problem in our new core. Since toggling
>> PxCMD.SUD already initiated reset process at early time, and by the
>> time of ahci_start_engine() got called, BSY bit may not be cleared
>> yet, and forcing PxCMD.ST bit to 1 will cause problem for HW in
>> this case.

Hmmm... interesting.  Yeah, we have never had any problem in that area
and would like to avoid changing unless necessary but then again if
it's broken, well, we should.  What kind of problem is the controller
showing?

Thanks.

-- 
tejun
