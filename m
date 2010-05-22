Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0EVIka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:40:30 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:43973 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752994Ab0EVIkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:40:20 -0400
Message-ID: <4BF7986C.4030505@example.com>
Date: Sat, 22 May 2010 10:40:12 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: Randy Dunlap <rdunlap@xenotime.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: What's up with wireless drivers?
References: <4BF6F2E4.5030800@example.com>	<20100521210729.GC2495@tuxdriver.com>	<4BF6F959.5040401@example.com>	<4BF6FBB0.6060407@example.com> <20100521151203.f94c1d3e.rdunlap@xenotime.net> <4BF7073A.4090506@example.com>
In-Reply-To: <4BF7073A.4090506@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10983716542254903666
X-Ovh-Remote: 83.24.109.69 (dob69.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2010 00:20, Piotr Hosowicz wrote:
> On 22.05.2010 00:12, Randy Dunlap wrote:
>> On Fri, 21 May 2010 23:31:28 +0200 Piotr Hosowicz wrote:
>>
>>> On 21.05.2010 23:21, Piotr Hosowicz wrote:
>>>> On 21.05.2010 23:07, John W. Linville wrote:
>>>>> On Fri, May 21, 2010 at 10:53:56PM +0200, Piotr Hosowicz wrote:
>>>>>> Hello,
>>>>>>
>>>>>> I try to build kernel from git source. Now n-th build try is
>>>>>> performing, each time it failed on wireless drivers - Atheros,
>>>>>> Marvel etc. Did I miss something?
>>>>>>
>>>>>> Regards,
>>>>>>
>>>>>> Piotr Hosowicz
>>>>>
>>>>> Perhaps you should post your actual output from the build failure?
>>>>
>>>> I dont have it right now, I disabled wireless at all and started build.
>>>> The output to the console was make-kpkg ordinary message - saying that
>>>> sub build finished with error code 2 AFAIR, it stopped each time on
>>>> wireless drivers.
>>>
>>> Zonk! It seems that the problem is not only with wireless, now it broke
>>> here:
>>>
>>> (snip)
>>> CC [M] drivers/net/usb/int51x1.o
>>> CC [M] drivers/net/usb/cdc-phonet.o
>>> CC [M] drivers/net/wan/lmc/lmc_media.o
>>> CC [M] drivers/net/wan/lmc/lmc_main.o
>>> CC [M] drivers/net/wan/wanxl.o
>>> CC [M] drivers/net/usb/ipheth.o
>>> LD [M] drivers/net/wan/cyclomx.o
>>> CC [M] drivers/net/usb/sierra_net.o
>>> CC [M] drivers/net/wan/lmc/lmc_proto.o
>>> LD [M] drivers/net/wan/lmc/lmc.o
>>> make[1]: Opuszczenie katalogu `/usr/src/linus/linux-2.6-20100521-2044'
>>> make: *** [debian/stamp/build/kernel] B³±d 2
>>>
>>> Opuszczenie katalogu `/usr/src/linus/linux-2.6-20100521-2044' is
>>> "leaving directory", B³±d is error.
>>
>> That still doesn't show the actual error/problem message...
>
> Because there was no other messages, maybe Debian make-kpkg mutes them
> some way. I can try tommorrow the classic linux way and test it. I
> attach botching config.

I git-pulled and have run build with make-kpkg --verbose, again failed. 
This is the tail of the output:

gcc -Wp,-MD,drivers/net/wireless/hostap/.hostap_proc.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(hostap_proc)" 
-D"KBUILD_MODNAME=KBUILD_STR(hostap)" -D"DEBUG_HASH=36" 
-D"DEBUG_HASH2=31" -c -o drivers/net/wireless/hostap/.tmp_hostap_proc.o 
drivers/net/wireless/hostap/hostap_proc.c
   gcc -Wp,-MD,drivers/net/wireless/iwmc3200wifi/.commands.o.d 
-nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(commands)" 
-D"KBUILD_MODNAME=KBUILD_STR(iwmc3200wifi)" -D"DEBUG_HASH=14" 
-D"DEBUG_HASH2=1" -c -o 
drivers/net/wireless/iwmc3200wifi/.tmp_commands.o 
drivers/net/wireless/iwmc3200wifi/commands.c
(cat /dev/null;   echo kernel/drivers/net/wan/hdlc.ko;   echo 
kernel/drivers/net/wan/hdlc_raw.ko;   echo 
kernel/drivers/net/wan/hdlc_raw_eth.ko;   echo 
kernel/drivers/net/wan/hdlc_cisco.ko;   echo 
kernel/drivers/net/wan/hdlc_fr.ko;   echo 
kernel/drivers/net/wan/hdlc_ppp.ko;   echo 
kernel/drivers/net/wan/hdlc_x25.ko;   echo 
kernel/drivers/net/wan/farsync.ko;   echo 
kernel/drivers/net/wan/dscc4.ko;   echo 
kernel/drivers/net/wan/x25_asy.ko;   cat 
drivers/net/wan/lmc/modules.order;   echo 
kernel/drivers/net/wan/dlci.ko;   echo 
kernel/drivers/net/wan/cycx_drv.ko;   echo 
kernel/drivers/net/wan/cyclomx.ko;   echo 
kernel/drivers/net/wan/lapbether.ko;   echo 
kernel/drivers/net/wan/sbni.ko;   echo kernel/drivers/net/wan/wanxl.ko; 
   echo kernel/drivers/net/wan/pci200syn.ko;) > 
drivers/net/wan/modules.order
   gcc -Wp,-MD,drivers/net/wireless/b43/.sysfs.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(sysfs)" 
-D"KBUILD_MODNAME=KBUILD_STR(b43)" -D"DEBUG_HASH=56" -D"DEBUG_HASH2=41" 
-c -o drivers/net/wireless/b43/.tmp_sysfs.o drivers/net/wireless/b43/sysfs.c
   gcc -Wp,-MD,drivers/net/wireless/libertas_tf/.if_usb.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(if_usb)" 
-D"KBUILD_MODNAME=KBUILD_STR(libertas_tf_usb)" -D"DEBUG_HASH=45" 
-D"DEBUG_HASH2=32" -c -o drivers/net/wireless/libertas_tf/.tmp_if_usb.o 
drivers/net/wireless/libertas_tf/if_usb.c
   gcc -Wp,-MD,drivers/net/wireless/hostap/.hostap_cs.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(hostap_cs)" 
-D"KBUILD_MODNAME=KBUILD_STR(hostap_cs)" -D"DEBUG_HASH=57" 
-D"DEBUG_HASH2=31" -c -o drivers/net/wireless/hostap/.tmp_hostap_cs.o 
drivers/net/wireless/hostap/hostap_cs.c
   gcc -Wp,-MD,drivers/net/wireless/ipw2x00/.libipw_module.o.d 
-nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(libipw_module)" 
-D"KBUILD_MODNAME=KBUILD_STR(libipw)" -D"DEBUG_HASH=39" 
-D"DEBUG_HASH2=49" -c -o 
drivers/net/wireless/ipw2x00/.tmp_libipw_module.o 
drivers/net/wireless/ipw2x00/libipw_module.c
   gcc -Wp,-MD,drivers/net/wireless/hostap/.hostap_plx.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(hostap_plx)" 
-D"KBUILD_MODNAME=KBUILD_STR(hostap_plx)" -D"DEBUG_HASH=55" 
-D"DEBUG_HASH2=28" -c -o drivers/net/wireless/hostap/.tmp_hostap_plx.o 
drivers/net/wireless/hostap/hostap_plx.c
   ld -m elf_x86_64   -r -o drivers/scsi/qla2xxx/qla2xxx.o 
drivers/scsi/qla2xxx/qla_os.o drivers/scsi/qla2xxx/qla_init.o 
drivers/scsi/qla2xxx/qla_mbx.o drivers/scsi/qla2xxx/qla_iocb.o 
drivers/scsi/qla2xxx/qla_isr.o drivers/scsi/qla2xxx/qla_gs.o 
drivers/scsi/qla2xxx/qla_dbg.o drivers/scsi/qla2xxx/qla_sup.o 
drivers/scsi/qla2xxx/qla_attr.o drivers/scsi/qla2xxx/qla_mid.o 
drivers/scsi/qla2xxx/qla_dfs.o drivers/scsi/qla2xxx/qla_bsg.o 
drivers/scsi/qla2xxx/qla_nx.o
(cat /dev/null;   cat drivers/scsi/megaraid/modules.order;   cat 
drivers/scsi/pcmcia/modules.order;   echo 
kernel/drivers/scsi/scsi_mod.ko;   echo kernel/drivers/scsi/scsi_tgt.ko; 
   echo kernel/drivers/scsi/raid_class.ko;   echo 
kernel/drivers/scsi/scsi_transport_spi.ko;   echo 
kernel/drivers/scsi/scsi_transport_fc.ko;   echo 
kernel/drivers/scsi/scsi_transport_iscsi.ko;   echo 
kernel/drivers/scsi/scsi_transport_sas.ko;   cat 
drivers/scsi/libsas/modules.order;   echo 
kernel/drivers/scsi/scsi_transport_srp.ko;   cat 
drivers/scsi/device_handler/modules.order;   cat 
drivers/scsi/libfc/modules.order;   cat drivers/scsi/fcoe/modules.order; 
   cat drivers/scsi/fnic/modules.order;   echo 
kernel/drivers/scsi/libiscsi.ko;   echo 
kernel/drivers/scsi/libiscsi_tcp.ko;   echo 
kernel/drivers/scsi/iscsi_tcp.ko;   echo 
kernel/drivers/scsi/libiscsi.ko;   echo kernel/drivers/scsi/advansys.ko; 
   echo kernel/drivers/scsi/BusLogic.ko;   echo 
kernel/drivers/scsi/dpt_i2o.ko;   cat drivers/scsi/arcmsr/modules.order; 
   cat drivers/scsi/aic7xxx/modules.order;   cat 
drivers/scsi/aic7xxx/modules.order;   cat 
drivers/scsi/aacraid/modules.order;   echo 
kernel/drivers/scsi/aic7xxx_old.ko;   cat 
drivers/scsi/aic94xx/modules.order;   cat 
drivers/scsi/pm8001/modules.order;   echo kernel/drivers/scsi/ips.ko; 
echo kernel/drivers/scsi/fdomain.ko;   echo 
kernel/drivers/scsi/qlogicfas408.ko;   echo 
kernel/drivers/scsi/qla1280.ko;   cat 
drivers/scsi/qla2xxx/modules.order;   cat 
drivers/scsi/qla4xxx/modules.order;   cat 
drivers/scsi/lpfc/modules.order;   cat drivers/scsi/bfa/modules.order; 
  echo kernel/drivers/scsi/dmx3191d.ko;   echo 
kernel/drivers/scsi/hpsa.ko;   cat 
drivers/scsi/sym53c8xx_2/modules.order;   echo 
kernel/drivers/scsi/eata.ko;   echo kernel/drivers/scsi/dc395x.ko; 
echo kernel/drivers/scsi/tmscsim.ko;   echo 
kernel/drivers/scsi/megaraid.ko;   cat 
drivers/scsi/mpt2sas/modules.order;   echo 
kernel/drivers/scsi/atp870u.ko;   echo kernel/drivers/scsi/gdth.ko; 
echo kernel/drivers/scsi/initio.ko;   echo 
kernel/drivers/scsi/a100u2w.ko;   echo kernel/drivers/scsi/3w-xxxx.ko; 
  echo kernel/drivers/scsi/3w-9xxx.ko;   echo 
kernel/drivers/scsi/3w-sas.ko;   echo kernel/drivers/scsi/ppa.ko;   echo 
kernel/drivers/scsi/imm.ko;   echo kernel/drivers/scsi/ipr.ko;   echo 
kernel/drivers/scsi/libsrp.ko;   echo kernel/drivers/scsi/hptiop.ko; 
echo kernel/drivers/scsi/stex.ko;   cat 
drivers/scsi/mvsas/modules.order;   echo 
kernel/drivers/scsi/libiscsi.ko;   cat drivers/scsi/bnx2i/modules.order; 
   echo kernel/drivers/scsi/libiscsi.ko;   cat 
drivers/scsi/be2iscsi/modules.order;   echo 
kernel/drivers/scsi/pmcraid.ko;   echo 
kernel/drivers/scsi/vmw_pvscsi.ko;   echo kernel/drivers/scsi/st.ko; 
echo kernel/drivers/scsi/osst.ko;   echo kernel/drivers/scsi/sd_mod.ko; 
   echo kernel/drivers/scsi/sr_mod.ko;   echo kernel/drivers/scsi/sg.ko; 
   echo kernel/drivers/scsi/ch.ko;   echo kernel/drivers/scsi/ses.ko; 
cat drivers/scsi/osd/modules.order;   echo 
kernel/drivers/scsi/scsi_debug.ko;   echo 
kernel/drivers/scsi/scsi_wait_scan.ko;) > drivers/scsi/modules.order
   gcc -Wp,-MD,drivers/net/wireless/b43legacy/.leds.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(leds)" 
-D"KBUILD_MODNAME=KBUILD_STR(b43legacy)" -D"DEBUG_HASH=2" 
-D"DEBUG_HASH2=13" -c -o drivers/net/wireless/b43legacy/.tmp_leds.o 
drivers/net/wireless/b43legacy/leds.c
   gcc -Wp,-MD,drivers/net/wireless/b43/.xmit.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(xmit)"  -D"KBUILD_MODNAME=KBUILD_STR(b43)" 
-D"DEBUG_HASH=56" -D"DEBUG_HASH2=41" -c -o 
drivers/net/wireless/b43/.tmp_xmit.o drivers/net/wireless/b43/xmit.c
   gcc -Wp,-MD,drivers/net/wireless/libertas/.rx.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(rx)" 
-D"KBUILD_MODNAME=KBUILD_STR(libertas)" -D"DEBUG_HASH=50" 
-D"DEBUG_HASH2=39" -c -o drivers/net/wireless/libertas/.tmp_rx.o 
drivers/net/wireless/libertas/rx.c
(cat /dev/null;   echo 
kernel/drivers/net/wireless/libertas_tf/libertas_tf.ko;   echo 
kernel/drivers/net/wireless/libertas_tf/libertas_tf_usb.ko;) > 
drivers/net/wireless/libertas_tf/modules.order
   gcc -Wp,-MD,drivers/net/wireless/b43/.lo.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(lo)"  -D"KBUILD_MODNAME=KBUILD_STR(b43)" 
-D"DEBUG_HASH=56" -D"DEBUG_HASH2=41" -c -o 
drivers/net/wireless/b43/.tmp_lo.o drivers/net/wireless/b43/lo.c
   ld -m elf_x86_64   -r -o 
drivers/net/wireless/libertas_tf/libertas_tf.o 
drivers/net/wireless/libertas_tf/main.o 
drivers/net/wireless/libertas_tf/cmd.o
   ld -m elf_x86_64   -r -o 
drivers/net/wireless/libertas_tf/libertas_tf_usb.o 
drivers/net/wireless/libertas_tf/if_usb.o
   gcc -Wp,-MD,drivers/net/wireless/iwmc3200wifi/.cfg80211.o.d 
-nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(cfg80211)" 
-D"KBUILD_MODNAME=KBUILD_STR(iwmc3200wifi)" -D"DEBUG_HASH=14" 
-D"DEBUG_HASH2=1" -c -o 
drivers/net/wireless/iwmc3200wifi/.tmp_cfg80211.o 
drivers/net/wireless/iwmc3200wifi/cfg80211.c
/usr/bin/make -f scripts/Makefile.build obj=drivers/net/wireless/orinoco
   gcc -Wp,-MD,drivers/net/wireless/b43legacy/.debugfs.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(debugfs)" 
-D"KBUILD_MODNAME=KBUILD_STR(b43legacy)" -D"DEBUG_HASH=2" 
-D"DEBUG_HASH2=13" -c -o drivers/net/wireless/b43legacy/.tmp_debugfs.o 
drivers/net/wireless/b43legacy/debugfs.c
/usr/bin/make -f scripts/Makefile.build obj=drivers/net/wireless/p54
   gcc -Wp,-MD,drivers/net/wireless/ipw2x00/.libipw_tx.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(libipw_tx)" 
-D"KBUILD_MODNAME=KBUILD_STR(libipw)" -D"DEBUG_HASH=39" 
-D"DEBUG_HASH2=49" -c -o drivers/net/wireless/ipw2x00/.tmp_libipw_tx.o 
drivers/net/wireless/ipw2x00/libipw_tx.c
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.main.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(main)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco)" -D"DEBUG_HASH=24" 
-D"DEBUG_HASH2=61" -c -o drivers/net/wireless/orinoco/.tmp_main.o 
drivers/net/wireless/orinoco/main.c
   gcc -Wp,-MD,drivers/net/wireless/p54/.eeprom.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(eeprom)" 
