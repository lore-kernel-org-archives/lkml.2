Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251Ab0KMAGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 19:06:25 -0500
Received: from mout.perfora.net ([74.208.4.195]:57810 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933218Ab0KMAGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 19:06:24 -0500
Message-ID: <4CDDD68D.4050506@nctritech.com>
Date: Fri, 12 Nov 2010 19:06:37 -0500
From: Jody Bruchon <jody@nctritech.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ACPI+Inspiron 1545 = crash at xrstor_state()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:H1TzcEd0J+sJC//MZxwa5ooRAXXgz3p/yQ8o8g8Z4/V
 rayIk4jfL/q+xdYFdUyF143B+KR8HdrXl6hL5EvvoJaeHavdl/
 kJi1Unmgns+7ZntJ4wcVjBYv3+7Yufs/pajasE4hDVT5GXjs5n
 I9RKtEEm1LFDuif6kcM+QByVUBJbqDhL0U4xaFzAevbvYqiXVL
 nytj/qWL4CqPrgJlhfSAkOVqyj+iyk6jZfjnqZIlsA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I previously reported a boot hang on an Inspiron 1545 laptop which is 
cured by disabling CONFIG_ACPI.  I didn't know about the "earlyprintk" 
boot option, and upon using it, I was able to see the actual crash.  
Hopefully the following information will help.  Note that I have turned 
off SMP and APIC/LAPIC support, but the bug persists even with these 
disabled (I noticed a lot of APIC/IO-APIC code that is eliminated in 
early boot if they're disabled.)

The crash was in function xsave_init with EIP at xstate_enable_boot_cpu 
(the last normal message output before this was "Initializing CPU#0").  
To narrow this down further, I edited xsave.c to be full of printk() 
messages for each called function.  The last printk message indicates 
that the function in xsave.c which crashes out is:

xrstor_state(init_xstate_buf, -1);

The result is a general protection fault.  xrstor_state is just a tiny 
piece of asm code, and at this point I've reached the extent of my 
current capabilities, so I don't know where to go from here.  I can 
manually type out chunks of the crash info on request.  I'm clueless as 
to how the inclusion of ACPI causes this.

Please CC my email if you respond since I don't subscribe to LKML.  
Thanks in advance.

Jody Bruchon
