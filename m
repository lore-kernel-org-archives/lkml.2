Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2DXPMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:12:12 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:41752 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2DXPMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:12:09 -0400
Message-ID: <4F96C2CF.5070900@gmail.com>
Date: Tue, 24 Apr 2012 11:12:15 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-man@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@osdl.org>, kosaki.motohiro@gmail.com
Subject: Re: Bad error return after find_vma() in PR_SET_MM code
References: <CAKgNAkjWdy_SYaJsNXUOv7cNL2xwZNW7FCdRsT6wiRFb0dmetw@mail.gmail.com>
In-Reply-To: <CAKgNAkjWdy_SYaJsNXUOv7cNL2xwZNW7FCdRsT6wiRFb0dmetw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/15/12 12:00 AM), Michael Kerrisk (man-pages) wrote:
> [Bother! Resending with corrected subject line (was "[PATCH 1/2]
> prctl: Add PR_SET_MM option description")]
>
> Cyrill,
>
> While reviewing your patch to the prctl() manual page, I noticed the
> following code in kernel/sys.c::prctl_set_mm():
>
>         if (opt != PR_SET_MM_START_BRK&&  opt != PR_SET_MM_BRK) {
>                 /* It must be existing VMA */
>                 if (!vma || vma->vm_start>  addr)
>                         goto out;
>         }
>
> At this point, the code causes an exit with error set to zero (i.e.,
> success). This looks unintended to me. Is the code correct? I suspect
> a return of -EFAULT or -ENOMEM is warranted.

EFAULT please when detecting invalid vma.