-D"KBUILD_MODNAME=KBUILD_STR(p54common)" -D"DEBUG_HASH=1" 
-D"DEBUG_HASH2=37" -c -o drivers/net/wireless/p54/.tmp_eeprom.o 
drivers/net/wireless/p54/eeprom.c
   gcc -Wp,-MD,drivers/net/wireless/ipw2x00/.libipw_rx.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(libipw_rx)" 
-D"KBUILD_MODNAME=KBUILD_STR(libipw)" -D"DEBUG_HASH=39" 
-D"DEBUG_HASH2=49" -c -o drivers/net/wireless/ipw2x00/.tmp_libipw_rx.o 
drivers/net/wireless/ipw2x00/libipw_rx.c
   gcc -Wp,-MD,drivers/net/wireless/libertas/.scan.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(scan)" 
-D"KBUILD_MODNAME=KBUILD_STR(libertas)" -D"DEBUG_HASH=50" 
-D"DEBUG_HASH2=39" -c -o drivers/net/wireless/libertas/.tmp_scan.o 
drivers/net/wireless/libertas/scan.c
   gcc -Wp,-MD,drivers/net/wireless/iwmc3200wifi/.eeprom.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(eeprom)" 
-D"KBUILD_MODNAME=KBUILD_STR(iwmc3200wifi)" -D"DEBUG_HASH=14" 
-D"DEBUG_HASH2=1" -c -o drivers/net/wireless/iwmc3200wifi/.tmp_eeprom.o 
drivers/net/wireless/iwmc3200wifi/eeprom.c
   gcc -Wp,-MD,drivers/net/wireless/b43legacy/.dma.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(dma)" 
