Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab1BISik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 13:38:40 -0500
Received: from imp01.mtu.ru ([62.5.255.10]:59802 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab1BISij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 13:38:39 -0500
X-Greylist: delayed 12161 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Feb 2011 13:38:38 EST
Message-ID: <4D52DE96.80408@pavlinux.ru>
Date: Wed, 09 Feb 2011 21:36:06 +0300
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ru; rv:1.9.2.13) Gecko/20101206 Microsoft/666 Notepad
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: Not PCI_PROBE_MMCONF by default
References: <4D52AF15.5070705@pavlinux.ru> <AANLkTindvfxRfgRbLprzX5b2u-4P-XZmycV=ai9ez6H1@mail.gmail.com>
In-Reply-To: <AANLkTindvfxRfgRbLprzX5b2u-4P-XZmycV=ai9ez6H1@mail.gmail.com>
X-Enigmail-Version: 1.1.2
OpenPGP: id=03742489
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

09.02.2011 19:43, Yinghai Lu пишет:
> On Wed, Feb 9, 2011 at 7:13 AM, Pavel Vasilyev <pavel@pavlinux.ru> wrote:
>> Hi All!
>>
>> Do not set PCI_PROBE_MMCONF flag by default, and enable
>> only if configured with  CONFIG_PCI_MMCONFIG
>>
>> Signed-off-by: Pavel Vasilyev <pavel@pavlinux.ru>
>> ---
>>  arch/x86/pci/common.c |    6 ++++--
>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
>> index 5fe7502..625b477 100644
>> --- a/arch/x86/pci/common.c
>> +++ b/arch/x86/pci/common.c
>> @@ -17,8 +17,7 @@
>>  #include <asm/smp.h>
>>  #include <asm/pci_x86.h>
>>
>> -unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
>> -                               PCI_PROBE_MMCONF;
>> +unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2;
>>
>>  unsigned int pci_early_dump_regs;
>>  static int pci_bf_sort;
>> @@ -535,6 +534,9 @@ char * __devinit  pcibios_setup(char *str)
>>        }
>>  #endif
>>  #ifdef CONFIG_PCI_MMCONFIG
>> +
>> +       pci_probe |= PCI_PROBE_MMCONF;
>> +
>>        else if (!strcmp(str, "nommconf")) {
>>                pci_probe &= ~PCI_PROBE_MMCONF;
>>                return NULL;
>>
> 
> did you try to do the compile test with CONFIG_PCI_MMCONFIG?

Oops :)

Signed-off-by: Pavel Vasilyev <pavel@pavlinux.ru>
---
 arch/x86/pci/common.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 5fe7502..48af4ce 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -17,8 +17,7 @@
 #include <asm/smp.h>
 #include <asm/pci_x86.h>

-unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
-                               PCI_PROBE_MMCONF;
+unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2;

 unsigned int pci_early_dump_regs;
 static int pci_bf_sort;
@@ -535,6 +534,9 @@ char * __devinit  pcibios_setup(char *str)
        }
 #endif
 #ifdef CONFIG_PCI_MMCONFIG
+
+       else if (pci_probe |= PCI_PROBE_MMCONF);
+
        else if (!strcmp(str, "nommconf")) {
                pci_probe &= ~PCI_PROBE_MMCONF;
                return NULL;

-- 

                                                         Pavel.
