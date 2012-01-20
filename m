Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab2ATBkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:40:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42201 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab2ATBk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:40:29 -0500
MIME-Version: 1.0
In-Reply-To: <4F18B911.2060601@oak.selfip.net>
References: <4F18B911.2060601@oak.selfip.net>
Date: Thu, 19 Jan 2012 20:40:27 -0500
Message-ID: <CA+5PVA5U-mJKMR63=1Tc6arjhtTkFNOjvSumFiENdJRyVs1Epg@mail.gmail.com>
Subject: Re: PROBLEM: Postgres fails to start due to kernel issue?
From: Josh Boyer <jwboyer@gmail.com>
To: Dave Haywood <tla@oak.selfip.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 7:45 PM, Dave Haywood <tla@oak.selfip.net> wrote:
> Hi,
>
>  I noticed after upgrading to 3.2.0-08812-gc2bc3a3 that Postgres-9.1 server
> fails to start with error:
>
> FATAL:  could not create shared memory segment: Function not implemented
> DETAIL:  Failed system call was shmget(key=5432001, size=30523392, 03600).
>
>  After some googling, I thought it was a SYSV shared memory sizing issue but
> manually changing kernel.shmmax and kernel.shmall had no effect.
>
>  The problem has been introduced between 3.2.0-08694-g53999bf and
> 3.2.0-08812-gc2bc3a3.
>
>  Let me know if you need any more information.  Bisecting is *very* slow on
> this machine!

If you run strace on it, does it fail with ENOSYS?  This might be
related to an issue Peter just fixed.

josh
