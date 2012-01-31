Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab2AaAMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:12:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32995 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2AaAMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:12:51 -0500
Date: Mon, 30 Jan 2012 16:12:46 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] PM/Freezer: Make thaw_processes() thaw only
 userspace tasks
Message-ID: <20120131001246.GF27616@google.com>
References: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com>
 <20120130231437.11129.3708.stgit@srivatsabhat.in.ibm.com>
 <20120130233055.GE27616@google.com>
 <4F27311C.5020200@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F27311C.5020200@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 31, 2012 at 05:39:00AM +0530, Srivatsa S. Bhat wrote:
> The thing is that, I wanted to avoid a bug in the patch posted at
> https://lkml.org/lkml/2012/1/29/47 as explained in the link.
> 
> So I guess I should have simply done:
> 
> freeze_kernel_threads() calls thaw_kernel_threads() upon error.
> The caller of freeze_kernel_threads() will call thaw_processes() if
> necessary.
> 
> This way even the SNAPSHOT_CREATE_IMAGE ioctl would remain safe.

Yeah, I'd prefer to avoid exporting "userland only" interface to
outside.  If it's some internal fail path thing, let's handle it
inside pm proper.

Thanks.

-- 
tejun
