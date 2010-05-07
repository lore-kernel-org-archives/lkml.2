Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab0EGAtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 20:49:50 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54809 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0EGAts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 20:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DPacQ7uiu2Pi4gWIGT3A7mIQwZqzv5LXduMQLwSuBvs2ac7rkYjT4z3ERQHWLmaMOe
         fY57VoLDIrD5LcZotdmCgn5dn1fjCxTfckyMiaw0M/Y3sQTNVlzzUBEAa/Uqq59kH+8Y
         yNb2CZIwo9XyP5fRBnLK3hfvapUcpD4HsKdPQ=
Date: Fri, 7 May 2010 02:49:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] perf lock: track only specified threads
Message-ID: <20100507004945.GA8069@nowhere>
References: <4BE28C8D.8000408@dcl.info.waseda.ac.jp> <1273138376-23323-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273138376-23323-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 06:32:56PM +0900, Hitoshi Mitake wrote:
> I implemented the feature of tracking only specified threads to perf lock.
> With -t option, users can specify which threads should be tracked.
> 
> Example of usage:
> | % sudo ./perf lock info -t                    # info -t is convenient with this feature
> |  Thread ID: comm
> |          0: swapper
> |          1: init
> |         12: migration/3
> |         13: ksoftirqd/3
> |         27: events/0
> |         28: events/1
> |         29: events/2
> |         30: events/3
> |         31: events/4
> |        857: kondemand/0
> |        858: kondemand/1
> |        859: kondemand/2
> | ...
> | % sudo ./perf lock -t 27,28,29,30,31 report   # track only these threads
> |                 Name   acquired  contended total wait (ns)   max wait (ns)   min wait (ns)



I'm not sure we want such per thread granularity filtering. I'm not
sure it will be very useful. But per process yeah.

And actually we should do that on tracing time rather than on post-processing.
This will lower the tracing overhead a lot.

Ideally I think we need:
	./perf lock record ls -R /

This would trace locks taken by this instance of ls only, ie: drop the -a
if we pass a command line.

What do you think?

