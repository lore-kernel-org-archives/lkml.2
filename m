Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab1EaReg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:34:36 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:44590
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932313Ab1EaRec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:34:32 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zzbb2dK9371M1432N98dKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LM2M5D-01-4VP-02
X-M-MSG: 
Date: Tue, 31 May 2011 19:34:19 +0200
From: Robert Richter <robert.richter@amd.com>
To: Carl Love <carll@us.ibm.com>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>
Subject: Re: oprofile: possible circular locking dependency detected
Message-ID: <20110531173419.GN20052@erda.amd.com>
References: <20110115231315.GA2980@joi.lan>
 <OF3F8F266B.59586F06-ON8725781C.0077DEC6-8825781C.007A658E@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <OF3F8F266B.59586F06-ON8725781C.0077DEC6-8825781C.007A658E@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.01.11 17:16:40, Carl Love wrote:
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote on 01/15/2011 03:13:15 PM:
> > Lockdep finds possible circular locking dependency during
> > opcontrol --start on 2.6.37 kernel:

> We ran into this last week or so when we were trying to find an issue with perf
> and OProfile.
> It comes about because you have the config options LOCKDEP_SUPPORT (I am fairly
> sure that is
> the config option) enabled.  We spent some time looking into it and decided
> that since
> sync_start() must complete before the sync_buffer() routine can be called that
> you couldn't
> get a deadlock between these routines.  However, the same lock dependencies
> exist in sync_stop()
> and sync_buffer().  In this case, the sync_buffer() routine has been enabled
> and could be
> running when sync_exit() stops.  At least, we couldn't see any reason why that
> would not be
> the case.  We never got to proving that it actually ever happens.
> 
> From searching through the changes, it appears that last fall, I believe it was
> the Sept 2010
> time frame Robert Richter added the mutex to sync_start() and sync_stop() as
> part of
> fixing another issue.  If I recall correctly, the issue was trying to process
> samples for a
> process after the task struct for the process was gone.  The mutexes were added
> as well as
> moving some code around to correct the issue.  
> 
> We looked at the code with the mutexes and don't think the are needed.  I was
> planning on posting
> a message to the list asking about this change but hadn't gotten to it when
> this message came out.  
> I guess what needs to be done is to evaluate if we really need the mutex in the
> sync_start()
> and sync_stop() functions.

I just sent a fix for this to the lkml:

 [PATCH 2/3] oprofile: Fix locking dependency in sync_start()

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

