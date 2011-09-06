Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab1IFQou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:44:50 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:53931 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1IFQoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:44:44 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz154dM1432N98dK4015Lzz1202hzz8275dhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR416B-01-VPM-02
X-M-MSG: 
Date: Tue, 6 Sep 2011 18:43:37 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [V3][PATCH 0/6] x86, nmi: new NMI handling routines
Message-ID: <20110906164337.GK14200@erda.amd.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.08.11 12:45:42, Don Zickus wrote:
> I had the pleasure of hosting Robert Richter this week at Red Hat.  One of
> the issues he wanted to talk with me about was having the NMI handling 
> routines execute all the NMI handlers for each NMI mainly for his AMD IBS
> work.  But he also brought up another good point that because of the way NMIs
> work, it is possible to lose them if multiple NMIs happen at the same time.
> 
> As a result, we sat around and discussed how we could go about executing
> all the nmi handlers for each NMI to ensure that we would not lose any events.
> 
> We decided the best way to do this would be to have the NMI handlers break
> away from the notifier routines and create our own.  This would allow us to
> execute all the handlers without hacking up the notifier stuff and easily
> track the number of events processed at a higher level to deal with the new
> problemm of extra NMIs.
> 
> I spent some time hacking and came up with this patch.  I tested it on my
> core2quad machine trying to enable all the NMI handler I could, mainly
> perf and kgdb (and oprofile too when perf was disabled).  Everything seems
> to work correctly.  If people are ok with this approach, I'll try and test
> this on more machines.
> 
> More details about the patch are in the individual changelogs.

Don,

thanks for this patch set. So far it looks good to me. See my comments
posted. I don't think they require necessarily a new patch
version. Instead we could implement changes on top of it.

I will rebase my current perf ibs implementation on to of this
patches. It would be good to have the patches in tip after kernel.org
is back again.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

