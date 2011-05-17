Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab1EQHUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:20:39 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:39717 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab1EQHUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:20:35 -0400
X-ASG-Debug-ID: 1305616833-01de28096b40fd0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DD221BE.3040406@fusionio.com>
Date: Tue, 17 May 2011 09:20:30 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Alex,Shi" <alex.shi@intel.com>
CC: "Li, Shaohua" <shaohua.li@intel.com>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Perfromance drop on SCSI hard disk
References: <1305009600.21534.587.camel@debian>	 <4DCC4340.6000407@fusionio.com>  <1305247704.2373.32.camel@sli10-conroe>	 <1305255717.2373.38.camel@sli10-conroe>	 <1305533054.2375.45.camel@sli10-conroe>	 <1305535071.21534.2122.camel@debian> <1305612565.21534.2177.camel@debian>
X-ASG-Orig-Subj: Re: Perfromance drop on SCSI hard disk
In-Reply-To: <1305612565.21534.2177.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1305616833
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.63976
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-17 08:09, Alex,Shi wrote:
> On Mon, 2011-05-16 at 16:37 +0800, Alex,Shi wrote:
>>>> what I mean is current sdev (other devices too) can still be added into
>>>> starved list, so only does async execute for current q isn't enough,
>>>> we'd better put whole __scsi_run_queue into workqueue. something like
>>>> below on top of yours, untested. Not sure if there are other recursive
>>>> cases.
>>> verified the regression can be fully fixed by your patch (with my
>>> suggested fix to avoid race). Can we put a formal patch upstream?
>>
>> Yes, we tested Jens patch alone and plus Shaohua's patch too. Both of
>> them recovered SAS disk performance too. Now I am testing them on SSD
>> disk with kbuild and fio cases, In theory, they will both work. 
>>
> 
> As expected, both patches has no effect on SSD disks in JBD. 

I will queue up the combined patch, it looks fine from here as well.

-- 
Jens Axboe

