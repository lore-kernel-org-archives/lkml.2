Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab1BCNkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 08:40:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab1BCNkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 08:40:16 -0500
Date: Thu, 3 Feb 2011 11:40:03 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Tipp Moseley <tipp@google.com>
Cc: perfmon2-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf report/stat and symbolic event names
Message-ID: <20110203134003.GC10063@ghostprotocols.net>
References: <AANLkTikrV3fQ-qsOANG5X7zes1wxbO9mX1eev3xB_OzF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikrV3fQ-qsOANG5X7zes1wxbO9mX1eev3xB_OzF@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 02, 2011 at 05:18:21PM -0800, Tipp Moseley escreveu:
> Hey Arnaldo, Stephane suggested I mail you for this feature request to the
> perf tool.
> 
> When I collect a "raw" event using perf record, perf report's output is
> pretty useless.  E.g.:
> # Events: 833  raw 0x3d500a0
> So when I collect multiple events, I have to refer to the command line used
> to collect the profile and line up the event flags to figure out what I was
> collecting.  With multiple collection runs, this can become quite confusing.
> 
> The perf.data file doesn't seem to have the symbolic name of the event
> present.
> Do you think it would be reasonable to add a field to the profile to include
> the symbolic description of the event as it was given on the command line
> (e.g., "RS_UOPS_DISPATCHED:u:i:e:c=3")?

Its definetely a good idea to record in the perf.data header section the
command line that was passed to perf record.

A new tool, 'perf ls' could then look for files with the perf.data magic
number and show the contents of this section.

Extra enhancements would include globbing, so that one could do:

$ perf ls *UOPS*
$ perf ls *httpd*

Etc.

Recording the perf record on the header was suggested by Ingo a long
time ago, I just didn't got to implement it :-\

If you can try to implement it, please see how build ids are encoded in
the perf.data header.

Otherwise I'll try to do it at some point.

- Arnaldo
