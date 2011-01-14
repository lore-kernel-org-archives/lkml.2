Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab1ANRAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:00:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:47834 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab1ANRAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:00:21 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: David Ahern <daahern@cisco.com>
Subject: Re: perf timechart broken
Date: Fri, 14 Jan 2011 18:00:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-18-desktop; KDE/4.5.3; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-perf-users@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <201101071104.37576.trenn@suse.de> <201101110955.37560.trenn@suse.de> <4D2CA7D6.2070203@cisco.com>
In-Reply-To: <4D2CA7D6.2070203@cisco.com>
MIME-Version: 1.0
X-Length: 2732
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101141800.18913.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 January 2011 19:56:22 David Ahern wrote:
> 
> On 01/11/11 01:55, Thomas Renninger wrote:
> > On Tuesday 11 January 2011 02:36:28 Frederic Weisbecker wrote:
> >> On Fri, Jan 07, 2011 at 11:04:37AM +0100, Thomas Renninger wrote:
> >>> Hi,
> >>>
> >>> Latest x86 tip has another perf timechart issue introduce
> >>> by latest commits.
> >>>
> >>> ./perf timechart
> >>> gives me:
> >>> "no trace data in the file"
> >>>
> >>> I reverted  the latest changes and things seem to break
> >>> between d854861c4292a4e675a5d3bfd862c5f7421c81e8
> >>> and
> >>> 69aad6f1ee69546dea8535ab8f3da9f445d57328
> >>> (linux-2.6-x86 tree ids)
> >>>
> >>> Be aware that ./perf timechart is currently broken
> >>> and segfaults on idle events (in 2.6.36 and 2.6.37).
> >>
> >> You mean .36 perf tools faults on .37 kernel? or the opposite?
> >> Is it because power_idle events weren't present on old tools?
> >> Do you have a pointer to those patches?
> > perf timechart
> > will segfault if perf.data has power_{start,end} events included
> > on 2.6.36 and 2.6.37 kernels.
> 
> Is this the same segfault you are seeing?
> 
> http://www.mail-archive.com/linux-perf-
users@vger.kernel.org/msg00057.html
Looks slightly different, the segfault should happen in:
process_sample_event
But looks very much related, possibly it has not been made/make with 
DEBUG=1
and -O6 was added and the backtrace is not 100% correct?

I still did not have time to send it out, will do so on Mo.

    Thomas
