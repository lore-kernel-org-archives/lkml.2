Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0G2Id6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:33:58 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48886 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab0G2Id4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=wuv9XYPN2hMrRzatlVANhVftYLEtkYXoWdHKNGdjTPMSYJeaIXkjWtlfHCkH9v8lBi
         TlpDfPi+GdJSauDc7RMk7Cqaq9vVVQB/lcM8iy963sfv50I77nU0Y7jKa9yKKTNeCqzv
         JMXADT5PxIxx0MN3BcApn9UaIoshT+JY0F51s=
MIME-Version: 1.0
Date: Thu, 29 Jul 2010 16:33:54 +0800
Message-ID: <AANLkTingz+eHho5A180HCWHJHgpy__6cv2WSHaaVdWdN@mail.gmail.com>
Subject: reasonable to compile out trace_irqflags completely ?
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Anyone knows if there is value to have a patch to compile out
TRACE_IRQFLAGS_SUPPORT?
if there is one already, please share it with me, since I'm wondering
if it could be casuing
some performance problem I've.

Thanks,
Luming

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CC      arch/x86/kernel/asm-offsets.s
In file included from /root/linux-2.6.32/arch/x86/include/asm/system.h:304,
                 from /root/linux-2.6.32/arch/x86/include/asm/processor.h:17,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:6,
                 from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
/root/linux-2.6.32/arch/x86/include/asm/paravirt.h:846: error:
expected identifier or â(â before âdoâ
/root/linux-2.6.32/arch/x86/include/asm/paravirt.h:846: error:
expected identifier or â(â before âwhileâ
In file included from /root/linux-2.6.32/arch/x86/include/asm/system.h:304,
                 from /root/linux-2.6.32/arch/x86/include/asm/processor.h:17,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:6,
                 from include/linux/module.h:9,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
/root/linux-2.6.32/arch/x86/include/asm/paravirt.h:851:46: error:
macro "raw_local_irq_disable" passed 1 arguments, but takes just 0
/root/linux-2.6.32/arch/x86/include/asm/paravirt.h:852: error:
expected â=â, â,â, â;â, âasmâ or â__attribute__â before â{â token
/root/linux-2.6.32/arch/x86/include/asm/paravirt.h:856:45: error:
macro "raw_local_irq_enable" passed 1 arguments, but takes just 0
/root/linux-2.6.32/arch/x86/include/asm/paravirt.h:857: error:
expected â=â, â,â, â;â, âasmâ or â__attribute__â before â{â token
/root/linux-2.6.32/arch/x86/include/asm/paravirt.h: In function
â__raw_local_irq_saveâ:
/root/linux-2.6.32/arch/x86/include/asm/paravirt.h:866: error:
implicit declaration of function âlocal_irq_disableâ
In file included from include/linux/spinlock.h:344,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/spinlock_api_smp.h: In function â__spin_lock_irqsaveâ:
include/linux/spinlock_api_smp.h:245: error: implicit declaration of
function âlocal_irq_saveâ
include/linux/spinlock_api_smp.h: In function â__spin_unlock_irqrestoreâ:
include/linux/spinlock_api_smp.h:375: error: implicit declaration of
function âlocal_irq_restoreâ
include/linux/spinlock_api_smp.h: In function â__spin_unlock_irqâ:
include/linux/spinlock_api_smp.h:383: error: implicit declaration of
function âlocal_irq_enableâ
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2
[root@localhost linux-2.6.32]# grep -i trace_irqflag .config
# CONFIG_TRACE_IRQFLAGS_SUPPORT is not set
