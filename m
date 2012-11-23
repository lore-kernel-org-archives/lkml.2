Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab2KWJo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:44:28 -0500
Received: from gmmr7.centrum.cz ([46.255.225.249]:57559 "EHLO gmmr7.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759104Ab2KWJo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:44:26 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_memory=2Dcgroup_bug?=
Date: Fri, 23 Nov 2012 10:44:23 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>
References: <20121121200207.01068046@pobox.sk>, <20121122152441.GA9609@dhcp22.suse.cz>, <20121122190526.390C7A28@pobox.sk>, <20121122214249.GA20319@dhcp22.suse.cz>, <20121122233434.3D5E35E6@pobox.sk>, <20121123074023.GA24698@dhcp22.suse.cz>, <20121123102137.10D6D653@pobox.sk> <20121123092829.GE24698@dhcp22.suse.cz>
In-Reply-To: <20121123092829.GE24698@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121123104423.338C7725@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, "cgroups mailinglist" <cgroups@vger.kernel.org>
>On Fri 23-11-12 10:21:37, azurIt wrote:
>> >Either use gdb YOUR_VMLINUX and disassemble mem_cgroup_handle_oom or
>> >use objdump -d YOUR_VMLINUX and copy out only mem_cgroup_handle_oom
>> >function.
>> If 'YOUR_VMLINUX' is supposed to be my kernel image:
>> 
>> # gdb vmlinuz-3.2.34-grsec-1 
>> GNU gdb (GDB) 7.0.1-debian
>> Copyright (C) 2009 Free Software Foundation, Inc.
>> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
>> This is free software: you are free to change and redistribute it.
>> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
>> and "show warranty" for details.
>> This GDB was configured as "x86_64-linux-gnu".
>> For bug reporting instructions, please see:
>> <http://www.gnu.org/software/gdb/bugs/>...
>> "/root/bug/vmlinuz-3.2.34-grsec-1": not in executable format: File format not recognized
>> 
>> 
>> # objdump -d vmlinuz-3.2.34-grsec-1 
>
>You need vmlinux not vmlinuz...




ok, got it but still no luck:

# gdb vmlinux 
GNU gdb (GDB) 7.0.1-debian
Copyright (C) 2009 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /root/bug/dddddddd/vmlinux...(no debugging symbols found)...done.
(gdb) disassemble mem_cgroup_handle_oom
No symbol table is loaded.  Use the "file" command.



# objdump -d vmlinux | grep mem_cgroup_handle_oom
<no output>


i can recompile the kernel if anything needs to be added into it.


azur