-D"KBUILD_MODNAME=KBUILD_STR(b43legacy)" -D"DEBUG_HASH=2" 
-D"DEBUG_HASH2=13" -c -o drivers/net/wireless/b43legacy/.tmp_dma.o 
drivers/net/wireless/b43legacy/dma.c
   gcc -Wp,-MD,drivers/net/wireless/b43/.wa.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(wa)"  -D"KBUILD_MODNAME=KBUILD_STR(b43)" 
-D"DEBUG_HASH=56" -D"DEBUG_HASH2=41" -c -o 
drivers/net/wireless/b43/.tmp_wa.o drivers/net/wireless/b43/wa.c
   gcc -Wp,-MD,drivers/net/wireless/libertas/.tx.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(tx)" 
-D"KBUILD_MODNAME=KBUILD_STR(libertas)" -D"DEBUG_HASH=50" 
-D"DEBUG_HASH2=39" -c -o drivers/net/wireless/libertas/.tmp_tx.o 
drivers/net/wireless/libertas/tx.c
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.fw.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(fw)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco)" -D"DEBUG_HASH=24" 
-D"DEBUG_HASH2=61" -c -o drivers/net/wireless/orinoco/.tmp_fw.o 
drivers/net/wireless/orinoco/fw.c
   gcc -Wp,-MD,drivers/net/wireless/hostap/.hostap_pci.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(hostap_pci)" 
-D"KBUILD_MODNAME=KBUILD_STR(hostap_pci)" -D"DEBUG_HASH=63" 
-D"DEBUG_HASH2=49" -c -o drivers/net/wireless/hostap/.tmp_hostap_pci.o 
drivers/net/wireless/hostap/hostap_pci.c
   gcc -Wp,-MD,drivers/net/wireless/p54/.fwio.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(fwio)" 
-D"KBUILD_MODNAME=KBUILD_STR(p54common)" -D"DEBUG_HASH=1" 
-D"DEBUG_HASH2=37" -c -o drivers/net/wireless/p54/.tmp_fwio.o 
drivers/net/wireless/p54/fwio.c
   gcc -Wp,-MD,drivers/net/wireless/iwmc3200wifi/.debugfs.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(debugfs)" 
-D"KBUILD_MODNAME=KBUILD_STR(iwmc3200wifi)" -D"DEBUG_HASH=14" 
-D"DEBUG_HASH2=1" -c -o drivers/net/wireless/iwmc3200wifi/.tmp_debugfs.o 
drivers/net/wireless/iwmc3200wifi/debugfs.c
   gcc -Wp,-MD,drivers/net/wireless/b43/.dma.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(dma)"  -D"KBUILD_MODNAME=KBUILD_STR(b43)" 
-D"DEBUG_HASH=56" -D"DEBUG_HASH2=41" -c -o 
drivers/net/wireless/b43/.tmp_dma.o drivers/net/wireless/b43/dma.c
   gcc -Wp,-MD,drivers/net/wireless/ipw2x00/.libipw_wx.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(libipw_wx)" 
-D"KBUILD_MODNAME=KBUILD_STR(libipw)" -D"DEBUG_HASH=39" 
-D"DEBUG_HASH2=49" -c -o drivers/net/wireless/ipw2x00/.tmp_libipw_wx.o 
drivers/net/wireless/ipw2x00/libipw_wx.c
   gcc -Wp,-MD,drivers/net/wireless/b43/.pio.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(pio)"  -D"KBUILD_MODNAME=KBUILD_STR(b43)" 
-D"DEBUG_HASH=56" -D"DEBUG_HASH2=41" -c -o 
drivers/net/wireless/b43/.tmp_pio.o drivers/net/wireless/b43/pio.c
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.hw.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(hw)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco)" -D"DEBUG_HASH=24" 
-D"DEBUG_HASH2=61" -c -o drivers/net/wireless/orinoco/.tmp_hw.o 
drivers/net/wireless/orinoco/hw.c
   gcc -Wp,-MD,drivers/net/wireless/libertas/.wext.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(wext)" 
-D"KBUILD_MODNAME=KBUILD_STR(libertas)" -D"DEBUG_HASH=50" 
-D"DEBUG_HASH2=39" -c -o drivers/net/wireless/libertas/.tmp_wext.o 
drivers/net/wireless/libertas/wext.c
   gcc -Wp,-MD,drivers/net/wireless/ipw2x00/.libipw_geo.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(libipw_geo)" 
-D"KBUILD_MODNAME=KBUILD_STR(libipw)" -D"DEBUG_HASH=39" 
-D"DEBUG_HASH2=49" -c -o drivers/net/wireless/ipw2x00/.tmp_libipw_geo.o 
drivers/net/wireless/ipw2x00/libipw_geo.c
   gcc -Wp,-MD,drivers/net/wireless/b43legacy/.pio.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(pio)" 
-D"KBUILD_MODNAME=KBUILD_STR(b43legacy)" -D"DEBUG_HASH=2" 
-D"DEBUG_HASH2=13" -c -o drivers/net/wireless/b43legacy/.tmp_pio.o 
drivers/net/wireless/b43legacy/pio.c
   gcc -Wp,-MD,drivers/net/wireless/p54/.txrx.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(txrx)" 
-D"KBUILD_MODNAME=KBUILD_STR(p54common)" -D"DEBUG_HASH=1" 
-D"DEBUG_HASH2=37" -c -o drivers/net/wireless/p54/.tmp_txrx.o 
drivers/net/wireless/p54/txrx.c
(cat /dev/null;   echo 
kernel/drivers/net/wireless/iwmc3200wifi/iwmc3200wifi.ko;) > 
drivers/net/wireless/iwmc3200wifi/modules.order
   ld -m elf_x86_64   -r -o 
drivers/net/wireless/iwmc3200wifi/iwmc3200wifi.o 
drivers/net/wireless/iwmc3200wifi/main.o 
drivers/net/wireless/iwmc3200wifi/netdev.o 
drivers/net/wireless/iwmc3200wifi/rx.o 
drivers/net/wireless/iwmc3200wifi/tx.o 
drivers/net/wireless/iwmc3200wifi/sdio.o 
drivers/net/wireless/iwmc3200wifi/hal.o 
drivers/net/wireless/iwmc3200wifi/fw.o 
drivers/net/wireless/iwmc3200wifi/commands.o 
drivers/net/wireless/iwmc3200wifi/cfg80211.o 
drivers/net/wireless/iwmc3200wifi/eeprom.o 
drivers/net/wireless/iwmc3200wifi/debugfs.o
   gcc -Wp,-MD,drivers/net/wireless/p54/.main.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(main)" 
-D"KBUILD_MODNAME=KBUILD_STR(p54common)" -D"DEBUG_HASH=1" 
-D"DEBUG_HASH2=37" -c -o drivers/net/wireless/p54/.tmp_main.o 
drivers/net/wireless/p54/main.c
   gcc -Wp,-MD,drivers/net/wireless/p54/.led.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(led)" 
-D"KBUILD_MODNAME=KBUILD_STR(p54common)" -D"DEBUG_HASH=1" 
-D"DEBUG_HASH2=37" -c -o drivers/net/wireless/p54/.tmp_led.o 
drivers/net/wireless/p54/led.c
   gcc -Wp,-MD,drivers/net/wireless/libertas/.mesh.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(mesh)" 
-D"KBUILD_MODNAME=KBUILD_STR(libertas)" -D"DEBUG_HASH=50" 
-D"DEBUG_HASH2=39" -c -o drivers/net/wireless/libertas/.tmp_mesh.o 
drivers/net/wireless/libertas/mesh.c
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.mic.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(mic)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco)" -D"DEBUG_HASH=24" 
-D"DEBUG_HASH2=61" -c -o drivers/net/wireless/orinoco/.tmp_mic.o 
drivers/net/wireless/orinoco/mic.c
   gcc -Wp,-MD,drivers/net/wireless/b43/.rfkill.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(rfkill)" 
