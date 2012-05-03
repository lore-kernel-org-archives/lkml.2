Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2ECLYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:24:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:38007 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2ECLYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:24:42 -0400
Message-ID: <1336044261.22523.11.camel@twins>
Subject: Re: [PATCH 9/9] perf tool: Add pmu event alias support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 13:24:21 +0200
In-Reply-To: <20120503105655.GB1671@m.brq.redhat.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
	 <1335924440-11242-10-git-send-email-zheng.z.yan@intel.com>
	 <20120503105655.GB1671@m.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 12:56 +0200, Jiri Olsa wrote:
> - in sysfs you would have directory with aliases (now called 'events')
> - each alias is sysfs dir, with file attrs:
>         file name = term name, file value = term value
>   eg.:
>         events/
>                 CAS_COUNT_RD/
>                         # files:
>                         config  - value 1
>                         config1 - value 2
>                         mask    - value ... 

I'd prefer the thing Yan proposed (if the sysfs folks let us),

$foo/events/QHL_REQUEST_REMOTE_READS

with contents: "event=0x20,umask=0x4"

> this way it's also possible to add extra terms to existing alias
> in command line if needed... might be handy
> 
That should always be possible, if you modify the parser to take things
like:

  event=0x20,umask=0x4,event=0x21

and have latter values override earlier values, so it collapses into:

  umask=0x4,event=0x21

you can simply take whatever comes out of the event file and stick extra
bits at the end.
