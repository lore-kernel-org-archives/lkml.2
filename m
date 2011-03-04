Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1CDOUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:20:53 -0500
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:35739
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492Ab1CDOUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:20:51 -0500
X-Greylist: delayed 687 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 09:20:51 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=bZQipMR0/7GCAekI3bFLQ7U58lAoxZzOgyQ98XlulkTwXnDl4vy26V1C30yeR3HO;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4D70F286.5040508@earthlink.net>
Date: Fri, 04 Mar 2011 09:09:10 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Mark Lord <kernel@teksavvy.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: NEC ND-4550A problems reading DVD-R
References: <m339n7g7tw.fsf@intrepid.localdomain> <20110301080153.GA26074@htj.dyndns.org> <4D6CF92A.4020105@teksavvy.com> <4D6D151D.8030307@earthlink.net> <20110304110757.GJ20499@htj.dyndns.org>
In-Reply-To: <20110304110757.GJ20499@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79feaeadb27a0a162da65ae7d2f5216f0a350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 06:07 AM, Tejun Heo wrote:
> (cc'ing Jens and James)
>
> On Tue, Mar 01, 2011 at 10:47:41AM -0500, Stephen Clark wrote:
>    
>> On 03/01/2011 08:48 AM, Mark Lord wrote:
>>      
>>> On 11-03-01 03:01 AM, Tejun Heo wrote:
>>> ..
>>>        
>>>> I think that's determined by drivers/scsi/sr.h::SR_TIMEOUT which is
>>>> hardcoded to be 30 seconds.  Maybe it's better to move it to use the
>>>> block parameter.  Anyways, the drive actually takes longer than 30secs
>>>> to recognize the media?
>>>>          
>>> That slow behaviour is not uncommon, especially as drives struggle
>>> to recognize various forms of copy-protected media (DVD-Video).
>>> A longer default, or tuneable timeout, would help.
>>>        
>> I agree with Mark, this should be a user tuneable value. My 2006 LG
>> dvd-rw frequently times out
>> trying to identify the media. But after numerous timeout error
>> messages it usually suceeds.
>>      
> I don't think it should be a user tunable value.  It should be
> something automatic.  I mean, how many would know to go some cryptic
> place and increase sr probing timeout?
>
> At the same time, increasing it for other cases is quite unattractive,
> so it probably would be a good idea to only use higher timeout value
> for the TUR right after media presence change event.
>
> Anyone interested in doing it?
>
> Thanks.
>
>    
I don't see this as being any different than all the other obfuscated 
tunable values that already
exists. At least I could google or look around for a tunable and maybe 
change it myself instead of having to
patch the source.

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