-D"KBUILD_MODNAME=KBUILD_STR(b43)" -D"DEBUG_HASH=56" -D"DEBUG_HASH2=41" 
-c -o drivers/net/wireless/b43/.tmp_rfkill.o 
drivers/net/wireless/b43/rfkill.c
(cat /dev/null;   echo kernel/drivers/net/wireless/hostap/hostap.ko; 
echo kernel/drivers/net/wireless/hostap/hostap_cs.ko;   echo 
kernel/drivers/net/wireless/hostap/hostap_plx.ko;   echo 
kernel/drivers/net/wireless/hostap/hostap_pci.ko;) > 
drivers/net/wireless/hostap/modules.order
   ld -m elf_x86_64   -r -o drivers/net/wireless/hostap/hostap.o 
drivers/net/wireless/hostap/hostap_80211_rx.o 
drivers/net/wireless/hostap/hostap_80211_tx.o 
drivers/net/wireless/hostap/hostap_ap.o 
drivers/net/wireless/hostap/hostap_info.o 
drivers/net/wireless/hostap/hostap_ioctl.o 
drivers/net/wireless/hostap/hostap_main.o 
drivers/net/wireless/hostap/hostap_proc.o
/usr/bin/make -f scripts/Makefile.build obj=drivers/net/wireless/prism54
(cat /dev/null;   echo kernel/drivers/net/wireless/ipw2x00/ipw2100.ko; 
  echo kernel/drivers/net/wireless/ipw2x00/ipw2200.ko;   echo 
kernel/drivers/net/wireless/ipw2x00/libipw.ko;) > 
drivers/net/wireless/ipw2x00/modules.order
   ld -m elf_x86_64   -r -o drivers/net/wireless/ipw2x00/libipw.o 
drivers/net/wireless/ipw2x00/libipw_module.o 
drivers/net/wireless/ipw2x00/libipw_tx.o 
drivers/net/wireless/ipw2x00/libipw_rx.o 
drivers/net/wireless/ipw2x00/libipw_wx.o 
drivers/net/wireless/ipw2x00/libipw_geo.o
   gcc -Wp,-MD,drivers/net/wireless/b43/.leds.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(leds)"  -D"KBUILD_MODNAME=KBUILD_STR(b43)" 
-D"DEBUG_HASH=56" -D"DEBUG_HASH2=41" -c -o 
drivers/net/wireless/b43/.tmp_leds.o drivers/net/wireless/b43/leds.c
(cat /dev/null;   echo 
kernel/drivers/net/wireless/b43legacy/b43legacy.ko;) > 
drivers/net/wireless/b43legacy/modules.order
   ld -m elf_x86_64   -r -o drivers/net/wireless/b43legacy/b43legacy.o 
drivers/net/wireless/b43legacy/main.o 
drivers/net/wireless/b43legacy/ilt.o 
drivers/net/wireless/b43legacy/phy.o 
drivers/net/wireless/b43legacy/radio.o 
drivers/net/wireless/b43legacy/sysfs.o 
drivers/net/wireless/b43legacy/xmit.o 
drivers/net/wireless/b43legacy/rfkill.o 
drivers/net/wireless/b43legacy/leds.o 
drivers/net/wireless/b43legacy/debugfs.o 
drivers/net/wireless/b43legacy/dma.o drivers/net/wireless/b43legacy/pio.o
   gcc -Wp,-MD,drivers/net/wireless/prism54/.islpci_eth.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(islpci_eth)" 
-D"KBUILD_MODNAME=KBUILD_STR(prism54)" -D"DEBUG_HASH=46" 
-D"DEBUG_HASH2=29" -c -o drivers/net/wireless/prism54/.tmp_islpci_eth.o 
drivers/net/wireless/prism54/islpci_eth.c
   gcc -Wp,-MD,drivers/net/wireless/libertas/.if_spi.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(if_spi)" 
-D"KBUILD_MODNAME=KBUILD_STR(libertas_spi)" -D"DEBUG_HASH=61" 
-D"DEBUG_HASH2=18" -c -o drivers/net/wireless/libertas/.tmp_if_spi.o 
drivers/net/wireless/libertas/if_spi.c
   gcc -Wp,-MD,drivers/net/wireless/p54/.p54usb.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(p54usb)" 
-D"KBUILD_MODNAME=KBUILD_STR(p54usb)" -D"DEBUG_HASH=2" 
-D"DEBUG_HASH2=53" -c -o drivers/net/wireless/p54/.tmp_p54usb.o 
drivers/net/wireless/p54/p54usb.c
   gcc -Wp,-MD,drivers/net/wireless/prism54/.islpci_mgt.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(islpci_mgt)" 
-D"KBUILD_MODNAME=KBUILD_STR(prism54)" -D"DEBUG_HASH=46" 
-D"DEBUG_HASH2=29" -c -o drivers/net/wireless/prism54/.tmp_islpci_mgt.o 
drivers/net/wireless/prism54/islpci_mgt.c
   gcc -Wp,-MD,drivers/net/wireless/b43/.pcmcia.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(pcmcia)" 
-D"KBUILD_MODNAME=KBUILD_STR(b43)" -D"DEBUG_HASH=56" -D"DEBUG_HASH2=41" 
-c -o drivers/net/wireless/b43/.tmp_pcmcia.o 
drivers/net/wireless/b43/pcmcia.c
   gcc -Wp,-MD,drivers/net/wireless/p54/.p54pci.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(p54pci)" 
-D"KBUILD_MODNAME=KBUILD_STR(p54pci)" -D"DEBUG_HASH=52" 
-D"DEBUG_HASH2=28" -c -o drivers/net/wireless/p54/.tmp_p54pci.o 
drivers/net/wireless/p54/p54pci.c
   gcc -Wp,-MD,drivers/net/wireless/b43/.sdio.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(sdio)"  -D"KBUILD_MODNAME=KBUILD_STR(b43)" 
-D"DEBUG_HASH=56" -D"DEBUG_HASH2=41" -c -o 
drivers/net/wireless/b43/.tmp_sdio.o drivers/net/wireless/b43/sdio.c
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.scan.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(scan)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco)" -D"DEBUG_HASH=24" 
-D"DEBUG_HASH2=61" -c -o drivers/net/wireless/orinoco/.tmp_scan.o 
drivers/net/wireless/orinoco/scan.c
   gcc -Wp,-MD,drivers/net/wireless/p54/.p54spi.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(p54spi)" 
-D"KBUILD_MODNAME=KBUILD_STR(p54spi)" -D"DEBUG_HASH=36" 
-D"DEBUG_HASH2=53" -c -o drivers/net/wireless/p54/.tmp_p54spi.o 
drivers/net/wireless/p54/p54spi.c
(cat /dev/null;   echo kernel/drivers/net/wireless/p54/p54common.ko; 
echo kernel/drivers/net/wireless/p54/p54usb.ko;   echo 
kernel/drivers/net/wireless/p54/p54pci.ko;   echo 
kernel/drivers/net/wireless/p54/p54spi.ko;) > 
drivers/net/wireless/p54/modules.order
(cat /dev/null;   echo kernel/drivers/net/wireless/libertas/libertas.ko; 
   echo kernel/drivers/net/wireless/libertas/libertas_spi.ko;) > 
drivers/net/wireless/libertas/modules.order
   gcc -Wp,-MD,drivers/net/wireless/prism54/.isl_38xx.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(isl_38xx)" 
-D"KBUILD_MODNAME=KBUILD_STR(prism54)" -D"DEBUG_HASH=46" 
-D"DEBUG_HASH2=29" -c -o drivers/net/wireless/prism54/.tmp_isl_38xx.o 
drivers/net/wireless/prism54/isl_38xx.c
   gcc -Wp,-MD,drivers/net/wireless/b43/.debugfs.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(debugfs)" 
-D"KBUILD_MODNAME=KBUILD_STR(b43)" -D"DEBUG_HASH=56" -D"DEBUG_HASH2=41" 
-c -o drivers/net/wireless/b43/.tmp_debugfs.o 
drivers/net/wireless/b43/debugfs.c
   ld -m elf_x86_64   -r -o drivers/net/wireless/p54/p54common.o 
drivers/net/wireless/p54/eeprom.o drivers/net/wireless/p54/fwio.o 
drivers/net/wireless/p54/txrx.o drivers/net/wireless/p54/main.o 
drivers/net/wireless/p54/led.o
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.wext.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(wext)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco)" -D"DEBUG_HASH=24" 
-D"DEBUG_HASH2=61" -c -o drivers/net/wireless/orinoco/.tmp_wext.o 
drivers/net/wireless/orinoco/wext.c
(cat /dev/null;   echo kernel/drivers/net/wireless/b43/b43.ko;) > 
drivers/net/wireless/b43/modules.order
/usr/bin/make -f scripts/Makefile.build obj=drivers/net/wireless/rt2x00
   ld -m elf_x86_64   -r -o drivers/net/wireless/libertas/libertas.o 
