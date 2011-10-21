Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab1JUOnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 10:43:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab1JUOnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 10:43:15 -0400
Date: Fri, 21 Oct 2011 16:43:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: "Xu, Anhua" <anhua.xu@intel.com>, "acme@redhat.com" <acme@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>, "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
 sample type
Message-ID: <20111021144303.GG2033@jolsa.brq.redhat.com>
References: <1317312068-10411-1-git-send-email-jolsa@redhat.com>
 <1A42CE6F5F474C41B63392A5F80372B212DCA02CB2@shsmsx501.ccr.corp.intel.com>
 <20111021081024.GA2033@jolsa.brq.redhat.com>
 <4EA17EAE.8040905@gmail.com>
 <4EA181E1.5090101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA181E1.5090101@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 08:29:53AM -0600, David Ahern wrote:
> 
> 
> On 10/21/2011 08:16 AM, David Ahern wrote:
> > 
> > 
> > On 10/21/2011 02:10 AM, Jiri Olsa wrote:
> >> On Fri, Oct 21, 2011 at 03:18:31PM +0800, Xu, Anhua wrote:
> >>> I installed the latest kernel and found without such patch( not sure if other patches were added besides this one). That following command works fine.
> >>> perf record -o perf.data -e ext3:ext3_request_inode -e LLC-loads -- date '+%F'
> >> hi,
> >> was there any ext3 event stored? The issue should be hit when
> >> processing stored events.. either in the atexit code or during
> >> report.
> >>
> >> Following command freezes for me on 3.1.0-rc10-tip+:
> >> ./perf record -o perf.data -e ext4:ext4_request_inode -e LLC-loads -- date '+%F'
> >>
> > 
> > With -B and it doesn't for me. Without the -B argument the backtrace
> > shows it stuck here:
> 
> While it doesn't hang with the -B, the data file is worthless --
> non-matching sample type. :-)

right :) there's check when the session is opened for reading

jirka
