Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0CROjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:39:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41422 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab0CROjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:39:03 -0400
Message-ID: <4BA23AF3.1020209@codemonkey.ws>
Date: Thu, 18 Mar 2010 09:38:43 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu>
In-Reply-To: <20100317081041.GC16374@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------070604040701010707050704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070604040701010707050704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/17/2010 03:10 AM, Ingo Molnar wrote:
> * Anthony Liguori<anthony@codemonkey.ws>  wrote:
>
>    
>> On 03/16/2010 12:39 PM, Ingo Molnar wrote:
>>      
>>>> If we look at the use-case, it's going to be something like, a user is
>>>> creating virtual machines and wants to get performance information about
>>>> them.
>>>>
>>>> Having to run a separate tool like perf is not going to be what they would
>>>> expect they had to do.  Instead, they would either use their existing GUI
>>>> tool (like virt-manager) or they would use their management interface
>>>> (either QMP or libvirt).
>>>>
>>>> The complexity of interaction is due to the fact that perf shouldn't be a
>>>> stand alone tool.  It should be a library or something with a programmatic
>>>> interface that another tool can make use of.
>>>>          
>>> But ... a GUI interface/integration is of course possible too, and it's being
>>> worked on.
>>>
>>> perf is mainly a kernel developer tool, and kernel developers generally dont
>>> use GUIs to do their stuff: which is the (sole) reason why its first ~850
>>> commits of tools/perf/ were done without a GUI. We go where our developers
>>> are.
>>>
>>> In any case it's not an excuse to have no proper command-line tooling. In fact
>>> if you cannot get simpler, more atomic command-line tooling right then you'll
>>> probably doubly suck at doing a GUI as well.
>>>        
>> It's about who owns the user interface.
>>
>> If qemu owns the user interface, than we can satisfy this in a very simple
>> way by adding a perf monitor command.  If we have to support third party
>> tools, then it significantly complicates things.
>>      
> Of course illogical modularization complicates things 'significantly'.
>    

Ok.  Then apply this to the kernel.  I'm then happy to take patches.

Regards,

Anthony Liguori


--------------070604040701010707050704
Content-Type: text/plain;
 name="qemu-linux.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="qemu-linux.patch"

commit 84b84db054e83e7686b80fad9f8d2aa87aade1a1
Author: Anthony Liguori <aliguori@us.ibm.com>
Date:   Thu Mar 18 09:35:29 2010 -0500

    Bring QEMU into the Linux kernel tree
    
    Ingo is under the impression that this will result in a massive improvement in
    the usability of QEMU.
    
    Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

diff --git a/.gitmodules b/.gitmodules
new file mode 100644
index 0000000..76cdb68
--- /dev/null
+++ b/.gitmodules
@@ -0,0 +1,3 @@
+[submodule "tools/qemu"]
+	path = tools/qemu
+	url = git://git.qemu.org/qemu.git
diff --git a/MAINTAINERS b/MAINTAINERS
index 03f38c1..6275796 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4427,6 +4427,12 @@ M:	Robert Jarzmik <robert.jarzmik@free.fr>
 L:	rtc-linux@googlegroups.com
 S:	Maintained
 
+QEMU
+M:      Anthony Liguori <aliguori@us.ibm.com>
+L:      qemu-devel@nongnu.org
+S:      Maintained
+F:      tools/qemu
+
 QLOGIC QLA2XXX FC-SCSI DRIVER
 M:	Andrew Vasquez <andrew.vasquez@qlogic.com>
 M:	linux-driver@qlogic.com
diff --git a/tools/qemu b/tools/qemu
new file mode 160000
index 0000000..e5322f7
--- /dev/null
+++ b/tools/qemu
@@ -0,0 +1 @@
+Subproject commit e5322f76a72352eea8eb511390c27726b64e5a87

--------------070604040701010707050704--
