Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0FSSNM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 14:13:12 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53978 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756356Ab0FSSNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 14:13:10 -0400
Message-ID: <4C1D08B4.50806@fusionio.com>
Date: Sat, 19 Jun 2010 20:13:08 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
CC: Miklos Szeredi <miklos@szeredi.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
References: <20100524070552.GR23411@kernel.dk> <AANLkTimDJjHWKISxnLax3r200Db8OQp_lMKOx14ONgkS@mail.gmail.com> 	<20100524175649.GV23411@kernel.dk> <AANLkTim_yrRZG6v1tMPgefeaaI-nUa35Q-mLQpuXWJ1p@mail.gmail.com> 	<20100601074534.GL1660@kernel.dk> <AANLkTinGfonivZvofBkMzv53IJZeKbFAEMVpv96BiJ30@mail.gmail.com> 	<20100603061039.GD3564@kernel.dk> <AANLkTint7OJvmTn7d7bqTJzsCxV-VlVT46PQWVH-m73g@mail.gmail.com> 	<20100603070126.GJ3564@kernel.dk> <AANLkTilwyuE-HiY0vX5askTNi1KoeuKIldmE85WrfIqU@mail.gmail.com> 	<AANLkTin2b7qE1zo0fQWIhYIzdV26zNBjHRcNAOELpUfK@mail.gmail.com> 	<4C078610.6020901@fusionio.com> <AANLkTinhO5oRDPXyXaeAOZU3i55eBKsx4iFMOzwm98na@mail.gmail.com> 	<AANLkTin_8MU3AbJ_KeXr2uTxtRFJ5ABmBAyigU6m-C6u@mail.gmail.com> 	<4C078E2B.7090107@fusionio.com> <E1OK8fK-0007Wa-BU@pomaz-ex.szeredi.hu> 	<4C0793F6.4070107@fusionio.com> <E1OK9nN-0007gB-LB@pomaz-ex.szeredi.hu> 	<4C07A51E.6090604@fusionio.com> <AANLkTim3VzQVp3d6FIytYcf_H1Y8kjGELr9hehIeobAU@mail.gmail.com>
In-Reply-To: <AANLkTim3VzQVp3d6FIytYcf_H1Y8kjGELr9hehIeobAU@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/10 07.45, Michael Kerrisk wrote:
> Hello Jens,
> 
> I've tested this F_SETPIPE_SZ code as it appears in 2.6.35-rc3, and
> things seem to work as advertised, if the text below is the correct
> advertisement. Could you please review the following man-pages text,
> and let me know if it's okay.
> 
> fcntl.2:
>        F_SETPIPE_SZ (long; since Linux 2.6.35)
>               Change  the  capacity of the pipe referred to by
>               fd to be at least arg  bytes.   An  unprivileged
>               process  can  adjust  the  pipe  capacity to any
>               value between the system page size and the limit
>               defined   in   /proc/sys/fs/pipe-size-max   (see
>               proc(5)).  Attempts to  set  the  pipe  capacity
>               below  the  page size are silently rounded up to
>               the page size.  Attempts by an unprivileged pro-
>               cess to set the pipe capacity above the limit in
>               /proc/sys/fs/pipe-size-max   yield   the   error
>               EPERM;  a  privileged process (CAP_SYS_RESOURCE)
>               can override the  limit.   When  allocating  the
>               buffer for the pipe, the kernel may use a capac-
>               ity larger than arg, if that is  convenient  for
>               the  implementation.  The F_GETPIPE_SZ operation
>               returns the actual size used.  Attempting to set
>               the  pipe  capacity  smaller  than the amount of
>               buffer space currently used to store  data  pro-
>               duces the error EBUSY.
> 
>        F_GETPIPE_SZ (void; since Linux 2.6.35)
>               Return  (as the function result) the capacity of
>               the pipe referred to by fd.
> 
> And in proc.5:
>        /proc/sys/fs/pipe-max-size (since Linux 2.6.35)
>               The value in this file defines  an  upper  limit
>               for  raising  the  capacity  of a pipe using the
>               fcntl(2)  F_SETPIPE_SZ  operation.   This  limit
>               applies  only  to  unprivileged  processes.  The
>               default value for this file is  1,048,576.   The
>               value  assigned  to  this  file  may  be rounded
>               upward, to reflect the value  actually  employed
>               for  a  convenient implementation.  To determine
>               the rounded-up value, display  the  contents  of
>               this  file  after  assigning a value to it.  The
>               minimum value that can be assigned to this  file
>               is the system page size.

Looks good to me.

-- 
Jens Axboe

