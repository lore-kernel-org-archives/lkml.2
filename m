Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2H1UZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 16:25:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41805 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2H1UZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 16:25:14 -0400
Date: Tue, 28 Aug 2012 13:24:59 -0700
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jim Meyering <jim@meyering.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] kmemleak: avoid buffer overrun: NUL-terminate
 strncpy-copied command
Message-ID: <20120828202459.GA13638@mwanda>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
 <1345481724-30108-4-git-send-email-jim@meyering.net>
 <20120824102725.GH7585@arm.com>
 <876288o7ny.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <876288o7ny.fsf@rho.meyering.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 01:23:29PM +0200, Jim Meyering wrote:
> In that case, what would you think of a patch to use strcpy instead?
> 
>   -		strncpy(object->comm, current->comm, sizeof(object->comm));
>   +		strcpy(object->comm, current->comm);

Another option would be to use strlcpy().  It's slightly neater than
the strncpy() followed by a NUL assignment.

> 
> Is there a preferred method of adding a static_assert-like statement?
> I see compile_time_assert and a few similar macros, but I haven't
> spotted anything that is used project-wide.

BUILD_BUG_ON().

regards,
dan carpenter

