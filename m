Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0K3OCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:02:21 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58860 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab0K3OCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:02:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=WZmwu8Z4Z/bZ+ZDN1r19BQAjUi3frb2IPizzHtik7rJ+ngRCYNYbJhz1V2luxdI74v
         MGOTYT8SAHImEt3ZG2AeMsmgvJbLLR8mareNGB5U97D8Kkx5ceJtJt1k9R6UyVgRemeW
         oPZzakIxlEUQ1QWVI2EhIg6PGWspLy5/tAtcs=
Date: Tue, 30 Nov 2010 12:02:13 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/6] perf: Add timestamp to COMM and MMAP events
Message-ID: <20101130140213.GB9217@ghostprotocols.net>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
 <1290490544-14349-4-git-send-email-imunsie@au1.ibm.com>
 <1290510512.2072.387.camel@laptop>
 <20101123124121.GA11101@ghostprotocols.net>
 <20101125154718.GE15875@ghostprotocols.net>
 <1291009409-sup-4332@au1.ibm.com>
 <1291031690.32004.20.camel@laptop>
 <1291073899-sup-7083@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291073899-sup-7083@au1.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 30, 2010 at 10:45:40AM +1100, Ian Munsie escreveu:
> Excerpts from Peter Zijlstra's message of Mon Nov 29 22:54:50 +1100 2010:
> > On Mon, 2010-11-29 at 17:06 +1100, Ian Munsie wrote:
> > > This goes away if PERF_SAMPLE_CPU is added to the mix so that the
> > > timestamps are offset from the first event of *their* CPU,
> > > otherwise time-epoch can go negative, as it has done here. 

> > How does that happen, I though the power7 sched_clock() was fully
> > synchronized and monotonic across all cores?

> Oh the timestamps coming from the kernel are fine, I should have been
> clearer in my email. This bug is purely restricted to the userspace code
> that prints them out - in the perf_session__print_tstamp function. It
> tries to print the timestamps out so that they start at 0 and if it
> doesn't know what CPU the events came from it uses the very first event
> it sees as epoch, but at the moment that is not necessarily going to be
> the earliest event.
 
> Thinking about it overnight, I realise that this should also go away if
> we sort them before printing things out at all, which is exactly what
> I'm proposing to do in my patches.

I removed that in the current version of this patch series:

http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=shortlog;h=refs/heads/perf/sample_id_all.v3

Now I'm just testing if a new perf.data file can be processed just fine
by older tools (not possible in the sample_id_all.v1 series) and other
combinations of older kernels with the new tool.

Probably I'll fold two patches and then submit for review.

- Arnaldo
