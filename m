Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351Ab1ESS11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:27:27 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:57177 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934350Ab1ESS1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:27:22 -0400
X-ASG-Debug-ID: 1305829640-01de28096b4f8d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DD56104.6080801@fusionio.com>
Date: Thu, 19 May 2011 20:27:16 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Alex,Shi" <alex.shi@intel.com>
CC: "Li, Shaohua" <shaohua.li@intel.com>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Perfromance drop on SCSI hard disk
References: <1305009600.21534.587.camel@debian>	 <4DCC4340.6000407@fusionio.com>  <1305247704.2373.32.camel@sli10-conroe>	 <1305255717.2373.38.camel@sli10-conroe>	 <1305533054.2375.45.camel@sli10-conroe>	 <1305535071.21534.2122.camel@debian> <1305612565.21534.2177.camel@debian>	 <4DD221BE.3040406@fusionio.com> <1305793580.22968.155.camel@debian>
X-ASG-Orig-Subj: Re: Perfromance drop on SCSI hard disk
In-Reply-To: <1305793580.22968.155.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1305829640
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64212
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-19 10:26, Alex,Shi wrote:
> 
>> I will queue up the combined patch, it looks fine from here as well.
>>
> 
> When I have some time to study Jens and shaohua's patch today. I find a
> simpler way to resolved the re-enter issue on starved_list. Following
> Jens' idea, we can just put the starved_list device into kblockd if it
> come from __scsi_queue_insert(). 
> It can resolve the re-enter issue and recover performance totally, and
> need not a work_struct in every scsi_device. The logic/code also looks a
> bit simpler. 
> What's your opinion of this? 

Isn't this _identical_ to my original patch, with the added async run of
the queue passed in (which is important, an oversight)?

-- 
Jens Axboe

