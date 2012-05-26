Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab2EZDQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 23:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab2EZDQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 23:16:07 -0400
Date: Sat, 26 May 2012 00:15:56 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tool: Add modifiers to be part of the event name
Message-ID: <20120526031556.GE6344@infradead.org>
References: <1336695468-5464-1-git-send-email-andi@firstfloor.org>
 <20120511102522.GA2012@m.brq.redhat.com>
 <20120525223528.GK27374@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525223528.GK27374@one.firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, May 26, 2012 at 12:35:28AM +0200, Andi Kleen escreveu:
> On Fri, May 11, 2012 at 12:25:22PM +0200, Jiri Olsa wrote:
> > On Thu, May 10, 2012 at 05:17:48PM -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > We need to save the original string for perf stat output,
> > > otherwise :t and :c are invisible.
> > 
> > right, the modifier got lost
> > 
> > We need to fix the name once modifier is detected and final
> > event name is assigned (e.g. there could be "*?" in the tracepoint
> > event name, causing the name to be unwinded..).
> 
> What happened to this patch? Seems to be still broken in 3.4

The latest patchset I submitted should fix this for raw and hardware
events.

Saving the events specified by the user is not sufficient, as those
strings are not saved in perf.data files, we must reconstruct the
strings from what is stored in the perf_event_attr fields.

- Arnaldo