drivers/net/wireless/libertas/assoc.o 
drivers/net/wireless/libertas/cfg.o drivers/net/wireless/libertas/cmd.o 
drivers/net/wireless/libertas/cmdresp.o 
drivers/net/wireless/libertas/debugfs.o 
drivers/net/wireless/libertas/ethtool.o 
drivers/net/wireless/libertas/main.o drivers/net/wireless/libertas/rx.o 
drivers/net/wireless/libertas/scan.o drivers/net/wireless/libertas/tx.o 
drivers/net/wireless/libertas/wext.o drivers/net/wireless/libertas/mesh.o
(cat /dev/null; ) > drivers/net/wireless/rt2x00/modules.order
   ld -m elf_x86_64   -r -o drivers/net/wireless/libertas/libertas_spi.o 
drivers/net/wireless/libertas/if_spi.o
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.hermes_dld.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(hermes_dld)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco)" -D"DEBUG_HASH=24" 
-D"DEBUG_HASH2=61" -c -o drivers/net/wireless/orinoco/.tmp_hermes_dld.o 
drivers/net/wireless/orinoco/hermes_dld.c
/usr/bin/make -f scripts/Makefile.build obj=drivers/net/wireless/rtl818x
   gcc -Wp,-MD,drivers/net/wireless/prism54/.isl_ioctl.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(isl_ioctl)" 
-D"KBUILD_MODNAME=KBUILD_STR(prism54)" -D"DEBUG_HASH=46" 
-D"DEBUG_HASH2=29" -c -o drivers/net/wireless/prism54/.tmp_isl_ioctl.o 
drivers/net/wireless/prism54/isl_ioctl.c
/usr/bin/make -f scripts/Makefile.build obj=drivers/net/wireless/wl12xx
(cat /dev/null; ) > drivers/net/wireless/wl12xx/modules.order
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.hermes.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(hermes)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco)" -D"DEBUG_HASH=24" 
-D"DEBUG_HASH2=61" -c -o drivers/net/wireless/orinoco/.tmp_hermes.o 
drivers/net/wireless/orinoco/hermes.c
   gcc -Wp,-MD,drivers/net/wireless/rtl818x/.rtl8180_dev.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(rtl8180_dev)" 
-D"KBUILD_MODNAME=KBUILD_STR(rtl8180)" -D"DEBUG_HASH=52" 
-D"DEBUG_HASH2=45" -c -o drivers/net/wireless/rtl818x/.tmp_rtl8180_dev.o 
drivers/net/wireless/rtl818x/rtl8180_dev.c
   gcc -Wp,-MD,drivers/net/wireless/prism54/.islpci_dev.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(islpci_dev)" 
-D"KBUILD_MODNAME=KBUILD_STR(prism54)" -D"DEBUG_HASH=46" 
-D"DEBUG_HASH2=29" -c -o drivers/net/wireless/prism54/.tmp_islpci_dev.o 
drivers/net/wireless/prism54/islpci_dev.c
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.cfg.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(cfg)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco)" -D"DEBUG_HASH=24" 
-D"DEBUG_HASH2=61" -c -o drivers/net/wireless/orinoco/.tmp_cfg.o 
drivers/net/wireless/orinoco/cfg.c
   gcc -Wp,-MD,drivers/net/wireless/prism54/.islpci_hotplug.o.d 
-nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(islpci_hotplug)" 
-D"KBUILD_MODNAME=KBUILD_STR(prism54)" -D"DEBUG_HASH=46" 
-D"DEBUG_HASH2=29" -c -o 
drivers/net/wireless/prism54/.tmp_islpci_hotplug.o 
drivers/net/wireless/prism54/islpci_hotplug.c
   gcc -Wp,-MD,drivers/net/wireless/rtl818x/.rtl8180_rtl8225.o.d 
-nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(rtl8180_rtl8225)" 
-D"KBUILD_MODNAME=KBUILD_STR(rtl8180)" -D"DEBUG_HASH=52" 
-D"DEBUG_HASH2=45" -c -o 
drivers/net/wireless/rtl818x/.tmp_rtl8180_rtl8225.o 
drivers/net/wireless/rtl818x/rtl8180_rtl8225.c
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.orinoco_cs.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(orinoco_cs)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco_cs)" -D"DEBUG_HASH=45" 
-D"DEBUG_HASH2=25" -c -o drivers/net/wireless/orinoco/.tmp_orinoco_cs.o 
drivers/net/wireless/orinoco/orinoco_cs.c
   ld -m elf_x86_64   -r -o drivers/net/wireless/b43/b43.o 
drivers/net/wireless/b43/main.o drivers/net/wireless/b43/tables.o 
drivers/net/wireless/b43/phy_common.o drivers/net/wireless/b43/phy_g.o 
drivers/net/wireless/b43/phy_a.o drivers/net/wireless/b43/phy_lp.o 
drivers/net/wireless/b43/tables_lpphy.o drivers/net/wireless/b43/sysfs.o 
drivers/net/wireless/b43/xmit.o drivers/net/wireless/b43/lo.o 
drivers/net/wireless/b43/wa.o drivers/net/wireless/b43/dma.o 
drivers/net/wireless/b43/pio.o drivers/net/wireless/b43/rfkill.o 
drivers/net/wireless/b43/leds.o drivers/net/wireless/b43/pcmcia.o 
drivers/net/wireless/b43/sdio.o drivers/net/wireless/b43/debugfs.o
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.orinoco_plx.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(orinoco_plx)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco_plx)" -D"DEBUG_HASH=43" 
-D"DEBUG_HASH2=26" -c -o drivers/net/wireless/orinoco/.tmp_orinoco_plx.o 
drivers/net/wireless/orinoco/orinoco_plx.c
   gcc -Wp,-MD,drivers/net/wireless/prism54/.oid_mgt.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(oid_mgt)" 
-D"KBUILD_MODNAME=KBUILD_STR(prism54)" -D"DEBUG_HASH=46" 
-D"DEBUG_HASH2=29" -c -o drivers/net/wireless/prism54/.tmp_oid_mgt.o 
drivers/net/wireless/prism54/oid_mgt.c
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.orinoco_tmd.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(orinoco_tmd)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco_tmd)" -D"DEBUG_HASH=60" 
-D"DEBUG_HASH2=31" -c -o drivers/net/wireless/orinoco/.tmp_orinoco_tmd.o 
drivers/net/wireless/orinoco/orinoco_tmd.c
   gcc -Wp,-MD,drivers/net/wireless/rtl818x/.rtl8180_sa2400.o.d 
-nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(rtl8180_sa2400)" 
-D"KBUILD_MODNAME=KBUILD_STR(rtl8180)" -D"DEBUG_HASH=52" 
-D"DEBUG_HASH2=45" -c -o 
drivers/net/wireless/rtl818x/.tmp_rtl8180_sa2400.o 
drivers/net/wireless/rtl818x/rtl8180_sa2400.c
(cat /dev/null;   echo kernel/drivers/net/wireless/prism54/prism54.ko;) 
 > drivers/net/wireless/prism54/modules.order
   gcc -Wp,-MD,drivers/net/wireless/rtl818x/.rtl8180_max2820.o.d 
-nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(rtl8180_max2820)" 
-D"KBUILD_MODNAME=KBUILD_STR(rtl8180)" -D"DEBUG_HASH=52" 
-D"DEBUG_HASH2=45" -c -o 
drivers/net/wireless/rtl818x/.tmp_rtl8180_max2820.o 
drivers/net/wireless/rtl818x/rtl8180_max2820.c
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.orinoco_nortel.o.d 
-nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(orinoco_nortel)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco_nortel)" -D"DEBUG_HASH=43" 
-D"DEBUG_HASH2=34" -c -o 
drivers/net/wireless/orinoco/.tmp_orinoco_nortel.o 
drivers/net/wireless/orinoco/orinoco_nortel.c
(cat /dev/null;   echo kernel/drivers/net/wireless/rtl818x/rtl8180.ko;) 
 > drivers/net/wireless/rtl818x/modules.order
   gcc -Wp,-MD,drivers/net/wireless/rtl818x/.rtl8180_grf5101.o.d 
-nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(rtl8180_grf5101)" 
-D"KBUILD_MODNAME=KBUILD_STR(rtl8180)" -D"DEBUG_HASH=52" 
-D"DEBUG_HASH2=45" -c -o 
drivers/net/wireless/rtl818x/.tmp_rtl8180_grf5101.o 
drivers/net/wireless/rtl818x/rtl8180_grf5101.c
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.spectrum_cs.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(spectrum_cs)" 
-D"KBUILD_MODNAME=KBUILD_STR(spectrum_cs)" -D"DEBUG_HASH=7" 
-D"DEBUG_HASH2=31" -c -o drivers/net/wireless/orinoco/.tmp_spectrum_cs.o 
drivers/net/wireless/orinoco/spectrum_cs.c
(cat /dev/null;   echo kernel/drivers/net/wireless/orinoco/orinoco.ko; 
  echo kernel/drivers/net/wireless/orinoco/orinoco_cs.ko;   echo 
kernel/drivers/net/wireless/orinoco/orinoco_plx.ko;   echo 
kernel/drivers/net/wireless/orinoco/orinoco_tmd.ko;   echo 
kernel/drivers/net/wireless/orinoco/orinoco_nortel.ko;   echo 
kernel/drivers/net/wireless/orinoco/spectrum_cs.ko;   echo 
kernel/drivers/net/wireless/orinoco/orinoco_usb.ko;) > 
drivers/net/wireless/orinoco/modules.order
   gcc -Wp,-MD,drivers/net/wireless/orinoco/.orinoco_usb.o.d  -nostdinc 
-isystem /usr/lib/gcc/x86_64-linux-gnu/4.4.4/include 
-I/usr/src/linus/linux-2.6-20100522-1007/arch/x86/include -Iinclude 
-include include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -march=core2 -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=2048 -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack -D__CHECK_ENDIAN__  -DMODULE -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(orinoco_usb)" 
-D"KBUILD_MODNAME=KBUILD_STR(orinoco_usb)" -D"DEBUG_HASH=1" 
-D"DEBUG_HASH2=8" -c -o drivers/net/wireless/orinoco/.tmp_orinoco_usb.o 
drivers/net/wireless/orinoco/orinoco_usb.c
   ld -m elf_x86_64   -r -o drivers/net/wireless/orinoco/orinoco.o 
drivers/net/wireless/orinoco/main.o drivers/net/wireless/orinoco/fw.o 
drivers/net/wireless/orinoco/hw.o drivers/net/wireless/orinoco/mic.o 
drivers/net/wireless/orinoco/scan.o drivers/net/wireless/orinoco/wext.o 
drivers/net/wireless/orinoco/hermes_dld.o 
drivers/net/wireless/orinoco/hermes.o drivers/net/wireless/orinoco/cfg.o
   ld -m elf_x86_64   -r -o drivers/net/wireless/prism54/prism54.o 
drivers/net/wireless/prism54/islpci_eth.o 
drivers/net/wireless/prism54/islpci_mgt.o 
drivers/net/wireless/prism54/isl_38xx.o 
drivers/net/wireless/prism54/isl_ioctl.o 
drivers/net/wireless/prism54/islpci_dev.o 
drivers/net/wireless/prism54/islpci_hotplug.o 
drivers/net/wireless/prism54/oid_mgt.o
   ld -m elf_x86_64   -r -o drivers/net/wireless/rtl818x/rtl8180.o 
