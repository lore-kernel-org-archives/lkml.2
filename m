Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab2ECUmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:42:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54309 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755442Ab2ECUmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:42:07 -0400
Date: Thu, 3 May 2012 17:42:12 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/13] perf target: Introduce perf_target_errno
Message-ID: <20120503204212.GC8807@infradead.org>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
 <1335417327-11796-10-git-send-email-namhyung.kim@lge.com>
 <20120502185913.GE5745@infradead.org>
 <4FA2EBCC.5060905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA2EBCC.5060905@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 03, 2012 at 02:34:20PM -0600, David Ahern escreveu:
> On 5/2/12 12:59 PM, Arnaldo Carvalho de Melo wrote:
> >Also it would be better to have it as PERF_ERRNO__PID_OVERRIDE_CPU, etc.
> 
> I thought you wanted subsystem based errno's (PERF_TARGET__XXXXX)
> versus one big set (PERF_ERRNO__XXXXX). Did you change your mind?

Oops, I didn't realize PID being the subsys, then yeah, that is ok.

But that would make it PERF_ERR__TARGET_, as PERF_TARGET__ doesn't
straight away brings back "error enumeration", at least for me :)

But this is getting overly long, ideas?

PERF_ we need, its libperf's "namespace", then ERRNO looks needed too,
heck, make it long:

PERF_ERRNO_TARGET__PID_OVERRIDE_CPU

After all most of the time this will just be inside the function setting
the error and the strerrno function that will convert this to an string,
right?

- Arnaldo
