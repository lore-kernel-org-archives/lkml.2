Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab1K3Eyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 23:54:45 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64542 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1K3Eym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 23:54:42 -0500
Message-ID: <4ED5B70F.606@lwfinger.net>
Date: Tue, 29 Nov 2011 22:54:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: 3.2-rc2 freezes on boot for AMD K6 - bisected to commit bcb80e53877c2045d9e52f4a71372c3fe6501f6f
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an ancient laptop with an AMD-K6 CPU that freezes on boot with 3.2-rc2. 
The problem was bisected to commit bcb80e53877c2.

The cpuinfo for this box is:

 >> cpu.1: cpuinfo
----- /proc/cpuinfo -----
   processor     : 0
   vendor_id     : AuthenticAMD
   cpu family    : 5
   model         : 8
   model name    : AMD-K6(tm) 3D processor
   stepping      : 12
   cpu MHz               : 428.804
   cache size    : 64 KB
   fdiv_bug      : no
   hlt_bug               : no
   f00f_bug      : no
   coma_bug      : no
   fpu           : yes
   fpu_exception : yes
   cpuid level   : 1
   wp            : yes
   flags         : fpu vme de pse tsc msr cx8 pge mmx syscall 3dnow k6_mtrr up
   bogomips      : 857.60
   clflush size  : 32
   cache_alignment       : 32
   address sizes : 32 bits physical, 32 bits virtual
   power management:

----- /proc/cpuinfo end -----

This patch is quite simple, thus it appears that rdmsr() is OK, but that 
rdmsr_safe() is not.

I am happy to provide any other info regarding this box.

Larry

