Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0JVCDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 22:03:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57518 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0JVCDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 22:03:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ArsOxguF7bRRu1RyJv7eXCd1DP4wo0imlUHuFfvIYkEWIh+16+GET+kLpvIqIjEWao
         daM+EyLP7/AeLXsdJW6gCi2o0SLOLynJkn+uL1EBjxhM5qSZSYdVDbC7rhtsQl0zK+AB
         ag04nTo+jvngqHgCfnEzCjpX53g14vbegApCQ=
MIME-Version: 1.0
Date: Thu, 21 Oct 2010 22:03:37 -0400
Message-ID: <AANLkTi=BMrsMjj5-v4-VLhGWp+kny3mxgUmhF6ywHSy-@mail.gmail.com>
Subject: Info regarding MTRR handling
From: Andev <debiandev@gmail.com>
To: rgooch@atnf.csiro.au, yinghai@kernel.org
Cc: linux kernel <kernelnewbies@nl.linux.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

I am having some trouble understanding the implementation of MTRR
handling in Linux.
I am trying to see the performance impact by disabling all cache. As a
first step I am
disabling MTRR.

Intially when I boot up my mtrr file is as following:

$ cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size=131072MB: write-back, count=1
reg01: base=0xcff00000 (3327MB), size=   1MB: uncachable, count=1
reg02: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
reg03: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
reg04: base=0x1ff0000000 (130816MB), size= 256MB: uncachable, count=1

There seems to be a discrepancy because I have 8 gb RAM in my system.

Now I run an OmpSCR benchmark
-------------------------
$ ./c_lu 800

This program is part of the OpenMP Source Code Repository (OmpSCR)

Program:       ./c_lu
Description:   LU reduction of a dense matrix.

Argument size 800
Argument NUMTHREADS 1

Running ...

Timer EXE_TIME     1.645332
-----------------------

So, I go ahead and disable the write-back cache as follows:

$ echo "disable=00" > /proc/mtrr
$ echo "base=0x00000000 size=0x80000000 type=uncachable" > /proc/mtrr

Now I again run the benchmark

$ ./c_lu 800

This program is part of the OpenMP Source Code Repository (OmpSCR)

Program:       ./c_lu
Description:   LU reduction of a dense matrix.

Argument size 800
Argument NUMTHREADS 1

Running ...
 runs for a verry long time.(> 10 min)

So there is some effect of disabling MTRR.
Again when I enable the MTRR, I am not able to restore to intial state.

$ echo "disable=00" > /proc/mtrr
$ echo "base=0x00000000 size=0x80000000 type=write-back" > /proc/mtrr

Even after doing this, there is no speedup compared to disabling MTRR.

It will really be helpful if you could point me as to where I am wrong.

Thanks,
Andev.
