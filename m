Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab0HPKmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 06:42:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54936 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0HPKmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 06:42:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=fN0/6z0iqGJF3TyEbBe/gMTP62iGjV3kFjMPAd44jFGpbnDSRilg8zNX8Yphgnzd0V
         A4zXYziUUgsKqx0aEXz5vGixnCjYt5bGInE1XDS4+SLe7mfM6ajnZMpANUYzv3obp6J7
         9tILvnn4b7wHgDTRJVCqwiBTNnG7+iF+ImoRE=
MIME-Version: 1.0
Date: Mon, 16 Aug 2010 18:42:36 +0800
Message-ID: <AANLkTi=8btvOdUaM+gD_Pgwjb-EKwtA_mgoJszx8wF0m@mail.gmail.com>
Subject: Help: compile the Linux kernel (KVM kernel )on Ubuntu 10.04 err
From: zhou peng <ailvpeng25@gmail.com>
To: kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While compiling the kvm linux kernel on my ubuntu 10.04(Linux
xxxx-laptop 2.6.32-24-generic #39-Ubuntu SMP Wed Jul 28 06:07:29 UTC
2010 i686 GNU/Linux), the  err below appear, How to figure out please?

=err msg=
In file included from drivers/platform/x86/intel_
scu_ipc.c:26:
kvm/arch/x86/include/asm/mrst.h:14: warning: ‘struct sfi_table_header’
declared inside parameter list
kvm/arch/x86/include/asm/mrst.h:14: warning: its scope is only this
definition or declaration, which is probably not what you want
drivers/platform/x86/intel_scu_ipc.c: In function ‘pwr_reg_rdwr’:
drivers/platform/x86/intel_scu_ipc.c:175: error:
‘MRST_CPU_CHIP_PENWELL’ undeclared (first use in this function)
drivers/platform/x86/intel_scu_ipc.c:175: error: (Each undeclared
identifier is reported only once
drivers/platform/x86/intel_scu_ipc.c:175: error: for each function it
appears in.)
drivers/platform/x86/intel_scu_ipc.c: In function ‘intel_scu_ipc_init’:
drivers/platform/x86/intel_scu_ipc.c:741: error: implicit declaration
of function ‘mrst_identify_cpu’
make[3]: *** [drivers/platform/x86/intel_scu_ipc.o] Error 1
make[2]: *** [drivers/platform/x86] Error 2
make[1]: *** [drivers/platform] Error 2
make: *** [drivers] Error 2

=KVM kernel info=
kvm$ git log
commit 5c739e07acf53aa3212ea28db34397eb936d46b2
Author: Wei Yongjun <yjwei@cn.fujitsu.com>
Date:   Tue Aug 10 13:48:22 2010 +0800

    KVM: x86 emulator: add bsf/bsr instruction emulation

    Add bsf/bsr instruction emulation (opcode 0x0f 0xbc~0xbd)

    Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
    Signed-off-by: Avi Kivity <avi@redhat.com>

commit 4480639d9a17b4f13d932b1579bb4ad81b70659b
Author: Mohammed Gamal <m.gamal005@gmail.com>
Date:   Sun Aug 8 21:11:38 2010 +0300

    KVM: x86 emulator: Fix emulate_grp3 return values

    This patch lets emulate_grp3() return X86EMUL_* return codes instead
    of hardcoded ones.

    Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
    Signed-off-by: Avi Kivity <avi@redhat.com>
...

=search the kvm kernel tree=
kvm$ grep MRST_CPU_CHIP_PENWELL . -R
./drivers/platform/x86/intel_scu_ipc.c:    if (platform !=
MRST_CPU_CHIP_PENWELL) {
./drivers/platform/x86/intel_scu_ipc.c:        if (platform !=
MRST_CPU_CHIP_PENWELL) {

--
zhoupeng
