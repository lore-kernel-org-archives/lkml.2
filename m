Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1AFP3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:29:34 -0500
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:52756 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035Ab1AFP3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:29:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=HnGtRx9VL1n2KWvWeaNEttAt4h3rs1a80SmAhNpedVu6nsoJ3oxLxzesu3mZ0t18;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D25DFDA.8010909@earthlink.net>
Date: Thu, 06 Jan 2011 10:29:30 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Robert Hancock <hancockrwd@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel 2.6.37 erroneously limiting to UDMA/33
References: <20110106103035.GA3484@rhlx01.hs-esslingen.de>
In-Reply-To: <20110106103035.GA3484@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79a81a3602a128a90585dea040e7efa3b5350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 05:30 AM, Andreas Mohr wrote:
> Hi,
>
> Robert Hancock wrote:
>    
>> On 01/05/2011 12:33 PM, Stephen Clark wrote:
>>      
>>> Hello,
>>>
>>> Why is the kernel limiting me to udma/33 when the device says it can do
>>> ata2.01: CFA: TRANSCEND, 20070831, max UDMA/66
>>>
>>> There is no cable the compact flash is a socket on the motherboard!
>>>        
>> The kernel has no way to know that, and presumably the board isn't
>> connecting the signal for IDE pin 34 to ground in order to properly
>> signal that an 80-wire cable (or equivalent) is connected so that speeds
>> over UDMA33 can be used.
>>
>> You should be able to use the libata.force=80c option on the kernel
>> command line to override the cable detection.
>>      
> Further comments for the OP:
>
> If 80c happens to be correct for this machine (since it's soldered
> it's quite obvious) and the machine is quite wide-spread, perhaps one needs
> to add overrides within drivers/ata/pata_via.c/via_cable_detect() functionality,
> analogous to the ata_piix.c/ich_pata_cable_detect() case where it uses
> an entire ich_laptop device list to match against,
> to detect special 80c compatible cases.
>
> But since pata_via.c has the insightful comment
> "Perform cable detection. Actually for the VIA case the BIOS
>   already did this for us."
> it looks like your BIOS might be considered "broken"
> due to not indicating 80c for such a solder job
> -->  BIOS upgrade available?
>
>    
Will check. The machine is an Acrosser AR-M0898B micro box, for use such as
a firewall, vpn appliance, etc.
> And perhaps better avoid mentioning a specific kernel in the subject
> line unless it's a regression (which likely isn't the case here),
> or write it like "..... (on 2.6.XXX)".
>
>    
Good point.

> Andreas Mohr
>
>    


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