drivers/net/wireless/rtl818x/rtl8180_dev.o 
drivers/net/wireless/rtl818x/rtl8180_rtl8225.o 
drivers/net/wireless/rtl818x/rtl8180_sa2400.o 
drivers/net/wireless/rtl818x/rtl8180_max2820.o 
drivers/net/wireless/rtl818x/rtl8180_grf5101.o
(cat /dev/null;   cat drivers/net/wireless/ipw2x00/modules.order;   cat 
drivers/net/wireless/ipw2x00/modules.order;   cat 
drivers/net/wireless/orinoco/modules.order;   echo 
kernel/drivers/net/wireless/airo.ko;   echo 
kernel/drivers/net/wireless/airo_cs.ko;   echo 
kernel/drivers/net/wireless/airo.ko;   echo 
kernel/drivers/net/wireless/atmel.ko;   echo 
kernel/drivers/net/wireless/atmel_pci.ko;   echo 
kernel/drivers/net/wireless/atmel_cs.ko;   echo 
kernel/drivers/net/wireless/at76c50x-usb.ko;   cat 
drivers/net/wireless/prism54/modules.order;   cat 
drivers/net/wireless/hostap/modules.order;   cat 
drivers/net/wireless/b43/modules.order;   cat 
drivers/net/wireless/b43legacy/modules.order;   cat 
drivers/net/wireless/rtl818x/modules.order;   echo 
kernel/drivers/net/wireless/ray_cs.ko;   echo 
kernel/drivers/net/wireless/wl3501_cs.ko;   echo 
kernel/drivers/net/wireless/rndis_wlan.ko;   echo 
kernel/drivers/net/wireless/zd1201.ko;   cat 
drivers/net/wireless/libertas/modules.order;   cat 
drivers/net/wireless/libertas_tf/modules.order;   echo 
kernel/drivers/net/wireless/adm8211.ko;   echo 
kernel/drivers/net/wireless/mwl8k.ko;   cat 
drivers/net/wireless/rt2x00/modules.order;   cat 
drivers/net/wireless/p54/modules.order;   echo 
kernel/drivers/net/wireless/mac80211_hwsim.ko;   cat 
drivers/net/wireless/wl12xx/modules.order;   cat 
drivers/net/wireless/iwmc3200wifi/modules.order;) > 
drivers/net/wireless/modules.order
(cat /dev/null;   cat drivers/net/tokenring/modules.order;   cat 
drivers/net/wan/modules.order;   cat drivers/net/pcmcia/modules.order; 
  cat drivers/net/wireless/modules.order;   cat 
drivers/net/tulip/modules.order;   cat 
drivers/net/hamradio/modules.order;   echo kernel/drivers/net/mii.ko; 
echo kernel/drivers/net/mdio.ko;   cat drivers/net/phy/modules.order; 
cat drivers/net/e1000/modules.order;   cat 
drivers/net/e1000e/modules.order;   cat drivers/net/igb/modules.order; 
  cat drivers/net/igbvf/modules.order;   cat 
drivers/net/ixgbe/modules.order;   cat 
drivers/net/ixgbevf/modules.order;   cat drivers/net/ixgb/modules.order; 
   echo kernel/drivers/net/ipg.ko;   cat 
drivers/net/chelsio/modules.order;   cat 
drivers/net/cxgb3/modules.order;   cat drivers/net/cxgb4/modules.order; 
   cat drivers/net/can/modules.order;   cat 
drivers/net/bonding/modules.order;   cat drivers/net/atlx/modules.order; 
   cat drivers/net/atlx/modules.order;   cat 
drivers/net/atl1e/modules.order;   echo kernel/drivers/net/tehuti.ko; 
cat drivers/net/enic/modules.order;   echo kernel/drivers/net/jme.ko; 
cat drivers/net/vmxnet3/modules.order;   echo 
kernel/drivers/net/plip.ko;   echo kernel/drivers/net/rrunner.ko;   echo 
kernel/drivers/net/sunhme.ko;   echo kernel/drivers/net/sungem.ko; 
echo kernel/drivers/net/sungem_phy.ko;   echo 
kernel/drivers/net/cassini.ko;   echo kernel/drivers/net/3c59x.ko; 
echo kernel/drivers/net/typhoon.ko;   echo 
kernel/drivers/net/ne2k-pci.ko;   echo kernel/drivers/net/8390.ko; 
echo kernel/drivers/net/pcnet32.ko;   echo kernel/drivers/net/e100.ko; 
  echo kernel/drivers/net/tlan.ko;   echo kernel/drivers/net/epic100.ko; 
   echo kernel/drivers/net/sis190.ko;   echo 
kernel/drivers/net/sis900.ko;   echo kernel/drivers/net/r6040.ko;   echo 
kernel/drivers/net/yellowfin.ko;   echo kernel/drivers/net/acenic.ko; 
echo kernel/drivers/net/natsemi.ko;   echo 
kernel/drivers/net/ns83820.ko;   echo kernel/drivers/net/fealnx.ko; 
echo kernel/drivers/net/tg3.ko;   echo kernel/drivers/net/bnx2.ko; 
echo kernel/drivers/net/cnic.ko;   echo kernel/drivers/net/bnx2x.ko; 
echo kernel/drivers/net/skge.ko;   echo kernel/drivers/net/sky2.ko; 
cat drivers/net/skfp/modules.order;   echo kernel/drivers/net/ks8842.ko; 
   echo kernel/drivers/net/ks8851.ko;   echo 
kernel/drivers/net/ks8851_mll.ko;   echo kernel/drivers/net/ksz884x.ko; 
   echo kernel/drivers/net/via-rhine.ko;   echo 
kernel/drivers/net/via-velocity.ko;   echo 
kernel/drivers/net/starfire.ko;   echo kernel/drivers/net/sundance.ko; 
  echo kernel/drivers/net/hamachi.ko;   echo 
kernel/drivers/net/sb1000.ko;   echo kernel/drivers/net/8390.ko;   echo 
kernel/drivers/net/hp100.ko;   echo kernel/drivers/net/b44.ko;   echo 
kernel/drivers/net/forcedeth.ko;   echo kernel/drivers/net/qla3xxx.ko; 
  cat drivers/net/qlcnic/modules.order;   cat 
drivers/net/qlge/modules.order;   echo 
kernel/drivers/net/ppp_generic.ko;   echo 
kernel/drivers/net/ppp_async.ko;   echo 
kernel/drivers/net/ppp_synctty.ko;   echo 
kernel/drivers/net/ppp_deflate.ko;   echo 
kernel/drivers/net/bsd_comp.ko;   echo kernel/drivers/net/ppp_mppe.ko; 
  echo kernel/drivers/net/pppox.ko;   echo kernel/drivers/net/pppoe.ko; 
   echo kernel/drivers/net/pppox.ko;   echo kernel/drivers/net/slip.ko; 
   echo kernel/drivers/net/slhc.ko;   echo kernel/drivers/net/dummy.ko; 
   echo kernel/drivers/net/ifb.ko;   echo kernel/drivers/net/macvlan.ko; 
   echo kernel/drivers/net/macvtap.ko;   echo 
kernel/drivers/net/defxx.ko;   echo kernel/drivers/net/8139cp.ko;   echo 
kernel/drivers/net/8139too.ko;   echo kernel/drivers/net/sc92031.ko; 
echo kernel/drivers/net/eql.ko;   echo kernel/drivers/net/tun.ko;   echo 
kernel/drivers/net/veth.ko;   echo kernel/drivers/net/dl2k.ko;   echo 
kernel/drivers/net/r8169.ko;   echo kernel/drivers/net/amd8111e.ko; 
echo kernel/drivers/net/s2io.ko;   cat drivers/net/vxge/modules.order; 
  cat drivers/net/myri10ge/modules.order;   cat 
drivers/net/mlx4/modules.order;   echo kernel/drivers/net/enc28j60.ko; 
  echo kernel/drivers/net/ethoc.ko;   cat 
drivers/net/appletalk/modules.order;   cat 
drivers/net/arcnet/modules.order;   cat drivers/net/usb/modules.order; 
  cat drivers/net/usb/modules.order;   cat 
drivers/net/usb/modules.order;   cat drivers/net/usb/modules.order; 
cat drivers/net/usb/modules.order;   cat drivers/net/usb/modules.order; 
   cat drivers/net/usb/modules.order;   cat 
drivers/net/usb/modules.order;   cat drivers/net/irda/modules.order; 
echo kernel/drivers/net/netconsole.ko;   cat 
drivers/net/netxen/modules.order;   echo kernel/drivers/net/niu.ko; 
echo kernel/drivers/net/virtio_net.ko;   cat 
drivers/net/sfc/modules.order;   cat drivers/net/wimax/modules.order; 
cat drivers/net/caif/modules.order;) > drivers/net/modules.order
(cat /dev/null;   cat drivers/gpio/modules.order;   cat 
drivers/pci/modules.order;   cat drivers/video/modules.order;   cat 
drivers/acpi/modules.order;   cat drivers/pnp/modules.order;   cat 
drivers/regulator/modules.order;   cat drivers/char/modules.order;   cat 
drivers/gpu/modules.order;   cat drivers/serial/modules.order;   cat 
drivers/base/modules.order;   cat drivers/block/modules.order;   cat 
drivers/misc/modules.order;   cat drivers/mfd/modules.order;   cat 
drivers/macintosh/modules.order;   cat drivers/spi/modules.order;   cat 
drivers/net/modules.order;   cat drivers/message/modules.order;   cat 
drivers/ieee1394/modules.order;   cat drivers/cdrom/modules.order;   cat 
drivers/auxdisplay/modules.order;   cat drivers/usb/otg/modules.order; 
  cat drivers/usb/modules.order;   cat drivers/usb/modules.order;   cat 
drivers/input/serio/modules.order;   cat drivers/input/modules.order; 
cat drivers/rtc/modules.order;   cat drivers/i2c/modules.order;   cat 
drivers/media/modules.order;   cat drivers/power/modules.order;   cat 
drivers/hwmon/modules.order;   cat drivers/watchdog/modules.order;   cat 
drivers/md/modules.order;   cat drivers/accessibility/modules.order; 
cat drivers/isdn/modules.order;   cat drivers/edac/modules.order;   cat 
drivers/lguest/modules.order;   cat drivers/cpufreq/modules.order;   cat 
drivers/cpuidle/modules.order;   cat drivers/idle/modules.order;   cat 
drivers/leds/modules.order;   cat drivers/firmware/modules.order;   cat 
drivers/crypto/modules.order;   cat drivers/clocksource/modules.order; 
  cat drivers/dma/modules.order;   cat drivers/platform/modules.order; 
  cat drivers/ieee802154/modules.order;   cat 
drivers/virtio/modules.order;   cat drivers/connector/modules.order; 
cat drivers/parport/modules.order;   cat drivers/ide/modules.order; 
cat drivers/scsi/modules.order;   cat drivers/ata/modules.order;   cat 
drivers/mtd/modules.order;   cat drivers/atm/modules.order;   cat 
drivers/uio/modules.order;   cat drivers/pcmcia/modules.order;   cat 
drivers/block/aoe/modules.order;   cat 
drivers/block/paride/modules.order;   cat drivers/uwb/modules.order; 
cat drivers/usb/gadget/modules.order;   cat 
drivers/input/gameport/modules.order;   cat drivers/pps/modules.order; 
  cat drivers/w1/modules.order;   cat drivers/thermal/modules.order; 
cat drivers/telephony/modules.order;   cat 
drivers/bluetooth/modules.order;   cat drivers/mmc/modules.order;   cat 
drivers/memstick/modules.order;   cat drivers/infiniband/modules.order; 
   cat drivers/dca/modules.order;   cat drivers/hid/modules.order;   cat 
drivers/ssb/modules.order;   cat drivers/vhost/modules.order;) > 
drivers/modules.order
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/accessibility
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/acpi
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/auxdisplay
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/base
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/block
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/cdrom
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/char
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/clocksource
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/cpufreq
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/cpuidle
(for m in drivers/cpufreq/cpufreq_performance.ko; do echo kernel/$m; 
done;      \
         cat /dev/null ) > drivers/cpufreq/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/cpuidle/governors
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/crypto
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/cpuidle/governors/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/cpuidle/governors/modules.builtin) > 
drivers/cpuidle/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/dma
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/crypto/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/edac
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/auxdisplay/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/firmware
/usr/bin/make -f scripts/Makefile.modbuiltin 
obj=drivers/accessibility/braille
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/base/power
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/accessibility/braille/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/base/power/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/accessibility/braille/modules.builtin) > 
drivers/accessibility/modules.builtin
(for m in drivers/base/firmware_class.ko; do echo kernel/$m; done;      \
         cat /dev/null drivers/base/power/modules.builtin) > 
drivers/base/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/gpio
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/gpu
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/acpi/acpica
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/acpi/acpica/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/acpi/acpica/modules.builtin) > 
drivers/acpi/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/hwmon
(for m in drivers/block/brd.ko; do echo kernel/$m; done;        \
         cat /dev/null ) > drivers/block/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/i2c
