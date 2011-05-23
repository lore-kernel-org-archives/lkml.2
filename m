Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1EWRAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:00:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:16320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab1EWRAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:00:06 -0400
X-ExtLoop1: 1
From: "Anvin, H Peter" <h.peter.anvin@intel.com>
To: Arnd Bergmann <arnd@arndb.de>, "H.J. Lu" <hjl.tools@gmail.com>
CC: GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "x32-abi@googlegroups.com" <x32-abi@googlegroups.com>
Date: Mon, 23 May 2011 09:59:14 -0700
Subject: RE: X32 project status update
Thread-Topic: X32 project status update
Thread-Index: AcwXy6ypyleqm+OMQ+6t4ARedKZShQBnvREQ
Message-ID: <ADDEBCD9C145E542A8688C29F1FBDCB9013041770F@orsmsx502.amr.corp.intel.com>
References: <BANLkTinM_=bAjD59=GiKtTvjLtoOs7KCFA@mail.gmail.com>
 <201105211727.35985.arnd@arndb.de>
In-Reply-To: <201105211727.35985.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The eventual goal is to merge it with the x86-64 syscall table, although we're still working out exactly where we can do it.

	-hpa

-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de] 
Sent: Saturday, May 21, 2011 8:28
To: H.J. Lu
Cc: GCC Development; GNU C Library; LKML; x32-abi@googlegroups.com; Anvin, H Peter
Subject: Re: X32 project status update

On Saturday 21 May 2011 17:01:33 H.J. Lu wrote:
> This is the x32 project status update:
> 
> https://sites.google.com/site/x32abi/
> 

I've had another look at the kernel patch. It basically
looks all good, but the system call table appears to
diverge from the x86_64 list for no (documented) reason,
in the calls above 302. Is that intentional?

I can see why you might want to keep the numbers identical,
but if they are already different, why not use the generic
system call table from asm-generic/unistd.h for the new
ABI?

	Arnd
