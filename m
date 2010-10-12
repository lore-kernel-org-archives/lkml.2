Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab0JLPeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:34:09 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:8939 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab0JLPeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:34:07 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0LA6OJL-02-3H1-02
X-M-MSG: 
Date: Tue, 12 Oct 2010 17:33:24 +0200
From: Robert Richter <robert.richter@amd.com>
To: Maynard Johnson <maynardj@us.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        William Cohen <wcohen@redhat.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH] oprofile: disable write access to oprofilefs while
 profiler is running
Message-ID: <20101012153324.GZ13563@erda.amd.com>
References: <1286275017-32497-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1286275017-32497-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.10.10 06:36:57, Robert Richter wrote:
> Oprofile counters are setup when profiling is disabled. Thus, writing
> to oprofilefs has no immediate effect. Changes are updated only after
> oprofile is reenabled.
> 
> To keep userland and kernel states synchronized, we now allow
> configuration of oprofile only if profiling is disabled.  In this case
> it checks if the profiler is running and then disables write access to
> oprofilefs by returning -EBUSY. The change should be backward
> compatible with current oprofile userland daemon.
> 
> Cc: Maynard Johnson <maynardj@us.ibm.com>
> Cc: William Cohen <wcohen@redhat.com>
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  drivers/oprofile/oprof.c          |   19 +++++--------------
>  drivers/oprofile/oprof.h          |    2 +-
>  drivers/oprofile/oprofile_files.c |    7 +++++--
>  drivers/oprofile/oprofilefs.c     |    8 ++++++--
>  4 files changed, 17 insertions(+), 19 deletions(-)

I applied the patch to oprofile/core. Maynard, thanks for review.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

