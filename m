Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab2G1Ieo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 04:34:44 -0400
Received: from mail-hostigation.familyross.net ([69.85.93.112]:56916 "EHLO
	mail.familyross.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2G1Iel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 04:34:41 -0400
Message-ID: <5013A41E.5070500@familyross.net>
Date: Sat, 28 Jul 2012 01:34:38 -0700
From: Kevin Ross <kevin@familyross.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Grant Coady <gcoady.lk@gmail.com>
CC: Bill Davidsen <davidsen@tmr.com>, Linux RAID <linux-raid@vger.kernel.org>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RAID extremely slow
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org> <5010A386.4080209@familyross.net> <5010CEFF.5030606@familyross.net> <5012E717.9070808@tmr.com> <50130BEE.8080402@familyross.net> <8oq618ldps0ijt76cr3k6vovkksm4b9vsb@4ax.com>
In-Reply-To: <8oq618ldps0ijt76cr3k6vovkksm4b9vsb@4ax.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 09:45 PM, Grant Coady wrote:
> On Fri, 27 Jul 2012 14:45:18 -0700, you wrote:
>
>> On 07/27/2012 12:08 PM, Bill Davidsen wrote:
>>> Have you set the io scheduler to deadline on all members of the array?
>>> That's kind of "job one" on older kernels.
>>>
>> I have not, thanks for the tip, I'll look into that now.
> Plus I disable the on-drive queuing (NCQ) during startup, right now
> I don't have benchmarks to show the difference.  This on a six by 1TB
> drive RAID6 array I built over a year ago on Slackware64-13.37:
>
> # cat /etc/rc.d/rc.local
> ...
> # turn off NCQ on the RAID drives by adjusting queue depth to 1
> n=1
> echo "rc.local: Disable RAID drives' NCQ"
> for d in a b c d e f
> do
>          echo "  set NCQ depth to $n on sd${d}"
>          echo $n>  /sys/block/sd${d}/device/queue_depth
> done
> ...
>
> Maybe you could try that?  See if it makes a difference.  My drives
> are Seagate.
>
> Grant.
>

Does disabling NCQ improve performance?

The suggestion to use kernel 3.4.6 has been working quite well so far, 
hopefully that fixes the problem.  I'll know for sure in a few more days...

Thanks!
-- Kevin

