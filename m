Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2DXPPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:15:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:32920 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754111Ab2DXPPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:15:51 -0400
Date: Tue, 24 Apr 2012 19:15:44 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: mtk.manpages@gmail.com, Pavel Emelyanov <xemul@parallels.com>,
        linux-man@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: Bad error return after find_vma() in PR_SET_MM code
Message-ID: <20120424151544.GH21224@moon>
References: <CAKgNAkjWdy_SYaJsNXUOv7cNL2xwZNW7FCdRsT6wiRFb0dmetw@mail.gmail.com>
 <4F96C2CF.5070900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F96C2CF.5070900@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 11:12:15AM -0400, KOSAKI Motohiro wrote:
> (4/15/12 12:00 AM), Michael Kerrisk (man-pages) wrote:
> >[Bother! Resending with corrected subject line (was "[PATCH 1/2]
> >prctl: Add PR_SET_MM option description")]
> >
> >Cyrill,
> >
> >While reviewing your patch to the prctl() manual page, I noticed the
> >following code in kernel/sys.c::prctl_set_mm():
> >
> >        if (opt != PR_SET_MM_START_BRK&&  opt != PR_SET_MM_BRK) {
> >                /* It must be existing VMA */
> >                if (!vma || vma->vm_start>  addr)
> >                        goto out;
> >        }
> >
> >At this point, the code causes an exit with error set to zero (i.e.,
> >success). This looks unintended to me. Is the code correct? I suspect
> >a return of -EFAULT or -ENOMEM is warranted.
> 
> EFAULT please when detecting invalid vma.

Thanks for reminder, Kosaki! I'll cook a patch asap.

	Cyrill
