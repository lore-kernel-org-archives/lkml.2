Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2JVIkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:40:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2JVIkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:40:39 -0400
Date: Mon, 22 Oct 2012 10:40:16 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 03/11] perf tool: Use PERF_EVENT_IOC_ID perf ioctl to
 read event id
Message-ID: <20121022084016.GB1758@krava.brq.redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
 <1350743599-4805-4-git-send-email-jolsa@redhat.com>
 <87ehkrj5wb.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehkrj5wb.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 04:57:24PM +0900, Namhyung Kim wrote:
> Hi,
> 
> Just a minor nitpicking..
> 
> 
> On Sat, 20 Oct 2012 16:33:11 +0200, Jiri Olsa wrote:
> > Changing the way we retrieve the event ID. Instead of parsing out
> > the ID out of the read data, using the PERF_EVENT_IOC_ID ioctl.
> >
> > Keeping the old way in place to support kernels without
> > PERF_EVENT_IOC_ID ioctl support.
> [snip]
> > +	} else if (errno)
> > +		return -1;
> 
> Is this check really needed?  I think that returning non-zero from the
> ioctl always sets the errno, no?  How about this:
> 
> 	ret = ioctl(fd, PERF_EVENT_IOC_ID, &id);
> 	if (!ret)
> 		goto add;
> 
> 	if (errno != ENOTTY)
> 		return -1;
> 
> 	...
> 
> I guess that it'll show you better diff stat. :)

yep, looks better.. v2 candidate ;)

thanks,
jirka
