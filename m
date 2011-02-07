Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1BGRR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:17:29 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:27856 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754100Ab1BGRR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:17:28 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: VctnhKwVM1lzzESMIJ0Y1L0DwjiPo5gWUHXmOwBbxCoQlaQ
 SyZzXVgfxSdxWyeXYKTVadEXik_AECYerwkmYePDLr8Z9NOMVmqUTHL.cj9I
 vx2ZBZrXiVGkJMevxB_hnqiJcya3G_8VD.i_FhPAdpQXPzWVf2J.09OJBXFn
 FkFnXfBIix.NHBUkGzU_u7omaKahFPSXjVvT3y2iim1DTb11WN.9hjj5k2Sk
 UAGs2QS6NkKWwlBPHVlnpXY7sRzqEkGiKmg5fKy4kMDvLmAjrMgliY2BtYFi
 I2qkFLsNEB_t0m2YZsy4bxDZUNdqJ89_ITOpahQBM8FvzRZQ-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 7 Feb 2011 11:17:25 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jan Beulich <JBeulich@novell.com>
cc: tj@kernel.org, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: x86: mis-named percpu_xchg_op() after switch to cmpxchg?
In-Reply-To: <4D4FDF050200007800030883@vpn.id2.novell.com>
Message-ID: <alpine.DEB.2.00.1102071115070.3911@router.home>
References: <4D4FDF050200007800030883@vpn.id2.novell.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, Jan Beulich wrote:

> Other than its name implies, with the switch to use cmpxchg instead of
> xchg (commit 8270137a0d50507a5b40f880db636527045b8466) this
> macro is no longer suitable for accessing anything that may be written
> by other than the local CPU (i.e. anything but the various this_cpu
> accessors). Shouldn't it therefore get renamed to eg this_cpu_xchg_op()?

No. The intend of the percpu_xchg_op was also to provide local cpu only
semantics. percpu_xx operations in general have the same semantics as
this_cpu operations.

