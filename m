Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3AEBFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 20:05:09 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:38742 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab3AEBFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 20:05:07 -0500
Date: Sat, 5 Jan 2013 02:05:01 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PEBS (in perf) stopped working from 3.6 -> 3.7
Message-ID: <20130105010501.GA5371@uio.no>
References: <20130104234743.GA12331@uio.no>
 <50E770DB.2050803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50E770DB.2050803@gmail.com>
X-Operating-System: Linux 3.7.1 on a x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-Score: 1.3 (+)
X-Spam-Report: Status=No hits=1.3 required=5.0 tests=FREEMAIL_FROM,RDNS_NONE version=3.3.1 hostname=cassarossa.samfundet.no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 05:16:27PM -0700, David Ahern wrote:
> Known problem. Pick one of: update perf to 3.7, add H to the command
> (-e cycles:ppH) or apply this patch:
> https://lkml.org/lkml/2012/12/28/384

I spoke too soon. This works for cycles, but not for branch-misses:

  pannekake:~> sudo perf record -e branch-misses:ppH -a
  
    Error: sys_perf_event_open() syscall returned with 95 (Operation not supported) for event branch-misses:ppH. /bin/dmesg may provide additional information.
  
  No hardware sampling interrupt available. No APIC? If so then you can boot the kernel with the "lapic" boot parameter to force-enable it.

Why would the two be different?

/* Steinar */
-- 
Homepage: http://www.sesse.net/