(for m in drivers/hwmon/hwmon.ko; do echo kernel/$m; done;      \
         cat /dev/null ) > drivers/hwmon/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/idle
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/i2c/algos
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/idle/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/i2c/algos/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/ieee1394
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/i2c/busses
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/cdrom/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/ieee802154
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/i2c/busses/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/i2c/algos/modules.builtin 
drivers/i2c/busses/modules.builtin) > drivers/i2c/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/input
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/clocksource/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/input/serio
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/input/joystick
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/dma/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/isdn
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/char/agp
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/isdn/hardware
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/isdn/hardware/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/isdn/hardware/modules.builtin) > 
drivers/isdn/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/edac/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/char/tpm
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/leds
(for m in drivers/char/tpm/tpm.ko drivers/char/tpm/tpm_bios.ko 
drivers/char/tpm/tpm_tis.ko; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/char/tpm/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/firmware/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/input/keyboard
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/lguest
(for m in drivers/input/keyboard/atkbd.ko; do echo kernel/$m; done;     \
         cat /dev/null ) > drivers/input/keyboard/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/gpio/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/macintosh
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/md
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/md/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/input/misc
(for m in drivers/input/serio/serio.ko drivers/input/serio/i8042.ko 
drivers/input/serio/libps2.ko; do echo kernel/$m; done;     \
         cat /dev/null ) > drivers/input/serio/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/media
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/input/misc/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/message
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/ieee802154/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/message/fusion
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/mfd
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/message/fusion/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/message/fusion/modules.builtin) > 
drivers/message/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/mfd/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/gpu/drm
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/input/mouse
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/misc
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/gpu/drm/i2c
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/input/mouse/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/misc/cb710
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/misc/eeprom
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/input/joystick/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/gpu/drm/i2c/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/input/tablet
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/misc/cb710/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/gpu/vga
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/gpu/drm/i2c/modules.builtin) > 
drivers/gpu/drm/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/input/touchscreen
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/misc/eeprom/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/misc/cb710/modules.builtin 
drivers/misc/eeprom/modules.builtin) > drivers/misc/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/net
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/input/tablet/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/pci
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/gpu/vga/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/gpu/drm/modules.builtin 
drivers/gpu/vga/modules.builtin) > drivers/gpu/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/leds/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/input/touchscreen/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/net/hamradio
(for m in drivers/input/input-core.ko drivers/input/mousedev.ko; do echo 
kernel/$m; done;       \
         cat /dev/null drivers/input/joystick/modules.builtin 
drivers/input/keyboard/modules.builtin 
drivers/input/misc/modules.builtin drivers/input/mouse/modules.builtin 
drivers/input/tablet/modules.builtin 
drivers/input/touchscreen/modules.builtin) > drivers/input/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/platform
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/net/pcmcia
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/pnp
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/pci/pcie
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/net/hamradio/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/platform/x86
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/net/pcmcia/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/lguest/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/net/tokenring
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/pnp/pnpacpi
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/power
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/net/tulip
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/platform/x86/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/pci/pcie/aer
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/net/tokenring/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/ieee1394/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/pci/pcie/aer/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/regulator
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/net/wan
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/platform/x86/modules.builtin) > 
drivers/platform/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/pci/pcie/pme
(for m in drivers/power/power_supply.ko; do echo kernel/$m; done;       \
         cat /dev/null ) > drivers/power/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/net/tulip/modules.builtin
(for m in drivers/macintosh/mac_hid.ko; do echo kernel/$m; done;        \
         cat /dev/null ) > drivers/macintosh/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/rtc
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/serial
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/net/wan/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/net/wireless
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/pci/pcie/pme/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/regulator/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/pnp/pnpacpi/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/spi
(for m in drivers/rtc/rtc-lib.ko drivers/rtc/rtc-core.ko 
drivers/rtc/rtc-cmos.ko; do echo kernel/$m; done;      \
         cat /dev/null ) > drivers/rtc/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/usb
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/net/wireless/modules.builtin
(for m in drivers/serial/serial_core.ko drivers/serial/8250.ko 
drivers/serial/8250_pnp.ko drivers/serial/8250_pci.ko; do echo 
kernel/$m; done;  \
         cat /dev/null ) > drivers/serial/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/pnp/pnpacpi/modules.builtin) > 
drivers/pnp/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/spi/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/media/IR
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/usb/otg
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/net/hamradio/modules.builtin 
drivers/net/pcmcia/modules.builtin drivers/net/tokenring/modules.builtin 
drivers/net/tulip/modules.builtin drivers/net/wan/modules.builtin 
drivers/net/wireless/modules.builtin) > drivers/net/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/video
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/usb/core
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/watchdog
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/usb/otg/modules.builtin
(for m in drivers/char/agp/agpgart.ko drivers/char/agp/amd64-agp.ko; do 
echo kernel/$m; done;   \
         cat /dev/null ) > drivers/char/agp/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/pci/pcie/aer/modules.builtin 
drivers/pci/pcie/pme/modules.builtin) > drivers/pci/pcie/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/char/agp/modules.builtin 
drivers/char/tpm/modules.builtin) > drivers/char/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/video/backlight
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/usb/early
(for m in drivers/usb/core/usbcore.ko; do echo kernel/$m; done; \
         cat /dev/null ) > drivers/usb/core/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/media/common
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/pci/pcie/modules.builtin) > 
drivers/pci/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/media/video
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/usb/host
(for m in drivers/video/backlight/backlight.ko 
drivers/video/backlight/generic_bl.ko; do echo kernel/$m; done;  \
         cat /dev/null ) > drivers/video/backlight/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/video/console
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/watchdog/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/media/IR/keymaps
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/usb/early/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/usb/misc
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/video/display
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/media/common/tuners
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/usb/misc/modules.builtin
(for m in drivers/video/console/fbcon.ko 
drivers/video/console/bitblit.ko drivers/video/console/font.ko 
drivers/video/console/softcursor.ko drivers/video/console/tileblit.ko 
drivers/video/console/fbcon_rotate.ko drivers/video/console/fbcon_cw.ko 
drivers/video/console/fbcon_ud.ko drivers/video/console/fbcon_ccw.ko; do 
echo kernel/$m; done;        \
         cat /dev/null ) > drivers/video/console/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/video/geode
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/usb/mon
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/usb/host/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/video/display/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/media/IR/keymaps/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/video/logo
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/media/IR/keymaps/modules.builtin) > 
drivers/media/IR/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/media/video/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/usb/storage
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/video/geode/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/media/common/tuners/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/video/omap2
(for m in drivers/usb/mon/usbmon.ko; do echo kernel/$m; done;   \
         cat /dev/null ) > drivers/usb/mon/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/media/common/tuners/modules.builtin) > 
drivers/media/common/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/video/logo/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/media/IR/modules.builtin 
drivers/media/common/modules.builtin 
drivers/media/video/modules.builtin) > drivers/media/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/usb/storage/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/usb/core/modules.builtin 
drivers/usb/early/modules.builtin drivers/usb/host/modules.builtin 
drivers/usb/misc/modules.builtin drivers/usb/mon/modules.builtin 
drivers/usb/storage/modules.builtin) > drivers/usb/modules.builtin
/usr/bin/make -f scripts/Makefile.modbuiltin 
obj=drivers/video/omap2/displays
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/video/omap2/dss
/usr/bin/make -f scripts/Makefile.modbuiltin obj=drivers/video/omap2/omapfb
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/video/omap2/displays/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/video/omap2/dss/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null ) > drivers/video/omap2/omapfb/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/video/omap2/displays/modules.builtin 
drivers/video/omap2/dss/modules.builtin 
drivers/video/omap2/omapfb/modules.builtin) > 
drivers/video/omap2/modules.builtin
(for m in drivers/video/fb.ko drivers/video/cfbfillrect.ko 
drivers/video/cfbcopyarea.ko drivers/video/cfbimgblt.ko; do echo 
kernel/$m; done;    \
         cat /dev/null drivers/video/backlight/modules.builtin 
drivers/video/console/modules.builtin 
drivers/video/display/modules.builtin 
drivers/video/geode/modules.builtin drivers/video/logo/modules.builtin 
drivers/video/omap2/modules.builtin) > drivers/video/modules.builtin
(for m in ; do echo kernel/$m; done;    \
         cat /dev/null drivers/accessibility/modules.builtin 
drivers/acpi/modules.builtin drivers/auxdisplay/modules.builtin 
drivers/base/modules.builtin drivers/block/modules.builtin 
drivers/cdrom/modules.builtin drivers/char/modules.builtin 
drivers/clocksource/modules.builtin drivers/cpufreq/modules.builtin 
drivers/cpuidle/modules.builtin drivers/crypto/modules.builtin 
drivers/dma/modules.builtin drivers/edac/modules.builtin 
drivers/firmware/modules.builtin drivers/gpio/modules.builtin 
drivers/gpu/modules.builtin drivers/hwmon/modules.builtin 
drivers/i2c/modules.builtin drivers/idle/modules.builtin 
drivers/ieee1394/modules.builtin drivers/ieee802154/modules.builtin 
drivers/input/modules.builtin drivers/input/serio/modules.builtin 
drivers/isdn/modules.builtin drivers/leds/modules.builtin 
drivers/lguest/modules.builtin drivers/macintosh/modules.builtin 
drivers/md/modules.builtin drivers/media/modules.builtin 
drivers/message/modules.builtin drivers/mfd/modules.builtin 
drivers/misc/modules.builtin drivers/net/modules.builtin 
drivers/pci/modules.builtin drivers/platform/modules.builtin 
drivers/pnp/modules.builtin drivers/power/modules.builtin 
drivers/regulator/modules.builtin drivers/rtc/modules.builtin 
drivers/serial/modules.builtin drivers/spi/modules.builtin 
drivers/usb/modules.builtin drivers/usb/otg/modules.builtin 
drivers/video/modules.builtin drivers/watchdog/modules.builtin) > 
drivers/modules.builtin
make[1]: Opuszczenie katalogu `/usr/src/linus/linux-2.6-20100522-1007'
make: *** [debian/stamp/build/kernel] B³±d 2

B³±d = error in english.

Regards,

Piotr Hosowicz

-- 
- Czy jest cukier w kostkach ?
- Nie ma.
- A jakas inna tania bombonierka? Dla tesciowej.
NP: Patrick O'Hearn - Approaching Summit
NB: 2.6.34-20100521-1728
