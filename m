Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0JUXKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:10:19 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:41667 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751048Ab0JUXKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:10:17 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: RTNNTrgVM1mN.nqOs5aKaQP.d.pzlvDesyerygNPjHfIXdF
 xOOmj9eMyRnWS4V3OCWpye0VfWrJBDVvxjaBLb_XBQ_r_z8qnXuaWrhrZovi
 E0b8A9mijflZuypsd2jvp2FsIDvu_6W8ZW4WnG1Kmqf5XdHoPbxddEEXQFED
 LIuhKh8O.slBEpYguVqBkY.WC36CjJOFkXb95AYh_SBU93gIc3RkfyjYs5Ob
 umd8GPdeHoZzxUcC6PeUvOtK38xn.
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 21 Oct 2010 18:10:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Nick Piggin <npiggin@kernel.dk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
In-Reply-To: <20101021153719.c8bde251.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1010211807280.3431@router.home>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com> <1285762729-17928-17-git-send-email-david@fromorbit.com> <20100929215322.ff635d3e.akpm@linux-foundation.org> <20100930061039.GX5665@dastard> <20101016075510.GH19147@amd>
 <1287217748.2799.68.camel@edumazet-laptop> <20101016020744.366bd9c6.akpm@linux-foundation.org> <1287221475.2799.123.camel@edumazet-laptop> <1287238754.2799.376.camel@edumazet-laptop> <20101021153719.c8bde251.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010, Andrew Morton wrote:

> That isn't actually what I was suggesting.  I was suggesting the use of
> an inlined, this_cpu_add()-using percpu_counter_add() variant which
> still does the batched spilling into ->count.  IOW, just speed up the
> current implementation along the lines of
>
> {
> 	val = this_cpu_add_return(*fbc->counters, amount);

this_cpu_add_return() is not in the kernel but could be realized using a
variant offshoot of cmpxchg_local. I had something like that initially but
omitted it since there was no use case.

