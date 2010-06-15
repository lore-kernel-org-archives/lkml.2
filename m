Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab0FOXrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 19:47:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58851 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab0FOXrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 19:47:15 -0400
Date: Tue, 15 Jun 2010 16:46:51 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Julia Lawall <julia@diku.dk>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 15/17] fs/ocfs2/dlm: Add missing spin_unlock
Message-ID: <20100615234651.GE30497@mail.oracle.com>
Mail-Followup-To: Julia Lawall <julia@diku.dk>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1005261758290.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005261758290.23743@ask.diku.dk>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4C1810FC.016F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 05:58:53PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Add a spin_unlock missing on the error path.  Unlock as in the other code
> that leads to the leave label.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression E1;
> @@
> 
> * spin_lock(E1,...);
>   <+... when != E1
>   if (...) {
>     ... when != E1
> *   return ...;
>   }
>   ...+>
> * spin_unlock(E1,...);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"In the arms of the angel, fly away from here,
 From this dark, cold hotel room and the endlessness that you fear.
 You are pulled from the wreckage of your silent reverie.
 In the arms of the angel, may you find some comfort here."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
