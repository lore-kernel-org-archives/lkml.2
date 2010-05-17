Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0EQQtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:49:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64786 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab0EQQtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:49:15 -0400
Date: Mon, 17 May 2010 09:47:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Will Drewry <wad@chromium.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com,
       snitzer@redhat.com
Subject: Re: [RFC PATCH v2 2/2] init: boot to device-mapper targets without
 an initr*
Message-Id: <20100517094724.48632380.randy.dunlap@oracle.com>
In-Reply-To: <1273887701-2152-2-git-send-email-wad@chromium.org>
References: <20100514035347.GA20636@redhat.com>
	<1273887701-2152-2-git-send-email-wad@chromium.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090202.4BF17380.00C6:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 20:41:41 -0500 Will Drewry wrote:

> Add a dm= kernel parameter modeled after the md= parameter from
> do_mounts_md.  It allows for device-mapper targets to be configured at
> boot time for use early in the boot process (as the root device or
> otherwise).

dm=<blah>
documentation needs to be added to Documentation/kernel-parameters.txt and/or
Documentation/md.txt.


> The format is dm="name uuid ro,table line 1,table line 2,...".  The
> parser expects the comma to be safe to use as a newline substitute but,
> otherwise, uses the normal separator of space.  Some attempt has been
> made to make it forgiving of additional spaces (using skip_spaces()).

This "space in the arg string" has been tested, right?
It seems a bit odd to me.  Most kernel parameter strings that I am familiar with
use punctuation for separating parameter parts.


> A mapped device created during boot will be assigned a minor of 0 and
> may be access via /dev/dm-0.
> 
> An example dm-linear root with no uuid may look like:
> 
>   root=/dev/dm-0  dm="lroot none 0, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0"
> 
> Once udev is started, /dev/dm-0 will become /dev/mapper/lroot.
> 
> Signed-off-by: Will Drewry <wad@chromium.org>
> ---
>  init/Makefile       |    1 +
>  init/do_mounts.c    |    1 +
>  init/do_mounts.h    |   10 ++
>  init/do_mounts_dm.c |  353 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 365 insertions(+), 0 deletions(-)
>  create mode 100644 init/do_mounts_dm.c



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
