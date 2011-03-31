Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab1CaH4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:56:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50818 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab1CaH4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:56:39 -0400
Message-ID: <4D9433DC.5020008@cn.fujitsu.com>
Date: Thu, 31 Mar 2011 15:57:16 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 00/15] CFS Bandwidth Control V5
References: <20110323030326.789836913@google.com>
In-Reply-To: <20110323030326.789836913@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-31 15:55:00,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-31 15:55:00
Content-Type: multipart/mixed;
 boundary="------------040000070007040608030702"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------040000070007040608030702
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

On 03/23/2011 11:03 AM, Paul Turner wrote:
> Hi all,
> 
> Please find attached the latest version of bandwidth control for the normal
> scheduling class.  This revision has undergone fairly extensive changes since
> the previous version based largely on the observation that many of the edge
> conditions requiring special casing around update_curr() were a result of
> introducing side-effects into that operation.  By introducing an interstitial
> state, where we recognize that the runqueue is over bandwidth, but not marking
> it throttled until we can actually remove it from the CPU we avoid the
> previous possible interactions with throttled entities which eliminates some
> head-scratching corner cases.
> 

Hi Paul,

I have wrote some codes to test this patchset. While run attached test case,
the test program is blocked, it seams the children tasks can not be killed,
after one or two hours, the watchdog is expired and triggers box crashed.

--------------040000070007040608030702
Content-Type: application/x-bzip;
 name="bwc.tar.bz2"
Content-Disposition: attachment;
 filename="bwc.tar.bz2"
Content-Transfer-Encoding: base64

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
Cwvb/YQUKWSJ1ySH/i7kinChIdT20vI=


--------------040000070007040608030702--
