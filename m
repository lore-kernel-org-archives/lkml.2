Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab1BNQ6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:58:55 -0500
Received: from atlas.spacebel.com ([194.7.24.201]:33455 "EHLO
	atlas.spacebel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab1BNQ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:58:52 -0500
X-Greylist: delayed 1383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Feb 2011 11:58:50 EST
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CBCC65.39F68399"
Subject: PROBLEM: "unable to handle kernel paging request at"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Mon, 14 Feb 2011 17:35:43 +0100
Message-ID: <78B00FA862FF2D49B7C3EF71AAED1D910111E0D3@spb-hlt-mx01.spb.spacebel.be>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: PROBLEM: "unable to handle kernel paging request at"
Thread-Index: AcvMZTlPdM34zgA1QrKcs+tpucZujw==
From: =?iso-8859-1?Q?Guy_L=E9onis?= <Guy.Leonis@spacebel.be>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Feb 2011 16:32:28.0437 (UTC) FILETIME=[C5042450:01CBCC64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01CBCC65.39F68399
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Dear linux-kernel,

[1.] One line summary of the problem:
After plenty (thousands if not millions) of successful write to the user =
space, my driver fails on writing to the same address.


[2.] Full description of the problem/report:
In the frame of a European Space Agency project, I am in charge of =
porting a third-party PCMCIA driver (for a very specific and rare card, =
the BU-65550 or BU-65553 1553 card from DDC) from kernel 2.4 (Card =
Services) to kernel 2.6 (linux-pcmcia and PCMCIA utils). DDC is also the =
provider of the genuine 2.4 version of the driver.
I am running Red Hat Enterprise Linux 5.5 64b on a Lenovo T61p laptop =
computer.
Thanks to support by Dominik Brodowski =
(linux-pcmcia@lists.infradead.org), I am now using intensively the =
ported 1553 driver with success, almost 12 hours a day. But about once =
in a few days it fails, creating a kernel panic.
Here is the log from the ported 1553 driver just before the kernel =
panic:

pcmace: fops_ioctl: BLOCK_IN_DRIVER
pcmace: fops_ioctl: param1 0xF7BF0390
pcmace: fops_ioctl: BLOCK_IN_DRIVER: before wait
pcmace: fops_ioctl: param2 0xF7BF0390
pcmace: entering legacy ACE isr pcmace_isr
pcmace: pcmace_isr: bChanNum 0
pcmace: pcmace_isr: bCardNum 0
pcmace: pcmace_isr: 01
pcmace: pcmace_isr: dwChanOffset 0xFFFFC20010104000
pcmace: pcmace_isr: dwChanOffset 0xFFFFC2001010400C
pcmace: pcmace_isr: 02
pcmace: pcmace_isr: 03
pcmace: pcmace_isr: 04
pcmace: legacy ACE isr: 05
pcmace: legacy ACE isr: 14
pcmace: legacy ACE isr: 15
pcmace: legacy ACE isr: 16
pcmace: fops_ioctl: BLOCK_IN_DRIVER: after wait
pcmace: fops_ioctl: param3 0xF7BF0390
pcmace: fops_ioctl: BLOCK_IN_DRIVER
pcmace: fops_ioctl: param1 0xF7BF0390
pcmace: fops_ioctl: BLOCK_IN_DRIVER: before wait
pcmace: fops_ioctl: param2 0xF7BF0390
pcmace: entering legacy ACE isr pcmace_isr
pcmace: pcmace_isr: bChanNum 0
pcmace: pcmace_isr: bCardNum 0
pcmace: pcmace_isr: 01
pcmace: pcmace_isr: dwChanOffset 0xFFFFC20010104000
pcmace: pcmace_isr: dwChanOffset 0xFFFFC2001010400C
pcmace: pcmace_isr: 02
pcmace: pcmace_isr: 03
pcmace: pcmace_isr: 04
pcmace: legacy ACE isr: 05
pcmace: legacy ACE isr: 14
pcmace: legacy ACE isr: 15
pcmace: legacy ACE isr: 16
pcmace: fops_ioctl: BLOCK_IN_DRIVER: after wait
pcmace: fops_ioctl: param3 0xF7BF0390
pcmace: fops_ioctl: BLOCK_IN_DRIVER
pcmace: fops_ioctl: param1 0xF7BF0390
pcmace: fops_ioctl: BLOCK_IN_DRIVER: before wait
pcmace: fops_ioctl: param2 0xF7BF0390
pcmace: entering legacy ACE isr pcmace_isr
pcmace: pcmace_isr: bChanNum 0
pcmace: pcmace_isr: bCardNum 0
pcmace: pcmace_isr: 01
pcmace: pcmace_isr: dwChanOffset 0xFFFFC20010104000
pcmace: pcmace_isr: dwChanOffset 0xFFFFC2001010400C
pcmace: pcmace_isr: 02
pcmace: pcmace_isr: 03
pcmace: pcmace_isr: 04
pcmace: legacy ACE isr: 05
pcmace: legacy ACE isr: 14
pcmace: legacy ACE isr: 15
pcmace: legacy ACE isr: 16
pcmace: fops_ioctl: BLOCK_IN_DRIVER: after wait
pcmace: fops_ioctl: param3 0xF7BF0390

The oops message is given in section [5.].

Here is the part of the code which is executed before the kernel panic =
(full driver attached):

/* ISR for legacy ACE devices. */
static irqreturn_t pcmace_isr(int irq, void* dev_id, struct pt_regs =
*regs)
{
    __u8    *bpChanNum    =3D dev_id;             /* Pointer to =
interrupted device */
    __u8    bSystemNum    =3D (__u8)(*bpChanNum); /* Enumerated System =
Number */
    __u8    bCardNum      =3D (__u8)(bSystemNum); /* Card number in =
system (0 - 3) */
    __u8    bChanNum      =3D 0;                  /* Channel number on =
card (0, 1) */
/*    __u8   bIntFlag      =3D 0x11; */           /* This device's INT =
flag */
    __u8   bCurArea      =3D 0x00;                /* Current Stack Area =
(A/B) */
    __u8   bBCEof        =3D 0x00;                /* BC End-of-Frame =
Interrupt */
/*    __u16  wConfigReg    =3D 0x1111; */         /* 65549 0800 =
Configuration Space */
    __u16  wIntStatReg   =3D 0x0000;              /* Ace Interrupt =
Status Register */
    __u16  wCfgReg1      =3D 0x0000;              /* Ace Configuration =
Register #1 */
    __u64  dwChanOffset  =3D 0x0000000000000000;  /* Holds the channel's =
Reg base addr */

    DEBUG(10, "%s: entering legacy ACE isr pcmace_isr\n", MODULE_NAME);
    DEBUG(10, "%s: pcmace_isr: bChanNum %u\n", MODULE_NAME, bChanNum);
    DEBUG(10, "%s: pcmace_isr: bCardNum %u\n", MODULE_NAME, bCardNum);

    /* Get Channel Offset */
    dwChanOffset =3D (__u64)(m_aCards[bCardNum].dwRegWndKrnAddr + =
(bChanNum*0x0080)); /* reg space =3D 0x80 */
    DEBUG(10, "%s: pcmace_isr: 01\n", MODULE_NAME);
    DEBUG(10, "%s: pcmace_isr: dwChanOffset 0x%llX\n",
          MODULE_NAME, dwChanOffset);
    DEBUG(10, "%s: pcmace_isr: dwChanOffset 0x%llX\n",
          MODULE_NAME, dwChanOffset + 0x000C);

    /* Get INTERRUPT_STATUS_REG */
    m_aCards[bCardNum].Channel.dwIntStatus =3D =
(__u32)readw((void*)(dwChanOffset + 0x000C));
    DEBUG(10, "%s: pcmace_isr: 02\n", MODULE_NAME);

    /* Wake up the blocked driver level ISR thread */
    wake_up_interruptible(&m_apWaitQue[bCardNum]);
    m_apWaitFlag =3D 1;
    DEBUG(10, "%s: pcmace_isr: 03\n", MODULE_NAME);

    /* Make sure Interrupt Status Reg is valid */
    if (m_aCards[bCardNum].Channel.dwIntStatus)
    {
        DEBUG(10, "%s: pcmace_isr: 04\n", MODULE_NAME);
        /* Check for BC EOF Interrupt */
        bBCEof =3D ((wIntStatReg >> 3) & 0x1);
        DEBUG(10, "%s: legacy ACE isr: 05\n", MODULE_NAME);

        /* Flip BC Stacks if EOF Int and its enabled */
        if ((m_aCards[bCardNum].Channel.bAutoFlipStk) && (bBCEof))
        {
            DEBUG(10, "%s: legacy ACE isr: 06\n", MODULE_NAME);
            /* Get CONFIG_REG_1 */
            wCfgReg1 =3D readw((void*)(dwChanOffset + 0x0002));
            DEBUG(10, "%s: legacy ACE isr: 07\n", MODULE_NAME);

            /* Get Current BC Stack Area */
            bCurArea =3D ((wCfgReg1 >> 13) & 0x1);
            DEBUG(10, "%s: legacy ACE isr: 08\n", MODULE_NAME);
            if (bCurArea)  /* A */
            {
                DEBUG(10, "%s: legacy ACE isr: 09\n", MODULE_NAME);
                writew(wCfgReg1&0xDFFF,(void*)(dwChanOffset + 0x0002));
                DEBUG(10, "%s: legacy ACE isr: 10\n", MODULE_NAME);
            }
            else  /* B */
            {
                DEBUG(10, "%s: legacy ACE isr: 11\n", MODULE_NAME);
                writew(wCfgReg1|0x2000,(void*)(dwChanOffset + 0x0002));
                DEBUG(10, "%s: legacy ACE isr: 12\n", MODULE_NAME);
            }
            DEBUG(10, "%s: legacy ACE isr: 13\n", MODULE_NAME);
        }
        DEBUG(10, "%s: legacy ACE isr: 14\n", MODULE_NAME);
    }
    /* Clear Interrupt */
    DEBUG(10, "%s: legacy ACE isr: 15\n", MODULE_NAME);
    writew(0x0004,(void*)(dwChanOffset + 0x0006));
    DEBUG(10, "%s: legacy ACE isr: 16\n", MODULE_NAME);

    return 0;
}
static int pcmace_fops_ioctl(struct inode *inode, struct file *flip, =
unsigned int wCmd, unsigned long dwParam)
{
    int     nResult     =3D STATUS_ACE53_SUCCESS;   /* return value */
    __u8    bCardNum    =3D MINOR(inode->i_rdev);   /* Card number in =
system (0 - 3) */
    __u8     *bpCardNum =3D &m_Dev_id[bCardNum]; /*jmf used to register =
interrupts seperatley for each card */
    __u32    dwFlags     =3D 0x00000000;              /* temp variables =
for cli() */
    irqreturn_t (*pfIsr)(int, void*, struct pt_regs*) =3D NULL;

    /* Process the command. */
    switch(wCmd)
    {
        /* Block Driver (Sleep Thread) */
        case IOCTL_ACE53_BLOCK_IN_DRIVER:
            DEBUG(10, "%s: fops_ioctl: BLOCK_IN_DRIVER\n", MODULE_NAME);
            DEBUG(80, "%s: fops_ioctl: param1 0x%lX\n", MODULE_NAME, =
dwParam);
            save_flags(dwFlags); /* Save processor state */
            cli();               /* Disable interrupts */

             /* If interrupts are disabled.. */
            if( !m_aCards[bCardNum].Channel.bIsrEnabled )
            {
                restore_flags(dwFlags);  /* Restore processor state */
                sti();                   /* Enable interrupts */
                nResult =3D STATUS_ACE53_IOCTL_INTERRUPT_NOT_ENABLED;
                break;
            }
            /* Interrupts are enabled... */
            restore_flags(dwFlags); /* Restore processor state */
            sti();                  /* flags and enable interrupts */

            /* Put to sleep until interrupt or uninstall wakes us */
            //interruptible_sleep_on(&m_apWaitQue[bCardNum]);
            DEBUG(80, "%s: fops_ioctl: BLOCK_IN_DRIVER: before wait\n",
                  MODULE_NAME);
            DEBUG(80, "%s: fops_ioctl: param2 0x%lX\n", MODULE_NAME, =
dwParam);
            wait_event_interruptible(m_apWaitQue[bCardNum], m_apWaitFlag =
!=3D 0);
            DEBUG(80, "%s: fops_ioctl: BLOCK_IN_DRIVER: after wait\n",
                  MODULE_NAME);
            m_apWaitFlag =3D 0;

            /* Save Interrupt Status Register */
            DEBUG(80, "%s: fops_ioctl: param3 0x%lX\n", MODULE_NAME, =
dwParam);
            dumpStruct();
>>>            *(__u32 *)dwParam =3D =
m_aCards[bCardNum].Channel.dwIntStatus; /* this was 16 bit cast for ACE. =
 Is this a problem?  kwh */

            break;
    }

    return nResult;
}

>From the oops message and gdb, the faulty line in the one with >>> above =
(assigning through dwParam).
As you can see from the log, the dwParam value (pointer to user space) =
is always the same, used without problem many many times (for hours), =
but is becoming invalid at some point.
>From the oops message, the user process 'immi' calling the driver seems =
still alive, so the dwParam value should still be valid.
I have tested writing before the 'wait_event_interruptible' call, which =
was always successful (so it is the code executed during the blocking =
wait_event_interruptible that creates the problem).


[3.] Keywords (i.e., modules, networking, kernel):
kernel, paging, USB, PCMCIA


[4.] Kernel version (from /proc/version):
Linux version 2.6.18-194.el5 (mockbuild@x86-005.build.bos.redhat.com) =
(gcc version 4.1.2 20080704 (Red Hat 4.1.2-48)) #1 SMP Tue Mar 16 =
21:52:39 EDT 2010


[5.] Output of Oops.. message (if applicable) with symbolic information=20
     resolved (see Documentation/oops-tracing.txt)
Unable to handle kernel paging request at 00000000f7bf0390 RIP:=20
 [<ffffffff88842386>] :pcmace:pcmace_fops_ioctl+0x312/0x4c6
PGD 109b23067 PUD 1141e6067 PMD 10c09b067 PTE 80000000b5430065
Oops: 0003 [1] SMP=20
last sysfs file: /class/misc/crash/dev
CPU 0=20
Modules linked in: catch_nmi(U) pcmace(U) crash netconsole nfsd exportfs =
auth_rpcgss hidp l2cap nfs fscache nfs_acl lockd sunrpc cpufreq_ondemand =
acpi_cpufreq freq_table loop dm_mirror dm_multipath scsi_dh video =
thinkpad_acpi backlight sbs power_meter hwmon i2c_ec dell_wmi wmi button =
battery asus_acpi acpi_memhotplug ac ipv6 xfrm_nalgo parport_pc lp =
parport testmgr_cipher testmgr aead crypto_blkcipher crypto_algapi =
crypto_api arc4 snd_hda_intel iwlagn iwlcore snd_seq_dummy joydev =
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss =
snd_mixer_oss sg snd_pcm mac80211 snd_timer snd_page_alloc snd_hwdep =
ide_cd cfg80211 sdhci hci_usb snd shpchp ftdi_sio mmc_core cdrom pcspkr =
i2c_i801 e1000e serio_raw usbserial rfkill bluetooth i2c_core soundcore =
wireless_compat dm_raid45 dm_message dm_region_hash dm_log dm_mod =
dm_mem_cache ata_piix ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd =
ohci_hcd ehci_hcd
Pid: 7921, comm: immi Tainted: G   M  2.6.18-194.el5 #1
RIP: 0010:[<ffffffff88842386>]  [<ffffffff88842386>] =
:pcmace:pcmace_fops_ioctl+0x312/0x4c6
RSP: 0018:ffff8100b9e7dc88  EFLAGS: 00010282
RAX: 0000000000008011 RBX: 00000000f7bf0390 RCX: 0000000000000286
RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffffff80312ddc
RBP: ffffffff88851ea0 R08: ffff8101343453c0 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000006 R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff88846ca0 R15: 00000000f7bf0390
FS:  0000000000000000(0000) GS:ffffffff803cb000(0063) =
knlGS:00000000f7bf0b90
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 00000000f7bf0390 CR3: 0000000109f06000 CR4: 00000000000006e0
Process immi (pid: 7921, threadinfo ffff8100b9e7c000, task =
ffff810113e48040)
Stack:  0000000000000000 ffff810113e48040 ffffffff800a1ba4 =
ffff8100b9e7dca0
 ffff8100b9e7dca0 ffffffff8002b379 0000000000000000 000000008008dd04
 ffff8100a92069c0 0000000000000000 0000000000000000 ffffffff8884257d
Call Trace:
 [<ffffffff800a1ba4>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8002b379>] flush_tlb_page+0xac/0xda
 [<ffffffff8884257d>] :pcmace:pcmace_fops_compat_ioctl+0x43/0x6a
 [<ffffffff80011149>] do_wp_page+0x3fd/0x902
 [<ffffffff8009a021>] __dequeue_signal+0x12d/0x193
 [<ffffffff8012ac81>] avc_has_perm+0x46/0x58
 [<ffffffff8012b541>] inode_has_perm+0x56/0x63
 [<ffffffff800656ac>] __down_read+0x7a/0x92
 [<ffffffff80022127>] __up_read+0x19/0x7f
 [<ffffffff8012b5e2>] file_has_perm+0x94/0xa3
 [<ffffffff800fb8d4>] compat_sys_ioctl+0xc5/0x2b2
 [<ffffffff8006249d>] sysenter_do_call+0x1e/0x76


Code: 89 03 e9 9c fd ff ff 48 c7 c6 28 43 84 88 48 c7 c7 83 44 84=20
     3bc:	89 03                	mov    %eax,(%rbx)
     3be:	e9 9c fd ff ff       	jmpq   129 <pcmace_fops_ioctl+0xb5>
RIP  [<ffffffff88842386>] :pcmace:pcmace_fops_ioctl+0x312/0x4c6
 RSP <ffff8100b9e7dc88>
CR2: 00000000f7bf0390
 <0>Kernel panic - not syncing: Fatal exception


[6.] A small shell script or example program which triggers the
     problem (if possible)
Not possible, sorry.


[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
=20
Linux nasa-514 2.6.18-194.el5 #1 SMP Tue Mar 16 21:52:39 EDT 2010 x86_64 =
x86_64 x86_64 GNU/Linux
=20
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17.50.0.6-14.el5
util-linux             2.13-pre7
mount                  2.13-pre7
module-init-tools      3.3-pre2
e2fsprogs              1.39
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.97
udev                   095
Modules Loaded         catch_nmi pcmace crash netconsole nfsd exportfs =
auth_rpcgss hidp l2cap nfs fscache nfs_acl lockd sunrpc cpufreq_ondemand =
acpi_cpufreq freq_table loop dm_mirror dm_multipath scsi_dh video =
thinkpad_acpi backlight sbs power_meter hwmon i2c_ec dell_wmi wmi button =
battery asus_acpi acpi_memhotplug ac ipv6 xfrm_nalgo parport_pc lp =
parport snd_hda_intel testmgr_cipher testmgr aead crypto_blkcipher =
crypto_algapi crypto_api arc4 snd_seq_dummy iwlagn snd_seq_oss =
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss =
iwlcore snd_pcm snd_timer snd_page_alloc mac80211 snd_hwdep ftdi_sio =
hci_usb sg cfg80211 joydev e1000e snd ide_cd sdhci i2c_i801 usbserial =
mmc_core i2c_core bluetooth rfkill cdrom soundcore shpchp serio_raw =
pcspkr wireless_compat dm_raid45 dm_message dm_region_hash dm_log dm_mod =
dm_mem_cache ata_piix ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd =
ohci_hcd ehci_hcd


[7.2.] Processor information (from /proc/cpuinfo):
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz
stepping	: 11
cpu MHz		: 800.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm =
constant_tsc ida pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 4787.99
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz
stepping	: 11
cpu MHz		: 800.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm =
constant_tsc ida pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 4787.73
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


[7.3.] Module information (from /proc/modules):
catch_nmi 42016 0 - Live 0xffffffff88872000 (U)
pcmace 213792 1 - Live 0xffffffff8883c000 (U)
crash 36033 0 - Live 0xffffffff88832000
netconsole 36577 0 - Live 0xffffffff88828000
nfsd 287337 17 - Live 0xffffffff887e0000
exportfs 38849 1 nfsd, Live 0xffffffff887d5000
auth_rpcgss 81889 1 nfsd, Live 0xffffffff887c0000
hidp 83521 2 - Live 0xffffffff887aa000
l2cap 89281 5 hidp, Live 0xffffffff88793000
nfs 296589 6 - Live 0xffffffff88749000
fscache 52385 1 nfs, Live 0xffffffff8873b000
nfs_acl 36673 2 nfsd,nfs, Live 0xffffffff88731000
lockd 101553 3 nfsd,nfs, Live 0xffffffff88717000
sunrpc 199945 33 nfsd,auth_rpcgss,nfs,nfs_acl,lockd, Live =
0xffffffff886e5000
cpufreq_ondemand 42449 1 - Live 0xffffffff886d9000
acpi_cpufreq 47937 1 - Live 0xffffffff886cc000
freq_table 38977 2 cpufreq_ondemand,acpi_cpufreq, Live =
0xffffffff886c1000
loop 48721 0 - Live 0xffffffff886b4000
dm_mirror 54737 0 - Live 0xffffffff886a5000
dm_multipath 56921 0 - Live 0xffffffff88696000
scsi_dh 42177 1 dm_multipath, Live 0xffffffff8868a000
video 53197 0 - Live 0xffffffff8867c000
thinkpad_acpi 95509 0 - Live 0xffffffff88663000
backlight 39873 2 video,thinkpad_acpi, Live 0xffffffff88658000
sbs 49921 0 - Live 0xffffffff8864a000
power_meter 46925 0 - Live 0xffffffff8863d000
hwmon 36553 2 thinkpad_acpi,power_meter, Live 0xffffffff88633000
i2c_ec 38593 1 sbs, Live 0xffffffff88628000
dell_wmi 37601 0 - Live 0xffffffff8861d000
wmi 41985 1 dell_wmi, Live 0xffffffff88611000
button 40545 0 - Live 0xffffffff88606000
battery 43849 0 - Live 0xffffffff885fa000
asus_acpi 50917 0 - Live 0xffffffff885ec000
acpi_memhotplug 40261 0 - Live 0xffffffff885e1000
ac 38729 0 - Live 0xffffffff885d6000
ipv6 435361 26 - Live 0xffffffff8856a000
xfrm_nalgo 43333 1 ipv6, Live 0xffffffff8855e000
parport_pc 62313 0 - Live 0xffffffff8854d000
lp 47121 0 - Live 0xffffffff88540000
parport 73165 2 parport_pc,lp, Live 0xffffffff8852d000
snd_hda_intel 639137 2 - Live 0xffffffff8848f000
testmgr_cipher 35905 0 - Live 0xffffffff88485000
testmgr 88305 1 testmgr_cipher, Live 0xffffffff8846e000
aead 42049 1 testmgr, Live 0xffffffff88462000
crypto_blkcipher 48449 1 testmgr, Live 0xffffffff88455000
crypto_algapi 54849 3 testmgr,aead,crypto_blkcipher, Live =
0xffffffff88446000
crypto_api 42945 5 =
xfrm_nalgo,testmgr,aead,crypto_blkcipher,crypto_algapi, Live =
0xffffffff8843a000
arc4 35008 2 - Live 0xffffffff8842e000
snd_seq_dummy 37061 0 - Live 0xffffffff88423000
iwlagn 150337 0 - Live 0xffffffff883fd000
snd_seq_oss 65472 0 - Live 0xffffffff883ec000
snd_seq_midi_event 41025 1 snd_seq_oss, Live 0xffffffff883e0000
snd_seq 87777 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live =
0xffffffff883c9000
snd_seq_device 41557 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live =
0xffffffff883bd000
snd_pcm_oss 77377 0 - Live 0xffffffff883a9000
snd_mixer_oss 49985 1 snd_pcm_oss, Live 0xffffffff8839b000
iwlcore 152645 1 iwlagn, Live 0xffffffff88374000
snd_pcm 116681 3 snd_hda_intel,snd_pcm_oss, Live 0xffffffff88356000
snd_timer 57161 3 snd_seq,snd_pcm, Live 0xffffffff88347000
snd_page_alloc 44113 2 snd_hda_intel,snd_pcm, Live 0xffffffff8833b000
mac80211 183745 2 iwlagn,iwlcore, Live 0xffffffff8830d000
snd_hwdep 43593 1 snd_hda_intel, Live 0xffffffff88301000
ftdi_sio 68553 0 - Live 0xffffffff882ef000
hci_usb 51293 0 - Live 0xffffffff882df000
sg 70377 0 - Live 0xffffffff882cc000
cfg80211 191369 3 iwlagn,iwlcore,mac80211, Live 0xffffffff8829c000
joydev 43969 0 - Live 0xffffffff88290000
e1000e 161057 0 - Live 0xffffffff88265000
snd 100073 11 =
snd_hda_intel,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_os=
s,snd_pcm,snd_timer,snd_hwdep, Live 0xffffffff8824b000
ide_cd 73825 0 - Live 0xffffffff88237000
sdhci 52441 0 - Live 0xffffffff88229000
i2c_i801 41813 0 - Live 0xffffffff8821d000
usbserial 67377 1 ftdi_sio, Live 0xffffffff8820b000
mmc_core 59969 1 sdhci, Live 0xffffffff881fb000
i2c_core 56641 2 i2c_ec,i2c_i801, Live 0xffffffff881ec000
bluetooth 118853 3 hidp,l2cap,hci_usb, Live 0xffffffff881cd000
rfkill 51673 1 cfg80211, Live 0xffffffff881bf000
cdrom 68713 1 ide_cd, Live 0xffffffff881ad000
soundcore 41825 1 snd, Live 0xffffffff881a1000
shpchp 70893 0 - Live 0xffffffff8818e000
serio_raw 40517 0 - Live 0xffffffff88183000
pcspkr 36289 0 - Live 0xffffffff88179000
wireless_compat 34753 2 cfg80211,rfkill, Live 0xffffffff8816f000
dm_raid45 99657 0 - Live 0xffffffff88155000
dm_message 36289 1 dm_raid45, Live 0xffffffff8814b000
dm_region_hash 46145 1 dm_raid45, Live 0xffffffff8813e000
dm_log 44993 3 dm_mirror,dm_raid45,dm_region_hash, Live =
0xffffffff88132000
dm_mod 101649 4 dm_mirror,dm_multipath,dm_raid45,dm_log, Live =
0xffffffff88118000
dm_mem_cache 38977 1 dm_raid45, Live 0xffffffff8810d000
ata_piix 56901 0 - Live 0xffffffff880fe000
ahci 69705 3 - Live 0xffffffff880eb000
libata 209489 2 ata_piix,ahci, Live 0xffffffff880b6000
sd_mod 56513 4 - Live 0xffffffff880a7000
scsi_mod 196953 4 scsi_dh,sg,libata,sd_mod, Live 0xffffffff88075000
ext3 168913 2 - Live 0xffffffff8804a000
jbd 94769 1 ext3, Live 0xffffffff88031000
uhci_hcd 57433 0 - Live 0xffffffff88021000
ohci_hcd 56309 0 - Live 0xffffffff88012000
ehci_hcd 66125 0 - Live 0xffffffff88000000


[7.4.] Loaded driver and hardware information (/proc/ioports, =
/proc/iomem)
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
01f0-01f7 : ide0
03c0-03df : vga+
03f6-03f6 : ide0
1000-107f : motherboard
  1000-1003 : ACPI PM1a_EVT_BLK
  1004-1005 : ACPI PM1a_CNT_BLK
  1008-100b : ACPI PM_TMR
  1010-1015 : ACPI CPU throttle
  1020-1020 : ACPI PM2_CNT_BLK
  1028-102f : ACPI GPE0_BLK
1180-11bf : motherboard
15e0-15ef : motherboard
164e-164f : motherboard
1800-180f : 0000:00:03.2
1810-1813 : 0000:00:03.2
1814-1817 : 0000:00:03.2
1818-181f : 0000:00:03.2
1820-1827 : 0000:00:03.2
1828-182f : 0000:00:03.3
  1828-182f : serial
1830-183f : 0000:00:1f.1
  1830-1837 : ide0
1840-185f : 0000:00:19.0
1860-187f : 0000:00:1a.0
  1860-187f : uhci_hcd
1880-189f : 0000:00:1a.1
  1880-189f : uhci_hcd
18a0-18bf : 0000:00:1d.0
  18a0-18bf : uhci_hcd
18c0-18df : 0000:00:1d.1
  18c0-18df : uhci_hcd
18e0-18ff : 0000:00:1d.2
  18e0-18ff : uhci_hcd
1c18-1c1b : 0000:00:1f.2
1c1c-1c1f : 0000:00:1f.2
1c20-1c3f : 0000:00:1f.2
1c40-1c47 : 0000:00:1f.2
1c48-1c4f : 0000:00:1f.2
1c60-1c7f : 0000:00:1f.3
  1c60-1c7f : i801_smbus
2000-2fff : PCI Bus #01
  2000-207f : 0000:01:00.0
3000-3fff : PCI Bus #02
4000-4fff : PCI Bus #03
5000-5fff : PCI Bus #04
6000-6fff : PCI Bus #05
7000-7fff : PCI Bus #0d
8000-bfff : PCI Bus #15
  8000-80ff : PCI CardBus #16
  8400-84ff : PCI CardBus #16

00010000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cf1ff : Video ROM
000cf800-000d07ff : Adapter ROM
000d0800-000d17ff : Adapter ROM
000d2000-000d3fff : reserved
000f0000-000fffff : System ROM
00100000-bfeaffff : System RAM
  00200000-0048472c : Kernel code
  0048472d-005cac67 : Kernel data
bfeb0000-bfecbfff : ACPI Tables
bfecc000-bfefffff : ACPI Non-volatile Storage
bff00000-bfffffff : reserved
cc000000-cdffffff : PCI Bus #0d
d0000000-d1ffffff : PCI Bus #05
d4000000-d6ffffff : PCI Bus #01
  d4000000-d5ffffff : 0000:01:00.0
  d6000000-d6ffffff : 0000:01:00.0
d8000000-d9ffffff : PCI Bus #04
dc100000-df2fffff : PCI Bus #03
  df2fe000-df2fffff : 0000:03:00.0
    df2fe000-df2fffff : iwlagn
df400000-df4fffff : PCI Bus #0d
df700000-df7fffff : PCI Bus #05
dfa00000-dfafffff : PCI Bus #04
dfd00000-dfdfffff : PCI Bus #03
e0000000-efffffff : PCI Bus #01
  e0000000-efffffff : 0000:01:00.0
f0000000-f3ffffff : reserved
f4000000-f7ffffff : PCI Bus #15
  f4000000-f5ffffff : PCI CardBus #16
f8000000-f80fffff : PCI Bus #02
f8100000-fbffffff : PCI Bus #15
  f8100000-f8100fff : 0000:15:00.0
    f8100000-f8100fff : yenta_socket
  f8101000-f81017ff : 0000:15:00.1
  f8101800-f81018ff : 0000:15:00.2
    f8101800-f81018ff : sdhci:slot0
  f8101c00-f8101cff : 0000:15:00.3
  f8102000-f81020ff : 0000:15:00.4
  f8102400-f81024ff : 0000:15:00.5
  f84f0000-f84f0fff : pcmcia_socket0
  f84f1000-f84f1fff : pcmcia_socket0
  f84f2000-f84f3fff : pcmcia_socket0
  fa000000-fbffffff : PCI CardBus #16
fc000000-fdffffff : PCI Bus #02
fe200000-fe21ffff : 0000:00:19.0
  fe200000-fe21ffff : e1000e
fe220000-fe223fff : 0000:00:1b.0
  fe220000-fe223fff : ICH HD audio
fe224000-fe224fff : 0000:00:03.3
fe225000-fe225fff : 0000:00:19.0
  fe225000-fe225fff : e1000e
fe226000-fe2267ff : 0000:00:1f.2
  fe226000-fe2267ff : ahci
fe226800-fe22680f : 0000:00:03.0
fe226c00-fe226fff : 0000:00:1a.7
  fe226c00-fe226fff : ehci_hcd
fe227000-fe2273ff : 0000:00:1d.7
  fe227000-fe2273ff : ehci_hcd
fe227400-fe2274ff : 0000:00:1f.3
fec00000-fec0ffff : reserved
fed00000-fed003ff : reserved
fed14000-fed19fff : reserved
fed1c000-fed8ffff : reserved
fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
100000000-13bffffff : System RAM


[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory =
Controller Hub (rev 0c)
	Subsystem: Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information

00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI =
Express Root Port (rev 0c) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: d4000000-d6ffffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000eff00000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [88] #0d [0000]
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [90] Message Signalled Interrupts: 64bit- Queue=3D0/0 =
Enable+
		Address: fee00000  Data: 40d9
	Capabilities: [a0] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 2
		Link: Latency L0s <256ns, L1 <4us
		Link: ASPM L0s Enabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise-
		Slot: Number 1, PowerLimit 75.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [140] Unknown (5)

00:03.0 Communication controller: Intel Corporation Mobile PM965/GM965 =
MEI Controller (rev 0c)
	Subsystem: Lenovo Unknown device 20cd
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fe226800 (64-bit, non-prefetchable) [size=3D16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [8c] Message Signalled Interrupts: 64bit+ Queue=3D0/0 =
Enable-
		Address: 0000000000000000  Data: 0000

00:03.2 IDE interface: Intel Corporation Mobile PM965/GM965 PT IDER =
Controller (rev 0c) (prog-if 85 [Master SecO PriO])
	Subsystem: Lenovo Unknown device 20cf
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 11
	Region 0: I/O ports at 1820 [disabled] [size=3D8]
	Region 1: I/O ports at 1814 [disabled] [size=3D4]
	Region 2: I/O ports at 1818 [disabled] [size=3D8]
	Region 3: I/O ports at 1810 [disabled] [size=3D4]
	Region 4: I/O ports at 1800 [disabled] [size=3D16]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=3D0/0 =
Enable-
		Address: 0000000000000000  Data: 0000

00:03.3 Serial controller: Intel Corporation Mobile PM965/GM965 KT =
Controller (rev 0c) (prog-if 02 [16550])
	Subsystem: Lenovo Unknown device 20d0
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 74
	Region 0: I/O ports at 1828 [size=3D8]
	Region 1: Memory at fe224000 (32-bit, non-prefetchable) [size=3D4K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=3D0/0 =
Enable-
		Address: 0000000000000000  Data: 0000

00:19.0 Ethernet controller: Intel Corporation 82566MM Gigabit Network =
Connection (rev 03)
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 138
	Region 0: Memory at fe200000 (32-bit, non-prefetchable) [size=3D128K]
	Region 1: Memory at fe225000 (32-bit, non-prefetchable) [size=3D4K]
	Region 2: I/O ports at 1840 [size=3D32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=3D0/0 =
Enable+
		Address: 00000000fee01000  Data: 408a

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI =
Controller #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 177
	Region 4: I/O ports at 1860 [size=3D32]

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI =
Controller #5 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T60
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 185
	Region 4: I/O ports at 1880 [size=3D32]

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI =
Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 193
	Region 0: Memory at fe226c00 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio =
Controller (rev 03)
	Subsystem: Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 122
	Region 0: Memory at fe220000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=3D0/0 =
Enable+
		Address: 00000000fee01000  Data: 407a
	Capabilities: [70] Express Unknown type IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM Disabled CommClk- ExtSynch-
		Link: Speed unknown, Width x0
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Unknown (5)

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express =
Port 1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: fc000000-fdffffff
	Prefetchable memory behind bridge: 00000000f8000000-00000000f8000000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x0
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 2, PowerLimit 6.500000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=3D0/0 =
Enable+
		Address: fee00000  Data: 40e1
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express =
Port 2 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: dc100000-df2fffff
	Prefetchable memory behind bridge: 00000000dfd00000-00000000dfd00000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
		Link: Latency L0s <256ns, L1 <4us
		Link: ASPM L0s L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 3, PowerLimit 6.500000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=3D0/0 =
Enable+
		Address: fee00000  Data: 40e9
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express =
Port 3 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=3D0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: d8000000-d9ffffff
	Prefetchable memory behind bridge: 00000000dfa00000-00000000dfa00000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 3
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x0
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 4, PowerLimit 6.500000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=3D0/0 =
Enable+
		Address: fee00000  Data: 4032
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express =
Port 4 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D05, subordinate=3D0c, sec-latency=3D0
	I/O behind bridge: 00006000-00006fff
	Memory behind bridge: d0000000-d1ffffff
	Prefetchable memory behind bridge: 00000000df700000-00000000df700000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 4
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x0
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 5, PowerLimit 6.500000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=3D0/0 =
Enable+
		Address: fee00000  Data: 403a
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express =
Port 5 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D0d, subordinate=3D14, sec-latency=3D0
	I/O behind bridge: 00007000-00007fff
	Memory behind bridge: cc000000-cdffffff
	Prefetchable memory behind bridge: 00000000df400000-00000000df400000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 5
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x0
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 2, PowerLimit 6.500000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=3D0/0 =
Enable+
		Address: fee00000  Data: 4042
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI =
Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 169
	Region 4: I/O ports at 18a0 [size=3D32]

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI =
Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 74
	Region 4: I/O ports at 18c0 [size=3D32]

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI =
Controller #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 90
	Region 4: I/O ports at 18e0 [size=3D32]

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI =
Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 82
	Region 0: Memory at fe227000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) =
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=3D00, secondary=3D15, subordinate=3D18, sec-latency=3D32
	I/O behind bridge: 00008000-0000bfff
	Memory behind bridge: f8100000-fbffffff
	Prefetchable memory behind bridge: 00000000f4000000-00000000f7f00000
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] #0d [0000]

00:1f.0 ISA bridge: Intel Corporation 82801HBM (ICH8M-E) LPC Interface =
Controller (rev 03)
	Subsystem: Lenovo T61
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) =
IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 169
	Region 0: I/O ports at <unassigned>
	Region 1: I/O ports at <unassigned>
	Region 2: I/O ports at <unassigned>
	Region 3: I/O ports at <unassigned>
	Region 4: I/O ports at 1830 [size=3D16]

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) =
SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 98
	Region 0: I/O ports at 1c48 [size=3D8]
	Region 1: I/O ports at 1c1c [size=3D4]
	Region 2: I/O ports at 1c40 [size=3D8]
	Region 3: I/O ports at 1c18 [size=3D4]
	Region 4: I/O ports at 1c20 [size=3D32]
	Region 5: Memory at fe226000 (32-bit, non-prefetchable) [size=3D2K]
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=3D0/2 =
Enable+
		Address: fee01000  Data: 4062
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [a8] #12 [0010]

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller =
(rev 03)
	Subsystem: Lenovo ThinkPad T61
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 201
	Region 0: Memory at fe227400 (32-bit, non-prefetchable) [size=3D256]
	Region 4: I/O ports at 1c60 [size=3D32]

01:00.0 VGA compatible controller: nVidia Corporation Quadro FX 570M =
(rev a1) (prog-if 00 [VGA controller])
	Subsystem: Lenovo ThinkPad T61p
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d6000000 (32-bit, non-prefetchable) [size=3D16M]
	Region 1: Memory at e0000000 (64-bit, prefetchable) [size=3D256M]
	Region 3: Memory at d4000000 (64-bit, non-prefetchable) [size=3D32M]
	Region 5: I/O ports at 2000 [size=3D128]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [68] Message Signalled Interrupts: 64bit+ Queue=3D0/0 =
Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s <512ns, L1 <4us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
		Link: Latency L0s <512ns, L1 <4us
		Link: ASPM L0s Enabled RCB 128 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
	Capabilities: [100] Virtual Channel
	Capabilities: [128] Power Budgeting
	Capabilities: [600] Unknown (11)

03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or =
AGN [Kedron] Network Connection (rev 61)
	Subsystem: Intel Corporation Lenovo ThinkPad T51
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR+ <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 114
	Region 0: Memory at df2fe000 (64-bit, non-prefetchable) [size=3D8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA =
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=3D0/0 =
Enable+
		Address: 00000000fee00000  Data: 4072
	Capabilities: [e0] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 unlimited
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
		Link: Latency L0s <128ns, L1 <64us
		Link: ASPM L0s L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 0d-e8-41-ff-ff-e0-1d-00

15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
	Subsystem: Lenovo Unknown device 20c6
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 168
	Interrupt: pin A routed to IRQ 169
	Region 0: Memory at f8100000 (32-bit, non-prefetchable) [size=3D4K]
	Bus: primary=3D15, secondary=3D16, subordinate=3D17, sec-latency=3D176
	Memory window 0: f4000000-f5fff000 (prefetchable)
	Memory window 1: fa000000-fbfff000
	I/O window 0: 00008000-000080ff
	I/O window 1: 00008400-000084ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
	16-bit legacy interface ports at 0001

15:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller =
(rev 04) (prog-if 10 [OHCI])
	Subsystem: Lenovo Unknown device 20c7
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (500ns min, 1000ns max)
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at f8101000 (32-bit, non-prefetchable) [size=3D2K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro =
Host Adapter (rev 21)
	Subsystem: Lenovo Unknown device 20c8
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin C routed to IRQ 90
	Region 0: Memory at f8101800 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

15:00.3 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev =
11)
	Subsystem: Lenovo Unknown device 20c9
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f8101c00 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

15:00.4 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host =
Adapter (rev 11)
	Subsystem: Lenovo ThinkPad T61
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f8102000 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

15:00.5 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev =
11)
	Subsystem: Lenovo Unknown device 20cb
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at f8102400 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA =
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-


[7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST9160823AS      Rev: 3.CM
  Type:   Direct-Access                    ANSI SCSI revision: 05


[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
- I boot with 'noirqdebug' option because I was receiving a message
   'irq 169: nobody cared (try booting with the "irqpoll" option)
    Disabling IRQ #169'
  and from that point in time the USB was unusable (e.g. mouse jumpy)
  Investigation gaves IRQ 169 being shared between the 1553 card and the =
USB
- I am using a 'serial to USB' adapter at the same time for test =
purposes
  model UC232R-10 ES-U-1001-B10 from FTDI Chip Technology =
(www.ftdichip.com)
  That hardware was immediately recognised by the kernel the first time =
I plugged it on the laptop
  It seems to work well most of the time, but I suspect delay on the =
line and some lost bytes from time to time because of the messages of my =
test equipment (no such delays or lost bytes on laptop with native =
serial HW)
  The kernel panic is far more often created when heavy traffic is =
ongoing on the serial link.


[X.] Other notes, patches, fixes, workarounds:
None.


Any clue to help me (what to look at, list of probable causes, ...)? =
Thanks in advance.

Best regards,

Guy L=E9onis=20




Spacebel                    Tel   : +32-26 58 20 27=20
I. Vandammestraat 7 bus 1   Fax   : +32-26 58 20 90=20
B-1560 Hoeilaart            email : Guy.Leonis@spacebel.be=20
BELGIUM
=20

------_=_NextPart_001_01CBCC65.39F68399
Content-Type: application/octet-stream;
	name="pcmace.h"
Content-Transfer-Encoding: base64
Content-Description: pcmace.h
Content-Disposition: attachment;
	filename="pcmace.h"

LyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqCiogIEZpbGUgTmFtZSA6IHBjbWFjZS5oCioKKiAgUHJvamVjdDog
IEFjZSBCVTY1NTV4TTItMzAwIFBDTUNJQSBpbnRlcmZhY2UgZHJpdmVyIGZvciBMaW51eCAKKgoq
IENvcHlyaWdodCAoQykgMjAwNCBieSBJTEMgRGF0YSBEZXZpY2UgQ29ycC4KKiBBbGwgUmlnaHRz
IFJlc2VydmVkLgoqCioKKiAgQ29tbWVudHM6CiogICAgICAgICAgICBNYWtlIHdpdGhpbiB0aGUg
TGludXggQ2FyZCBTZXJ2aWNlcyBwYWNrYWdlCiogICAgICAgICAgICB1c3Ivc3JjL2xpbnV4L3Bj
bWNpYS1jcy14Lnkuei9jbGllbnRzCiogICAgICAgICAgICBJZ25vcmUgd2FyaW5pbmcgZm9yIC5t
b2RpbmZvIChub3QgaW1wbGVtZW50ZWQpCiogICAgICAgICAgICBTZWUgcmVhZG1lLnR4dAoqCiog
IFRlc3RlZCBLZXJuZWwgVmVyc2lvbnM6CiogICAgICAgICAgIDIuNi4xOAoqCiogIFJldmlzaW9u
IEhpc3RvcnkKKiAgICAgRGF0ZSAgICAgICAgIE5hbWUgICAgICAgICBWZXJzaW9uICAgICBEZXNj
cmlwdGlvbgoqLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KKiAgMTgtQXByLTIwMDEgICAgR2FyeSBEYXZpZXMg
ICAgICAgMS4wICAgICAgIE9yaWdpbmFsCiogIDA0LU1hci0yMDAxICAgIE1hcmsgRmluZGxhdGVy
ICAgIDEuMSAgICAgICBBZGRlZCAjZGVmaW5lcyBmb3IgcmVnaXN0ZXJzCiogIDA3LURlYy0yMDA0
ICAgIEVTSyAgICAgICAgICAgICAgIDEuMiAgICAgICBBZGRlZCBLZXJuZWwgdmVyc2lvbiBjaGVj
a3MgZm9yCiogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZXBy
ZWNhdGVkL2NoYW5nZWQgZnVuY3Rpb25zCiogIDA3LURlYy0yMDEwICAgIEdMUyAgICAgICAgICAg
ICAgIDIuMCAgICAgICBQb3J0ZWQgdG8gMi42LjE4IGtlcm5lbHMKKiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIChhbmQgZGVsZXRlZCBhbGwgb2xkIHN0dWZmKQoq
CioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKi8KCiNpZm5kZWYgIF9QQ01BQ0VfSF8KI2RlZmluZSAgX1BDTUFD
RV9IXwoKI2luY2x1ZGUgPGxpbnV4L3ZlcnNpb24uaD4KI2lmIExJTlVYX1ZFUlNJT05fQ09ERSA8
IEtFUk5FTF9WRVJTSU9OKDIsNiwxOCkKI2Vycm9yIHVuc3VwcG9ydGVkIGtlcm5lbCB2ZXJzaW9u
IQojZW5kaWYKCiNpbmNsdWRlIDxwY21jaWEvc3MuaD4KI2luY2x1ZGUgPHBjbWNpYS9jc190eXBl
cy5oPgojaW5jbHVkZSA8cGNtY2lhL2Npc3RwbC5oPgojaW5jbHVkZSA8cGNtY2lhL2NzLmg+CiNp
bmNsdWRlIDxwY21jaWEvZHMuaD4KCgojaWZkZWYgX19LRVJORUxfXyAvKiBUaGlzIHNlY3Rpb24g
Zm9yIGtlcm5lbCBzcGVjaWZpYyBjb2RlIG9ubHkuICovCgoKI2lmbmRlZiBERUNMQVJFX1dBSVRf
UVVFVUVfSEVBRAp0eXBlZGVmICBzdHJ1Y3Qgd2FpdF9xdWV1ZSAqd2FpdF9xdWV1ZV9oZWFkX3Q7
CiNkZWZpbmUgaW5pdF93YWl0cXVldWVfaGVhZChoZWFkKSAgICAgICAgKCooaGVhZCkpID0gTlVM
TAojZW5kaWYgLyogISBERUNMQVJFX1dBSVRfUVVFVUVfSEVBRCAqLwoKCiNkZWZpbmUgVk1BX09G
RlNFVCh2bWEpICAgICAgICAgICAgICAgICgodm1hKS0+dm1fcGdvZmYgPDwgUEFHRV9TSElGVCkK
CgojZGVmaW5lIGNsaSgpICAgICAgICAgICAgbG9jYWxfaXJxX2Rpc2FibGUoKQojZGVmaW5lIHN0
aSgpICAgICAgICAgICAgbG9jYWxfaXJxX2VuYWJsZSgpCiNkZWZpbmUgc2F2ZV9mbGFncyh4KSAg
ICAgICAgbG9jYWxfc2F2ZV9mbGFncyh4KQojZGVmaW5lIHJlc3RvcmVfZmxhZ3MoeCkgICAgbG9j
YWxfaXJxX3Jlc3RvcmUoeCkgICAgCgoKI2VuZGlmIC8qIF9fS0VSTkVMX18gKi8KCgovKiBOYW1l
IG9mIHRoZSBsb2FkYWJsZSBtb2R1bGUgZm9yIGludGVybmFsIHVzZS4gKi8KI2RlZmluZSBNT0RV
TEVfTkFNRSAgICAicGNtYWNlIgoKLyogU2l6ZSBvZiB0aGUgdHVwbGUgYnVmZmVyIGluIGJ5dGVz
ICovCi8qIEl0IG11c3QgYmUgYmlnIGVub3VnaCB0byBob2xkIEREQyBjYXJkIHR1cGxlcyAqLwov
KiBUaGUgQlVfNjU1NThNMl8zMDAgY2FyZCBjb250YWlucyBsb25nIHR1cGxlcyAqLwovKiBBIHNp
emUgZ3JlYXRlciB0aGFuIDI1NSBzZWVtcyB0byBjb3JydXB0cyB0aGUgdHVwbGUgZGF0YSAqLyAK
I2RlZmluZSBUVVBMRV9CVUZGRVJfU0laRSAyNTUKCi8qIENhcmQgaWRlbnRpZmllcnMgKi8KLyog
VmFsdWVzIG11c3Qgbm90IGV4Y2VlZCBNQVhfTlVNX0tOT1dOX0NBUkRTICovCi8qIEluY3JlYXNl
IHRoZSB2YWx1ZSBvZiBNQVhfTlVNX0tOT1dOX0NBUkRTIGlmIG1vcmUgY2FyZHMgYXJlIGFkZGVk
ICovCiNkZWZpbmUgREVWSURfU1RSSU5HTkRYX0JVNjU1NTBNMl8zMDAgICAgIDAKI2RlZmluZSBE
RVZJRF9TVFJJTkdORFhfQlU2NTU1ME0yXzYwMiAgICAgMQojZGVmaW5lIERFVklEX1NUUklOR05E
WF9CVTY1NTUxTTJfMzAwICAgICAyCiNkZWZpbmUgREVWSURfU1RSSU5HTkRYX0JVNjU1NTJNMl8z
MDAgICAgIDMKI2RlZmluZSBERVZJRF9TVFJJTkdORFhfQlU2NTU1M00yXzMwMCAgICAgNAojZGVm
aW5lIERFVklEX1NUUklOR05EWF9CVTY1NTUwTTJfNjA1ICAgICA1CgojZGVmaW5lIERFVklEX0JV
NjU1NTBNMl8zMDAgICAgIDB4NjU1NTAyMzAKI2RlZmluZSBERVZJRF9CVTY1NTUwTTJfNjAyICAg
ICAweDY1NTUwMjYyCiNkZWZpbmUgREVWSURfQlU2NTU1MU0yXzMwMCAgICAgMHg2NTU1MTIzMAoj
ZGVmaW5lIERFVklEX0JVNjU1NTJNMl8zMDAgICAgIDB4NjU1NTIyMzAKI2RlZmluZSBERVZJRF9C
VTY1NTUzTTJfMzAwICAgICAweDY1NTUzMjMwCiNkZWZpbmUgREVWSURfQlU2NTU1ME0yXzYwNSAg
ICAgMHg2NTU1MDI2NQoKI2RlZmluZSBVTktOT1dOX0NBUkQgICAgICAgOTkKCi8qIERyaXZlciB2
ZXJzaW9uLiAqLwojZGVmaW5lIEFDRTUzX1ZFUiAgICAgICAgICAgIDEKI2RlZmluZSBBQ0U1M19S
RVYgICAgICAgICAgICAxCiNkZWZpbmUgQUNFNTNfUkVMICAgICAgICAgICAgMgojZGVmaW5lIEFD
RTUzX1ZFUlNJT04gICAgICAgIChBQ0U1M19WRVI8PDE2KSB8IChBQ0U1M19SRVY8PDgpIHwgQUNF
NTNfUkVMCiNkZWZpbmUgQUNFNTNfVkVSU0lPTl9TVFJJTkcgIjEuMS4yIgoKLyogTWF4aW11bSBu
dW1iZXIgb2YgY2FyZHMgc3VwcG9ydGVkLiAqLwojZGVmaW5lIEFDRTUzX01BWF9OVU1fQ0FSRFMg
ICAgICAzMgojZGVmaW5lIEFDRTUzX05VTV9DSEFOU19QRVJfQ0FSRCAgMQojZGVmaW5lIEFDRTUz
X01BWF9OVU1fREVWSUNFUyAgICAzMgojZGVmaW5lIEFDRTUzX01BWF9OVU1fQ0hBTlMgICAgICAz
MgojZGVmaW5lIEFDRTUzX01BWF9OVU1fV0lORE9XUyAgICA2NAojZGVmaW5lIEFDRTUzX01BWF9O
VU1fS05PV05fQ0FSRFMgNgoKLyogTGludXgga2VybmVsIGRyaXZlciByZWZlcmVuY2UgbnVtYmVy
LiAqLwojZGVmaW5lIE1BR0lDX05VTSAgMHhERAoKLyogTnVtYmVyIG9mIHdpbmRvd3MgJ21tYXAn
cGVkIHRvIHVzZXIgc3BhY2UuICovCiNkZWZpbmUgQUNFNTNfTUFYX1VTRVJfTUVNX1dJTkRPV1Mg
IDIgICAgLyogU2hhcmVkIGFuZCBGSUZPIHdpbmRvd3Mgb25seS4gKi8KCi8qIE1lbW9yeSBzaXpl
IG9mIHNoYXJlZCBhbmQgRklGTyB3aW5kb3dzLCAoUGFyYW1ldGVyIGZvciAnbW1hcCcgbWV0aG9k
KS4gKi8KI2RlZmluZSBBQ0U1M19DSEFOX01FTV9MRU5HVEggICAweDIwMDAgICAvKiAzMmsgYnl0
ZSB3aW5kb3cuICAgNjRLIHdvcmQgY2FyZCBoYXMgNCBwYWdlcy4gKi8KI2RlZmluZSBBQ0U1M19D
SEFOX1JFR19MRU5HVEggICAweDEwMDAgICAvKiAxMjggYnl0ZXMgID0gNjQgd29yZHMgPSA8NGsg
Ki8KCi8qIENhc2Ugc3RhdGVtZW50IGxhYmVscyBmb3IgRGV2aWNlSW9Db250cm9sIGNhbGxzICov
CiNkZWZpbmUgSU9DVExfQUNFNTNfR0VUX1ZFUlNJT04gICAgICAgICAgIF9JT1IoTUFHSUNfTlVN
LCAxLCB2b2lkICopCiNkZWZpbmUgSU9DVExfQUNFNTNfR0VUX0NBUkRfSU5GTyAgICAgICAgIF9J
T1IoTUFHSUNfTlVNLCAyLCB2b2lkICopCiNkZWZpbmUgSU9DVExfQUNFNTNfR0VUX0NIQU5ORUxf
SU5GTyAgICAgIF9JT1IoTUFHSUNfTlVNLCAzLCB2b2lkICopICAgIAojZGVmaW5lIElPQ1RMX0FD
RTUzX0JMT0NLX0lOX0RSSVZFUiAgICAgICBfSU9SKE1BR0lDX05VTSwgNCwgdm9pZCAqKQojZGVm
aW5lIElPQ1RMX0FDRTUzX0JDX0FVVE9fRkxJUFNUSyAgICAgICBfSU9SKE1BR0lDX05VTSwgNSwg
dm9pZCAqKQojZGVmaW5lIElPQ1RMX0FDRTUzX0lOU1RBTExfSVJRICAgICAgICAgICBfSU8oTUFH
SUNfTlVNLCA2KQojZGVmaW5lIElPQ1RMX0FDRTUzX1VOSU5TVEFMTF9JUlEgICAgICAgICBfSU8o
TUFHSUNfTlVNLCA3KQoKLyogQWNlIFJlZ2lzdGVycyAqLyAgLypqbWYgQWRkZWQgdG8gcmVtb3Zl
IGhhcmQgY29kZWQgcmVnaXN0ZXIgYWRkcmVzc2VzICovCiNkZWZpbmUgQUNFNTNfR0xPQkFMX1JF
R0lTVEVSICAgICAgICAgICAgIDB4MDgwMAojZGVmaW5lIEFDRTUzX0lOVEVSUlVQVF9NQVNLX1JF
R0lTVEVSICAgICAweDAwMDAKI2RlZmluZSBBQ0U1M19DT05GSUdfUkVHSVNURVJfMSAgICAgICAg
ICAgMHgwMDAyCiNkZWZpbmUgQUNFNTNfQ09ORklHX1JFR0lTVEVSXzIgICAgICAgICAgIDB4MDAw
NAojZGVmaW5lIEFDRTUzX1NUQVJUX1JFU0VUX1JFR0lTVEVSICAgICAgICAweDAwMDYKI2RlZmlu
ZSBBQ0U1M19JTlRFUlJVUFRfU1RBVFVTX1JFR0lTVEVSICAgMHgwMDBDCgovKiBEcml2ZXIgY2Fs
bCByZXR1cm4gdmFsdWVzLiAqLwojZGVmaW5lICAgIFNUQVRVU19BQ0U1M19TVUNDRVNTICAgICAg
ICAgICAgICAgICAgICAgKGludCkwCgovKiBJbml0aWFsaXphdGlvbiBwcm9ibGVtcy4gIFRoZXNl
IHZhbHVlcyBhcmUgcmV0dXJuZWQgdG8gdGhlICdpbnNtb2QnIHV0aWxpdHkuICovCi8qIEl0IHdp
bGwgaW5kaWNhdGUgJ0RldmljZSBvciByZXNvdXJjZSBidXN5JyBpZiBpbml0aWFsaXphdGlvbiBm
YWlscy4gICAgICAgKi8KI2RlZmluZSAgICAgU1RBVFVTX0FDRTUzX0lOSVRfVE9PX01BTllfUENJ
X0NBUkRTICAgIChpbnQpLTEwMgoKLyogR2VuZXJhbCAnb3BlbicgYW5kICdjbG9zZScgcHJvYmxl
bXMuICovCiNkZWZpbmUgICAgU1RBVFVTX0FDRTUzX0RFVklDRV9OT1RfRVhJU1QgICAgICAgICAg
ICAoaW50KS0yMDAKI2RlZmluZSAgICBTVEFUVVNfQUNFNTNfQ0FSRF9BTFJFQURZX09QRU4gICAg
ICAgICAgIChpbnQpLTIwMQojZGVmaW5lICAgIFNUQVRVU19BQ0U1M19DQVJEX05PVF9PUEVOICAg
ICAgICAgICAgICAgKGludCktMjAyCiNkZWZpbmUgICAgU1RBVFVTX0FDRTUzX0NBUkRfSU1QUk9Q
RVJMWV9DTE9TRUQgICAgICAoaW50KS0yMDMKI2RlZmluZSAgICBTVEFUVVNfQUNFNTNfUENNQ0lB
Q0ZHX1JFTUFQX0ZBSUwgICAgICAgIChpbnQpLTIwNAojZGVmaW5lIFNUQVRVU19BQ0U1M19DSEFO
TkVMX05PVF9BVkFJTEFCTEUgICAgICAgICAgKGludCktMjA1CgovKiAnaW9jdGwnIGNhbGwgcHJv
YmxlbXMuICovCiNkZWZpbmUgICAgU1RBVFVTX0FDRTUzX0lPQ1RMX05PVF9JTVBMRU1FTlRFRCAg
ICAgICAoaW50KS0yMTAKI2RlZmluZSAgICBTVEFUVVNfQUNFNTNfSU9DVExfSVJRX0FMUkVBRFlf
SU5TVEFMTEVEIChpbnQpLTIxMQojZGVmaW5lIFNUQVRVU19BQ0U1M19JT0NUTF9JUlFfTk9UX0lO
U1RBTExFRCAgICAgICAgKGludCktMjEyCiNkZWZpbmUgICAgU1RBVFVTX0FDRTUzX0lPQ1RMX1JF
UVVFU1RfSVJRX0ZBSUwgICAgICAoaW50KS0yMTMKI2RlZmluZSAgICBTVEFUVVNfQUNFNTNfSU9D
VExfSU5URVJSVVBUX05PVF9FTkFCTEVEIChpbnQpLTIxNAojZGVmaW5lIFNUQVRVU19BQ0U1M19J
T0NUTF9TTEVFUF9BQ1RJVkFURUQgICAgICAgICAgKGludCktMjE1CgovKiAnbW1hcCcgY2FsbCBw
cm9ibGVtcy4gKi8KI2RlZmluZSAgICBTVEFUVVNfQUNFNTNfTU1BUF9DQVJEX0FMUkVBRFlfTU1B
UFBFRCAgIChpbnQpLTIyMAojZGVmaW5lICAgIFNUQVRVU19BQ0U1M19NTUFQX1NFUVVFTkNFX0VS
Uk9SICAgICAgICAgKGludCktMjIxCiNkZWZpbmUgICAgU1RBVFVTX0FDRTUzX01NQVBfSU5WQUxJ
RF9XSU5ET1dfU0laRSAgICAoaW50KS0yMjIKI2RlZmluZSAgICBTVEFUVVNfQUNFNTNfTU1BUF9J
TlZBTElEX1BBR0VfU0laRSAgICAgIChpbnQpLTIyMwojZGVmaW5lICAgIFNUQVRVU19BQ0U1M19N
TUFQX0JBRF9BTElHTk1FTlQgICAgICAgICAgKGludCktMjI0CiNkZWZpbmUgICAgU1RBVFVTX0FD
RTUzX01NQVBfUkVNQVBfRkFJTCAgICAgICAgICAgICAoaW50KS0yMjUKCi8qIERlZmluZXMgYW5k
IHR5cGVkZWYncy4gKi8KI2RlZmluZSBEV09SRCB1bnNpZ25lZCBpbnQKCi8qIENhcmQgQWNjZXNz
IFZhcmlhYmxlIFR5cGVzICovCiNpZm5kZWYgVFlQRVMKdHlwZWRlZiBzaWduZWQgY2hhciBTODsK
dHlwZWRlZiB1bnNpZ25lZCBjaGFyIFU4Owp0eXBlZGVmIHNpZ25lZCBzaG9ydCBpbnQgUzE2Owp0
eXBlZGVmIHVuc2lnbmVkIHNob3J0IGludCBVMTY7CnR5cGVkZWYgc2lnbmVkIGludCBTMzI7CnR5
cGVkZWYgdW5zaWduZWQgaW50IFUzMjsKI2VuZGlmIC8qIFRZUEVTICovCgojZGVmaW5lIFUxNkJJ
VCB1bnNpZ25lZCBzaG9ydAojZGVmaW5lIFUzMkJJVCB1bnNpZ25lZCBpbnQKCi8qIEFjZSBDSVMg
U3RydWN0dXJlICovCnR5cGVkZWYgc3RydWN0IF9BQ0U1M19DSVMKewogICAgICAgIHVfaW50ICAg
dW5NZW1vcnlTaXplOyAgIC8qIFNpemUgb2YgY2FyZCBtZW1vcnkgKDY0aykgKi8KICAgICAgICB1
X2ludCAgIHVuQWNjZXNzU3BlZWQ7ICAvKiBTcGVlZCBvZiBjYXJkIG1lbW9yeSBhY2Nlc3MgKDI1
MG5zKSAqLwogICAgICAgIHVfaW50ICAgdW5Db25maWdCYXNlOyAgIC8qIENhcmQgbWVtb3J5IENv
bmZpZyBiYXNlIG9mZnNldCAqLwogICAgICAgIHVfaW50ICAgdW5QcmVzZW50OyAgICAgIC8qIFNw
ZWNpZmllcyB0aGF0IHRoZSBDT1IgcmVnaXN0ZXIgaXMgcHJlc2VudCAqLwogICAgICAgIHVfY2hh
ciAgdWNDb25maWdJbmRleDsgIC8qIEluZGV4IHNwZWNpZnlpbmcgY2FyZCBjb25maWcgbW9kZSAq
LwogICAgICAgIGNpc3RwbF9tYW5maWRfdCBtYW5maWQ7IC8qIENhcmQgbWFudWZhY3R1cmVyIGRl
dGFpbHMgKi8KICAgICAgICBjaXN0cGxfaW9fdCBpbzsgICAgICAgICAvKiBDYXJkIGlvIHBvcnQg
cmVxdWlyZW1lbnRzICovCiAgICAgICAgY2lzdHBsX2lycV90IGlycTsgICAgICAgLyogQ2FyZCBp
cnEgcmVxdWlyZW1lbnRzICovCiAgICAgICAgY2lzdHBsX21lbV90IG1lbTsgICAgICAgLyogQ2Fy
ZCBtZW1vcnkgd2luZG93IHJlcXVpcmVtZW50cyAqLwp9IEFDRTUzX0NJUywgKnBBQ0U1M19DSVM7
CgovKiBBY2UgQ2hhbm5lbCBTdHJ1Y3R1cmUgKi8KdHlwZWRlZiBzdHJ1Y3QgX0FDRV9DSEFOTkVM
CnsKICAgIFU4ICAgYkNhcmROdW07ICAgICAgICAgLyogQ2FyZCBOdW1iZXIgWzAtM10gKi8KICAg
IFU4ICAgYkNoYW5OdW07ICAgICAgICAgLyogQ2hhbm5lbCBOdW1iZXIgWzAtMV0gKi8KICAgIFU4
ICAgYlNvY2tldE51bTsgICAgICAgLyogQ2hhbm5lbCBOdW1iZXIgWzAtMV0gKi8KICAgIFUzMiAg
ZHdNZW1XbmRVc3JBZGRyOyAgLyogTWVtb3J5IFdpbmRvd3MgaW4gVXNlciBzcGFjZSAoMSBwZXIg
Y2hhbm5lbCkgKi8KICAgIFUzMiAgZHdSZWdXbmRVc3JBZGRyOyAgLyogUmVnaXN0ZXIgV2luZG93
cyBpbiBVc2VyIHNwYWNlICgxIHBlciBjaGFubmVsKSAqLwogICAgVTMyICBkd0ludFN0YXR1czsg
ICAgICAvKiBTdGF0dXMgUmVnaXN0ZXIgb2YgdGhlIGludGVycnVwdCAqLwogICAgVTggICBiQmxv
Y2tlZDsgICAgICAgICAvKiBCbG9ja2luZyBzdGF0dXMgb2YgZHJpdmVyICovCiAgICBVOCAgIGJN
bWFwV2luTnVtOyAgICAgIC8qIG1tYXBwZWQgd2luZG93IGNvdW50ICovCiAgICBVOCAgIGJJc3JF
bmFibGVkOyAgICAgIC8qIFN0YXR1cyBvZiBkcml2ZXIgSVNSICovCiAgICBVMTYgIHdJcnE7ICAg
ICAgICAgICAgIC8qIENoYW5uZWwncyBJUlEgKi8KICAgIFU4ICAgYk9wZW47ICAgICAgICAgICAg
LyogT3BlbiBzdGF0dXMgZmxhZyBmb3IgY2hhbm5lbHMgKi8KICAgIFU4ICAgYkF1dG9GbGlwU3Rr
OyAgICAgLyogQkMgRW9mIEF1dG8gRmxpcCBTdGFjayAqLwp9IEFDRV9DSEFOTkVMLCAqcEFDRV9D
SEFOTkVMOwoKCi8qIEFjZSBDYXJkIFN0cnVjdHVyZSAqLwp0eXBlZGVmIHN0cnVjdCBfQUNFNTNf
Q0FSRAp7CiAgICBzdHJ1Y3QgcGNtY2lhX2RldmljZSAqcGxpbms7ICAgICAgICAgICAvKiBQQ01D
SUEgZGV2aWNlICovCiAgICBVOCAgICAgICAgICAgICAgICAgYlBjaUJ1c051bTsgICAgICAgICAv
KiBQQ0kgYnVzIG51bWJlciAqLwogICAgVTggICAgICAgICAgICAgICAgIGJQY2lEZXZOdW07ICAg
ICAgICAgLyogUENJIGRldmljZSAoc2xvdCkgbnVtYmVyICovCiAgICBVOCAgICAgICAgICAgICAg
ICAgYlBjaUZjbk51bTsgICAgICAgICAvKiBQQ0kgZnVuY3Rpb24gbnVtYmVyICovCiAgICBVOCAg
ICAgICAgICAgICAgICAgYk1ham9yOyAgICAgICAgICAgICAvKiBEZXZpY2UgTWFqb3IgbnVtYmVy
ICovCiAgICBVOCAgICAgICAgICAgICAgICAgYk1pbm9yOyAgICAgICAgICAgICAvKiBEZXZpY2Ug
TWlub3IgbnVtYmVyICovCiAgICBVMTYgICAgICAgICAgICAgICAgd0RldmljZUlEOyAgICAgICAg
ICAvKiBEREMgY2FyZCB0eXBlIGZyb20gQ0lTIENhcmQgSUQgKGFsd2F5cyAweDAxMDEpKi8KICAg
IFUzMiAgICAgICAgICAgICAgICBkd0NhcmRJRDsgICAgICAgICAgIC8qIFNldCB0byB0aGUgYXBw
cm9wcmlhdGUgbWFjcm8gdmFsdWUgZWcuIERFVklEX0JVNjU1NTNNMl8zMDAgKi8KICAgIFUzMiAg
ICAgICAgICAgICAgICBkd0NoYW5NZW1MZW47ICAgICAgIC8qIG1lbSBzaXplIG9mIGVhY2ggY2hh
bm5lbCBvbiBjYXJkICovCiAgICBVMTYgICAgICAgICAgICAgICAgd0lycTsgICAgICAgICAgICAg
ICAvKiBpbnRlcnJ1cHQgbGV2ZWwgKi8KICAgIFU4ICAgICAgICAgICAgICAgICBiTnVtQ2hubHM7
ICAgICAgICAgIC8qIG51bWJlciBvZiBjaGFubmVscyBvbiBjYXJkICovCiAgICBVMzIgICAgICAg
ICAgICAgICAgZHdNZW1XbmRQY21jaWFBZGRyOyAvKiBCYXNlIGFkZHJlc3Mgb2YgTWVtb3J5IFdp
bmRvdyBpbiBQQ0kgc3BhY2UgKi8KICAgIFUzMiAgICAgICAgICAgICAgICBkd1JlZ1duZFBjbWNp
YUFkZHI7IC8qIEJhc2UgYWRkcmVzcyBvZiBSZWdpc3RyeSBXaW5kb3cgaW4gUENJIHNwYWNlICov
CiAgICBfX3U2NCAgICAgICAgICAgICAgZHdNZW1XbmRLcm5BZGRyOyAgICAvKiBCYXNlIGFkZHJl
c3Mgb2YgTWVtb3J5IFdpbmRvdyBpbiBLZXJuZWwgc3BhY2UgKi8KICAgIF9fdTY0ICAgICAgICAg
ICAgICBkd1JlZ1duZEtybkFkZHI7ICAgIC8qIEJhc2UgYWRkcmVzcyBvZiBSZWdpc3RyeSBXaW5k
b3cgaW4gS2VybmVsIHNwYWNlICovCiAgICBBQ0VfQ0hBTk5FTCAgICAgICAgQ2hhbm5lbDsgICAg
ICAgICAgICAvKiBDaGFubmVsIFNwZWNpZmljIGluZm9ybWF0aW9uICovCiAgICBBQ0U1M19DSVMg
ICAgICAgICAgQ0lTOyAgICAgICAgICAgICAgICAvKiBDaGFubmVsIFNwZWNpZmljIGluZm9ybWF0
aW9uICovCn0gQUNFNTNfQ0FSRCwgKnBBQ0U1M19DQVJEOwoKI2VuZGlmICAvKl9QQ01BQ0VfSF8q
Lwo=

------_=_NextPart_001_01CBCC65.39F68399
Content-Type: application/octet-stream;
	name="pcmace.c"
Content-Transfer-Encoding: base64
Content-Description: pcmace.c
Content-Disposition: attachment;
	filename="pcmace.c"

LyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqCiogIEZpbGUgTmFtZSA6IHBjbWFjZS5jCioKKiAgUHJvamVjdDog
IEFjZSBCVTY1NTV4TTItMzAwIFBDTUNJQSBpbnRlcmZhY2UgZHJpdmVyIGZvciBMaW51eCAyLjIu
MTYtMjIKKgoqCiogQ29weXJpZ2h0IChDKSAyMDA0IGJ5IElMQyBEYXRhIERldmljZSBDb3JwLgoq
IEFsbCBSaWdodHMgUmVzZXJ2ZWQuCioKKgoqICBDb21tZW50czoKKiAgICAgICAgICAgIE1ha2Ug
d2l0aGluIHRoZSBMaW51eCBDYXJkIFNlcnZpY2VzIHBhY2thZ2UKKiAgICAgICAgICAgIHVzci9z
cmMvbGludXgvcGNtY2lhLWNzLXgueS56L2NsaWVudHMKKiAgICAgICAgICAgIElnbm9yZSB3YXJp
bmluZyBmb3IgLm1vZGluZm8gKG5vdCBpbXBsZW1lbnRlZCkKKiAgICAgICAgICAgIFNlZSByZWFk
bWUudHh0CioKKiAgUmV2aXNpb24gSGlzdG9yeQoqICAgICBEYXRlICAgICAgICAgTmFtZSAgICAg
ICAgIFZlcnNpb24gICAgIERlc2NyaXB0aW9uCiotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoqICAxOC1BcHIt
MjAwMSAgICBHYXJ5IERhdmllcyAgICAgICAxLjAgICAgICAgT3JpZ2luYWwKKiAgMDQtTWFyLTIw
MDIgICAgTWFyayBGaW5kbGF0ZXIgICAgMS4xICAgICAgIEFkZGVkIHN1cHBvcnQgZm9yIG11bHRp
cGxlIGNhcmRzCiogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBB
ZGRlZCBrZXJuZWwgc3VwcG9ydCBmb3IgS2VybmVsIHZlcnNpb24gMi40LlgKKiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFJlbW92ZWQgUmVnaXN0ZXIgYWRkcmVz
cyBhbmQgcmVwbGFjZSB3aXRoICNkZWZpbmVzCioKKiAgMTUtT2N0LTIwMDIgICAgUmF5IExpdHRs
ZSAgICAgICAgMS4yICAgICAgIEZpeGVkIEludGVycnVwdCBwcm9ibGVtcy4KKiAgMjYtSnVuLTIw
MDMgICAgS1dIICAgICAgICAgICAgICAgMS4zICAgICAgIE1lcmdlZCBkcml2ZXIgd2l0aCBBQ0Ug
bGlicmFyeS4KKiAgMDctRGVjLTIwMDQgICAgRVNLICAgICAgICAgICAgICAgMS40ICAgICAgIFJl
cGxhY2VkIGRlcHJlY3RhZWQgZnVuY3Rpb25zIHdpdGggbWFjcm9zLgoqICAwNy1EZWMtMjAxMCAg
ICBHTFMgICAgICAgICAgICAgICAyLjAgICAgICAgUG9ydGVkIHRvIDIuNi4xOCBrZXJuZWxzCiog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAoYW5kIGRlbGV0ZWQg
YWxsIG9sZCBzdHVmZikKKgoqCioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8KI2luY2x1ZGUgPGxpbnV4L3Zl
cnNpb24uaD4KI2lmIExJTlVYX1ZFUlNJT05fQ09ERSA8IEtFUk5FTF9WRVJTSU9OKDIsNiwxOCkK
I2Vycm9yIHVuc3VwcG9ydGVkIGtlcm5lbCB2ZXJzaW9uIQojZW5kaWYKCiNpbmNsdWRlIDxsaW51
eC9rZXJuZWwuaD4KI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgojaW5jbHVkZSA8bGludXgvaW5p
dC5oPgojaW5jbHVkZSA8bGludXgvZnMuaD4KI2luY2x1ZGUgPGxpbnV4L3NjaGVkLmg+CiNpbmNs
dWRlIDxsaW51eC9wdHJhY2UuaD4KI2luY2x1ZGUgPGxpbnV4L3N0cmluZy5oPgojaW5jbHVkZSA8
bGludXgvc2xhYi5oPgojaW5jbHVkZSA8bGludXgvdGltZXIuaD4KI2luY2x1ZGUgPGxpbnV4L2lv
cG9ydC5oPgojaW5jbHVkZSA8bGludXgvaW50ZXJydXB0Lmg+CiNpbmNsdWRlIDxsaW51eC9tbS5o
PgoKI2luY2x1ZGUgPGFzbS9pby5oPgojaW5jbHVkZSA8YXNtL3N5c3RlbS5oPgoKI2luY2x1ZGUg
PHBjbWNpYS9jaXNyZWcuaD4KCiNpbmNsdWRlICJwY21hY2UuaCIKCi8vIERyaXZlciBkZWNsYXJh
dGlvbnMgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCi8q
IExpc3Qgb2Yga25vd24gY2FyZHMgdG8gYmluZCovCmNoYXIgbV9jc3pBcnJLbm93bkNhcmRzW0FD
RTUzX01BWF9OVU1fS05PV05fQ0FSRFNdWzIwXTsKCi8qIEhvbGRzIHRoZSBNQUpPUiBudW1iZXIg
b2YgdGhlIGFjZTUzIGRyaXZlciAqLwpfX3MzMiBtX2R3TWFqb3JOdW1iZXIgPSAwOwpfX3MzMiBt
X2R3TWlub3JOdW1iZXIgPSAwOwovKiBIb2xkcyB0aGUgdG90YWwgbnVtYmVyIG9mIDY1NTQ5IGNh
cmRzIGluIHRoZSBzeXN0ZW0gKi8KX191OCAgbV9iTnVtYmVyT2ZDYXJkcyA9IDA7CgovKiBUaGUg
Y2FyZCBsaXN0LiAqLwpBQ0U1M19DQVJEICBtX2FDYXJkc1tBQ0U1M19NQVhfTlVNX0NBUkRTXTsK
Ci8qIENhcmQgZGV2aWNlIElEJ3MgdXNlZCBieSBJU1IgdG8gZGV0ZXJtaW5lIHdoaWNoIGNhcmQg
aXNzdWVkIGFuIGludGVycnVwdC4gKi8KX191OCAgICBtX0Rldl9pZFtBQ0U1M19NQVhfTlVNX0NB
UkRTXSA9IHsgIDAsICAxLCAgMiwgIDMsICA0LCAgNSwgIDYsICA3LAogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgOCwgIDksIDEwLCAxMSwgMTIsIDEzLCAxNCwgMTUs
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDE2LCAxNywgMTgsIDE5
LCAyMCwgMjEsIDIyLCAyMywKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgMjQsIDI1LCAyNiwgMjcsIDI4LCAyOSwgMzAsIDMxICB9OwoKLyogU3RyaW5nIHVzZWQgYXMg
YSByZWZlcmVuY2UgZm9yIGludGVycnVwdCB1c2FnZSAoL3Byb2MvaW50ZXJydXB0cykuCiAqIFRI
SVMgU1RSSU5HIEJFSU5HIERFQ0xBUkVEIEFORCBJTklUSUFMSVpFRCBDQU5OT1QgQkUgTE9DQVRF
RCBJTiBUSEUgJ2lvY3RsJwogKiBNRVRIT0QgQkVDQVVTRSBJVCBXT1VMRCBORUVEIEEgJ21lbXNl
dCcgU1lNQk9MIFRPIEJFIEFWQUlMQUJMRSwgQlVUIEkgRE9OJ1QKICogVEhJTksgT05FIEVYSVNU
UyBBVCBUSEUgS0VSTkVMIExFVkVMLiAgSVQgV09VTEQgQ09NUElMRSwgQlVUIEdJVkVTIEFOIEVS
Uk9SCiAqIFdIRU4gVEhFIE1PRFVMRSBJUyBMT0FERUQuICovCi8vIHNEZXZOYW1lIGdldHMgdXBk
YXRlZCBieSB0aGUgaW9jdGwgZnVuY3Rpb24gc28gZG9uJ3QgdXNlIGl0IHRvIHJlZmVyZW5jZSB0
aGUgbW9kdWxlIG5hbWUgaW4gb3RoZXIgZnVuY3Rpb25zLCB1c2UgTU9EVUxFX05BTUUKX19zOCAg
ICBtX3NEZXZOYW1lW0RFVl9OQU1FX0xFTl0gPSB7IE1PRFVMRV9OQU1FIH07CgovKiBXYWl0IHF1
ZXVlcyB1c2VkIGZvciBibG9ja2luZy4gKi8Kd2FpdF9xdWV1ZV9oZWFkX3QgbV9hcFdhaXRRdWVb
QUNFNTNfTUFYX05VTV9DQVJEU107CmludCBtX2FwV2FpdEZsYWcgPSAwOwoKLy8gRW5kIG9mIERy
aXZlciBkZWNsYXJhdGlvbnMgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQovKgogICBBbGwgdGhlIFBDTUNJQSBtb2R1bGVzIHVzZSBQQ01DSUFfREVCVUcgdG8gY29udHJv
bCBkZWJ1Z2dpbmcuICBJZgogICB5b3UgZG8gbm90IGRlZmluZSBQQ01DSUFfREVCVUcgYXQgYWxs
LCBhbGwgdGhlIGRlYnVnIGNvZGUgd2lsbCBiZQogICBsZWZ0IG91dC4gIElmIHlvdSBjb21waWxl
IHdpdGggUENNQ0lBX0RFQlVHPTAsIHRoZSBkZWJ1ZyBjb2RlIHdpbGwKICAgYmUgcHJlc2VudCBi
dXQgZGlzYWJsZWQgLS0gYnV0IGl0IGNhbiB0aGVuIGJlIGVuYWJsZWQgZm9yIHNwZWNpZmljCiAg
IG1vZHVsZXMgYXQgbG9hZCB0aW1lIHdpdGggYSAncGNfZGVidWc9Iycgb3B0aW9uIHRvIGluc21v
ZC4KKi8KCi8vI2RlZmluZSBQQ01DSUFfREVCVUcgMAovLyNkZWZpbmUgUENNQ0lBX0tFUk5fREVC
VUcgS0VSTl9ERUJVRwojZGVmaW5lIFBDTUNJQV9ERUJVRyAxMDAKI2RlZmluZSBQQ01DSUFfS0VS
Tl9ERUJVRyBLRVJOX0FMRVJUCgojaWZkZWYgUENNQ0lBX0RFQlVHCnN0YXRpYyBpbnQgcGNfZGVi
dWcgPSBQQ01DSUFfREVCVUc7CiNkZWZpbmUgREVCVUcobiwgYXJncy4uLikgaWYgKHBjX2RlYnVn
PihuKSkgcHJpbnRrKFBDTUNJQV9LRVJOX0RFQlVHIGFyZ3MpCiNlbHNlCiNkZWZpbmUgREVCVUco
biwgYXJncy4uLikKI2VuZGlmCgovKgogICBUaGUgZXZlbnQoKSBmdW5jdGlvbiBpcyB0aGlzIGRy
aXZlcidzIENhcmQgU2VydmljZXMgZXZlbnQgaGFuZGxlci4KICAgSXQgd2lsbCBiZSBjYWxsZWQg
YnkgQ2FyZCBTZXJ2aWNlcyB3aGVuIGFuIGFwcHJvcHJpYXRlIGNhcmQgc3RhdHVzCiAgIGV2ZW50
IGlzIHJlY2VpdmVkLiAgVGhlIGNvbmZpZygpIGFuZCByZWxlYXNlKCkgZW50cnkgcG9pbnRzIGFy
ZQogICB1c2VkIHRvIGNvbmZpZ3VyZSBvciByZWxlYXNlIGEgc29ja2V0LCBpbiByZXNwb25zZSB0
byBjYXJkCiAgIGluc2VydGlvbiBhbmQgZWplY3Rpb24gZXZlbnRzLiAgVGhleSBhcmUgaW52b2tl
ZCBmcm9tIHRoZSBidTY1NTUzeAogICBldmVudCBoYW5kbGVyLgoqLwoKc3RhdGljIHZvaWQgcGNt
YWNlX2NzX2NvbmZpZyhzdHJ1Y3QgcGNtY2lhX2RldmljZSAqcGxpbmspOwpzdGF0aWMgdm9pZCBw
Y21hY2VfY3NfcmVsZWFzZShzdHJ1Y3QgcGNtY2lhX2RldmljZSAqcGxpbmspOwoKLyoKICAgVGhl
IGF0dGFjaCgpIGFuZCBkZXRhY2goKSBlbnRyeSBwb2ludHMgYXJlIHVzZWQgdG8gY3JlYXRlIGFu
ZCBkZXN0cm95CiAgICJpbnN0YW5jZXMiIG9mIHRoZSBkcml2ZXIsIHdoZXJlIGVhY2ggaW5zdGFu
Y2UgcmVwcmVzZW50cyBldmVyeXRoaW5nCiAgIG5lZWRlZCB0byBtYW5hZ2Ugb25lIGFjdHVhbCBQ
Q01DSUEgY2FyZC4KKi8KCnN0YXRpYyBpbnQgIHBjbWFjZV9jc19hdHRhY2goc3RydWN0IHBjbWNp
YV9kZXZpY2UgKik7CnN0YXRpYyB2b2lkIHBjbWFjZV9jc19kZXRhY2goc3RydWN0IHBjbWNpYV9k
ZXZpY2UgKik7CnN0YXRpYyBpbnQgIHBjbWFjZV9jc19zdXNwZW5kKHN0cnVjdCBwY21jaWFfZGV2
aWNlICopOwpzdGF0aWMgaW50ICBwY21hY2VfY3NfcmVzdW1lKHN0cnVjdCBwY21jaWFfZGV2aWNl
ICopOwpzdGF0aWMgdm9pZCBQcmludFNlcnZpbmZvKHN0cnVjdCBwY21jaWFfZGV2aWNlICpkZXYp
OwpzdGF0aWMgdm9pZCBkdW1wU3RydWN0KHZvaWQpOwoKLyoKICAgWW91J2xsIGFsc28gbmVlZCB0
byBwcm90b3R5cGUgYWxsIHRoZSBmdW5jdGlvbnMgdGhhdCB3aWxsIGFjdHVhbGx5CiAgIGJlIHVz
ZWQgdG8gdGFsayB0byB5b3VyIGRldmljZS4gIFNlZSAnbWVtb3J5X2NzJyBmb3IgYSBnb29kIGV4
YW1wbGUKICAgb2YgYSBmdWxseSBzZWxmLXN1ZmZpY2llbnQgZHJpdmVyOyB0aGUgb3RoZXIgZHJp
dmVycyByZWx5IG1vcmUgb3IKICAgbGVzcyBvbiBvdGhlciBwYXJ0cyBvZiB0aGUga2VybmVsLgoq
LwoKLyoKICAgVGhlIGRldl9pbmZvIHZhcmlhYmxlIGlzIHRoZSAia2V5IiB0aGF0IGlzIHVzZWQg
dG8gbWF0Y2ggdXAgdGhpcwogICBkZXZpY2UgZHJpdmVyIHdpdGggYXBwcm9wcmlhdGUgY2FyZHMs
IHRocm91Z2ggdGhlIGNhcmQgY29uZmlndXJhdGlvbgogICBkYXRhYmFzZS4KKi8KCi8qc3RhdGlj
IGRldl9pbmZvX3QgZGV2X2luZm8gPSAicGNtYWNlIjsqLwoKLyoKICAgQSBsaW5rZWQgbGlzdCBv
ZiAiaW5zdGFuY2VzIiBvZiB0aGUgYnU2NTU1eCBkZXZpY2UuICBFYWNoIGFjdHVhbAogICBQQ01D
SUEgY2FyZCBjb3JyZXNwb25kcyB0byBvbmUgZGV2aWNlIGluc3RhbmNlLCBhbmQgaXMgZGVzY3Jp
YmVkCiAgIGJ5IG9uZSBzdHJ1Y3QgcGNtY2lhX2RldmljZSBzdHJ1Y3R1cmUgKGRlZmluZWQgaW4g
ZHMuaCkuCgogICBZb3UgbWF5IG5vdCB3YW50IHRvIHVzZSBhIGxpbmtlZCBsaXN0IGZvciB0aGlz
IC0tIGZvciBleGFtcGxlLCB0aGUKICAgYnU2NTU1M3ggY2FyZCBkcml2ZXIgdXNlcyBhbiBhcnJh
eSBvZiBzdHJ1Y3QgcGNtY2lhX2RldmljZSBwb2ludGVycywgd2hlcmUgbWlub3IKICAgZGV2aWNl
IG51bWJlcnMgYXJlIHVzZWQgdG8gZGVyaXZlIHRoZSBjb3JyZXNwb25kaW5nIGFycmF5IGluZGV4
LgoqLwoKLypzdGF0aWMgc3RydWN0IHBjbWNpYV9kZXZpY2UgKmRldl9saXN0ID0gTlVMTDsqLwoK
LyoKICAgQSBzdHJ1Y3QgcGNtY2lhX2RldmljZSBzdHJ1Y3R1cmUgaGFzIGZpZWxkcyBmb3IgbW9z
dCB0aGluZ3MgdGhhdCBhcmUgbmVlZGVkCiAgIHRvIGtlZXAgdHJhY2sgb2YgYSBzb2NrZXQsIGJ1
dCB0aGVyZSB3aWxsIHVzdWFsbHkgYmUgc29tZSBkZXZpY2UKICAgc3BlY2lmaWMgaW5mb3JtYXRp
b24gdGhhdCBhbHNvIG5lZWRzIHRvIGJlIGtlcHQgdHJhY2sgb2YuICBUaGUKICAgJ3ByaXYnIHBv
aW50ZXIgaW4gYSBzdHJ1Y3QgcGNtY2lhX2RldmljZSBzdHJ1Y3R1cmUgY2FuIGJlIHVzZWQgdG8g
cG9pbnQgdG8KICAgYSBkZXZpY2Utc3BlY2lmaWMgcHJpdmF0ZSBkYXRhIHN0cnVjdHVyZSwgbGlr
ZSB0aGlzLgoKICAgVG8gc2ltcGxpZnkgdGhlIGRhdGEgc3RydWN0dXJlIGhhbmRsaW5nLCB3ZSBh
Y3R1YWxseSBpbmNsdWRlIHRoZQogICBzdHJ1Y3QgcGNtY2lhX2RldmljZSBzdHJ1Y3R1cmUgaW4g
dGhlIGRldmljZSdzIHByaXZhdGUgZGF0YSBzdHJ1Y3R1cmUuCgogICBBIGRyaXZlciBuZWVkcyB0
byBwcm92aWRlIGEgZGV2X25vZGVfdCBzdHJ1Y3R1cmUgZm9yIGVhY2ggZGV2aWNlCiAgIG9uIGEg
Y2FyZC4gIEluIHNvbWUgY2FzZXMsIHRoZXJlIGlzIG9ubHkgb25lIGRldmljZSBwZXIgY2FyZCAo
Zm9yCiAgIGV4YW1wbGUsIGV0aGVybmV0IGNhcmRzLCBtb2RlbXMpLiAgSW4gb3RoZXIgY2FzZXMs
IHRoZXJlIG1heSBiZQogICBtYW55IGFjdHVhbCBvciBsb2dpY2FsIGRldmljZXMgKFNDU0kgYWRh
cHRlcnMsIG1lbW9yeSBjYXJkcyB3aXRoCiAgIG11bHRpcGxlIHBhcnRpdGlvbnMpLiAgVGhlIGRl
dl9ub2RlX3Qgc3RydWN0dXJlcyBuZWVkIHRvIGJlIGtlcHQKICAgaW4gYSBsaW5rZWQgbGlzdCBz
dGFydGluZyBhdCB0aGUgJ2RldicgZmllbGQgb2YgYSBzdHJ1Y3QgcGNtY2lhX2RldmljZQogICBz
dHJ1Y3R1cmUuICBXZSBhbGxvY2F0ZSB0aGVtIGluIHRoZSBjYXJkJ3MgcHJpdmF0ZSBkYXRhIHN0
cnVjdHVyZSwKICAgYmVjYXVzZSB0aGV5IGdlbmVyYWxseSBzaG91bGRuJ3QgYmUgYWxsb2NhdGVk
IGR5bmFtaWNhbGx5LgoKICAgSW4gdGhpcyBjYXNlLCB3ZSBhbHNvIHByb3ZpZGUgYSBmbGFnIHRv
IGluZGljYXRlIGlmIGEgZGV2aWNlIGlzCiAgICJzdG9wcGVkIiBkdWUgdG8gYSBwb3dlciBtYW5h
Z2VtZW50IGV2ZW50LCBvciBjYXJkIGVqZWN0aW9uLiAgVGhlCiAgIGRldmljZSBJTyByb3V0aW5l
cyBjYW4gdXNlIGEgZmxhZyBsaWtlIHRoaXMgdG8gdGhyb3R0bGUgSU8gdG8gYQogICBjYXJkIHRo
YXQgaXMgbm90IHJlYWR5IHRvIGFjY2VwdCBpdC4KCiAgIFRoZSBidXNfb3BlcmF0aW9ucyBwb2lu
dGVyIGlzIHVzZWQgb24gcGxhdGZvcm1zIGZvciB3aGljaCB3ZSBuZWVkCiAgIHRvIHVzZSBzcGVj
aWFsIHNvY2tldC1zcGVjaWZpYyB2ZXJzaW9ucyBvZiBub3JtYWwgSU8gcHJpbWl0aXZlcwogICAo
aW5iLCBvdXRiLCByZWFkYiwgd3JpdGViLCBldGMpIGZvciBjYXJkIElPLgoqLwoKdHlwZWRlZiBz
dHJ1Y3QgbG9jYWxfaW5mb190IHsKICAgIHN0cnVjdCBwY21jaWFfZGV2aWNlICAqbGluazsKICAg
IC8qZGV2X25vZGVfdCAgICAgICAgICAgICBub2RlOyovCiAgICBpbnQgICAgICAgICAgICAgICAg
ICAgIHN0b3A7CiAgICBzdHJ1Y3QgYnVzX29wZXJhdGlvbnMgKmJ1czsKfSBsb2NhbF9pbmZvX3Q7
CgojZGVmaW5lIF9fTk9UUkVRVUVTVEVEX18gIDAKI2RlZmluZSBfX1JFUVVFU1RFRF9fICAgICAx
CgovLyBTdHJ1Y3R1cmVzIHVzZWQgdG8gcmVxdWVzdCBjYXJkIHJlc291cmNlczsgSU8gcG9ydHMs
IElSUSwgbWVtb3J5CnR5cGVkZWYgc3RydWN0CnsKICAgIHdpbl9yZXFfdCByZXE7CiAgICBtZW1y
ZXFfdCBtYXA7CiAgICB3aW5kb3dfaGFuZGxlX3Qgd2luaGFuZGxlOwogICAgY2hhciBjQXJyV2lu
ZG93UmVxdWVzdDsKICAgIGludCogcG5EaXJlY3RQaHlzaWNhbEFkZHI7CiAgICB1bnNpZ25lZCBs
b25nIHVsV2luZG93U2l6ZTsKICAgIGludCogcG5EaXJlY3RLZXJuZWxBZGRyOwp9IENhcmRfV2lu
X3Q7Cgp0eXBlZGVmIHN0cnVjdAoKewogICAgY2hhciBjSU9SZXF1ZXN0OwogICAgY2hhciBjSVJR
UmVxdWVzdDsKICAgIGludCBuTnVtV2luZG93czsKICAgIENhcmRfV2luX3QgV2luQXJyW0FDRTUz
X01BWF9OVU1fV0lORE9XU107Cn0gQ2FyZF9JT190OwoKc3RhdGljIENhcmRfSU9fdCBtX0NhcmRJ
T1tBQ0U1M19NQVhfTlVNX0NBUkRTXTsKCi8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tU1RB
UlQgT0YgQ0hBUiBEUklWRVIgRlVOQ1RJT05TLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSov
CgovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKgogKiBGdW5jdGlvbjogcGNtYWNlX2ZvcHNfb3BlbiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBEZXNjcmlwdGlvbjogSGFu
ZGxlcyBvcGVuaW5nIG9mIGEgc2luZ2xlIGNoYW5uZWwgKGRldmljZSkgICAgICAgKgogKiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKgogKiBQYXJhbWV0ZXJzOiAgIGlub2RlIC0gdXNlZCB0byBnZXQgdGhlIE1pbm9yIE51bWJl
ciAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgIGZsaXAgIC0gTm90IFVzZWQgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3RhdGljIGludCBwY21h
Y2VfZm9wc19vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxwKQp7CiAg
ICBfX3U4ICAgIGJDYXJkTnVtICAgICAgICA9IE1JTk9SKGlub2RlLT5pX3JkZXYpOyAgLyogQ2Fy
ZCBudW1iZXIgaW4gc3lzdGVtICgwIC0gMykgKi8KCiAgICBERUJVRygxMCwgIiVzOiBlbnRlcmlu
ZyBmb3BzX29wZW5cbiIsIE1PRFVMRV9OQU1FKTsKICAgIGR1bXBTdHJ1Y3QoKTsKCiAgICAvKiBD
aGVjayB0aGF0IG1pbm9yIG51bWJlciBjb3JyZXNwb25kcyB0byBhIGNhcmQgaW4gdGhlIHN5c3Rl
bS4gKi8KICAgIGlmIChiQ2FyZE51bSA+PSBtX2JOdW1iZXJPZkNhcmRzKQogICAgICAgIHJldHVy
biBTVEFUVVNfQUNFNTNfREVWSUNFX05PVF9FWElTVDsKCiAgICAvKiBDaGVjayB0aGF0IHRoaXMg
ZGV2aWNlIGlzIG5vdCBhbHJlYWR5IG9wZW5lZC4gKi8KICAgIGlmKG1fYUNhcmRzW2JDYXJkTnVt
XS5DaGFubmVsLmJPcGVuKQogICAgICAgIHJldHVybiBTVEFUVVNfQUNFNTNfQ0FSRF9BTFJFQURZ
X09QRU47CgogICAgLyogQ2hlY2sgaWYgUkVHSVNURVIgd2luZG93IGluIFVzZXIgU3BhY2Ugd2Fz
IHByb3Blcmx5IGNsb3NlZCAqLwogICAgaWYoIChtX2FDYXJkc1tiQ2FyZE51bV0uQ2hhbm5lbC5k
d01lbVduZFVzckFkZHIpIHx8CiAgICAgICAgKG1fYUNhcmRzW2JDYXJkTnVtXS5DaGFubmVsLmR3
UmVnV25kVXNyQWRkcikgKQogICAgICAgIHJldHVybiBTVEFUVVNfQUNFNTNfQ0FSRF9JTVBST1BF
UkxZX0NMT1NFRDsKCiAgICAvKiBTZXQgQ2FyZCBOdW1iZXIgKi8KICAgIG1fYUNhcmRzW2JDYXJk
TnVtXS5DaGFubmVsLmJDYXJkTnVtID0gYkNhcmROdW07CgogICAgLyogU2V0IENoYW5uZWwgTnVt
YmVyICovCiAgICBtX2FDYXJkc1tiQ2FyZE51bV0uQ2hhbm5lbC5iQ2hhbk51bSA9IDA7CgogICAg
LyogQ2hlY2sgaWYgdGhlIG90aGVyIGNoYW5uZWwgaXMgY2xvc2VkICovCgogICAgLyogS2VybmVs
IE1lbW9yeSBzaG91bGQgYmUgbnVsbCAqLwogICAgaWYoIChtX2FDYXJkc1tiQ2FyZE51bV0uZHdS
ZWdXbmRLcm5BZGRyKSB8fAogICAgICAgIChtX2FDYXJkc1tiQ2FyZE51bV0uZHdNZW1XbmRLcm5B
ZGRyKSApCiAgICAgICAgcmV0dXJuIFNUQVRVU19BQ0U1M19DQVJEX0lNUFJPUEVSTFlfQ0xPU0VE
OwoKICAgIERFQlVHKDgwLCAiJXM6IGZvcHNfb3BlbjogMHgleCAweCV4XG4iLAogICAgICAgICAg
TU9EVUxFX05BTUUsIG1fYUNhcmRzW2JDYXJkTnVtXS5kd1JlZ1duZFBjbWNpYUFkZHIsCiAgICAg
ICAgICBBQ0U1M19DSEFOX1JFR19MRU5HVEgpOwoKICAgIC8qIE1hcCB0aGUgUmVnaXN0ZXIgd2lu
ZG93IHRvIGtlcm5lbCBzcGFjZS4gKi8KICAgIC8qIEdMUyAqLwogICAgcmVxdWVzdF9tZW1fcmVn
aW9uKG1fYUNhcmRzW2JDYXJkTnVtXS5kd1JlZ1duZFBjbWNpYUFkZHIsCiAgICAgICAgICAgICAg
ICAgICAgICAgQUNFNTNfQ0hBTl9SRUdfTEVOR1RILCBNT0RVTEVfTkFNRSk7CiAgICBpZighKG1f
YUNhcmRzW2JDYXJkTnVtXS5kd1JlZ1duZEtybkFkZHIgPSAoX191NjQpaW9yZW1hcChtX2FDYXJk
c1tiQ2FyZE51bV0uZHdSZWdXbmRQY21jaWFBZGRyLEFDRTUzX0NIQU5fUkVHX0xFTkdUSCkpKQog
ICAgICAgIHJldHVybiBTVEFUVVNfQUNFNTNfUENNQ0lBQ0ZHX1JFTUFQX0ZBSUw7CiAgICByZXF1
ZXN0X21lbV9yZWdpb24obV9hQ2FyZHNbYkNhcmROdW1dLmR3UmVnV25kS3JuQWRkciwKICAgICAg
ICAgICAgICAgICAgICAgICBBQ0U1M19DSEFOX1JFR19MRU5HVEgsIE1PRFVMRV9OQU1FKTsKICAg
IERFQlVHKDgwLCAiJXM6IGZvcHNfb3BlbjogcmVhZGluZyBmcm9tIGNhcmQgcmVnaXN0ZXJzIHRo
cm91Z2gga2VybmVsOlxuIgogICAgICAgICAgICAgICIgICAweCUwMnggMHglMDJ4IDB4JTAyeCAw
eCUwMnggMHglMDJ4IDB4JTAyeFxuIiwKICAgICAgICAgIE1PRFVMRV9OQU1FLAogICAgICAgICAg
KigodW5zaWduZWQgY2hhciAqKShtX2FDYXJkc1tiQ2FyZE51bV0uZHdSZWdXbmRLcm5BZGRyKSks
CiAgICAgICAgICAqKCgodW5zaWduZWQgY2hhciAqKShtX2FDYXJkc1tiQ2FyZE51bV0uZHdSZWdX
bmRLcm5BZGRyKSkrIDEpLAogICAgICAgICAgKigoKHVuc2lnbmVkIGNoYXIgKikobV9hQ2FyZHNb
YkNhcmROdW1dLmR3UmVnV25kS3JuQWRkcikpKyAyKSwKICAgICAgICAgICooKCh1bnNpZ25lZCBj
aGFyICopKG1fYUNhcmRzW2JDYXJkTnVtXS5kd1JlZ1duZEtybkFkZHIpKSsgMyksCiAgICAgICAg
ICAqKCgodW5zaWduZWQgY2hhciAqKShtX2FDYXJkc1tiQ2FyZE51bV0uZHdSZWdXbmRLcm5BZGRy
KSkrIDQpLAogICAgICAgICAgKigoKHVuc2lnbmVkIGNoYXIgKikobV9hQ2FyZHNbYkNhcmROdW1d
LmR3UmVnV25kS3JuQWRkcikpKyA1KSk7CiAgICBERUJVRyg4MCwgIiVzOiBmb3BzX29wZW46IGJl
Zm9yZSBjYXJkIHJlc2V0XG4iLCBNT0RVTEVfTkFNRSk7CiAgICAqKCgodW5zaWduZWQgY2hhciAq
KShtX2FDYXJkc1tiQ2FyZE51bV0uZHdSZWdXbmRLcm5BZGRyKSkrIDcpID0gMTsKICAgIERFQlVH
KDgwLCAiJXM6IGZvcHNfb3BlbjogIGFmdGVyIGNhcmQgcmVzZXRcbiIsIE1PRFVMRV9OQU1FKTsK
ICAgIERFQlVHKDgwLCAiJXM6IGZvcHNfb3BlbjogIDB4JTAyeFxuIiwgTU9EVUxFX05BTUUsCiAg
ICAgICAgICAqKCgodW5zaWduZWQgY2hhciAqKShtX2FDYXJkc1tiQ2FyZE51bV0uZHdSZWdXbmRL
cm5BZGRyKSkrIDE0KSk7CiAgICAqKCgodW5zaWduZWQgY2hhciAqKShtX2FDYXJkc1tiQ2FyZE51
bV0uZHdSZWdXbmRLcm5BZGRyKSkrIDE0KSA9IDE1OwogICAgREVCVUcoODAsICIlczogZm9wc19v
cGVuOiAgMHglMDJ4XG4iLCBNT0RVTEVfTkFNRSwKICAgICAgICAgICooKCh1bnNpZ25lZCBjaGFy
ICopKG1fYUNhcmRzW2JDYXJkTnVtXS5kd1JlZ1duZEtybkFkZHIpKSsgMTQpKTsKCiAgICAvKiBH
TFMgKi8KICAgIC8qIE1hcCB0aGUgTWVtb3J5IHdpbmRvdyB0byBrZXJuZWwgc3BhY2UuICovCiAg
ICByZXF1ZXN0X21lbV9yZWdpb24obV9hQ2FyZHNbYkNhcmROdW1dLmR3TWVtV25kUGNtY2lhQWRk
ciwKICAgICAgICAgICAgICAgICAgICAgICBBQ0U1M19DSEFOX01FTV9MRU5HVEgsIE1PRFVMRV9O
QU1FKTsKICAgIGlmKCEobV9hQ2FyZHNbYkNhcmROdW1dLmR3TWVtV25kS3JuQWRkciA9IChfX3U2
NClpb3JlbWFwKG1fYUNhcmRzW2JDYXJkTnVtXS5kd01lbVduZFBjbWNpYUFkZHIsQUNFNTNfQ0hB
Tl9NRU1fTEVOR1RIKSkpCiAgICAgICAgcmV0dXJuIFNUQVRVU19BQ0U1M19QQ01DSUFDRkdfUkVN
QVBfRkFJTDsKICAgIHJlcXVlc3RfbWVtX3JlZ2lvbihtX2FDYXJkc1tiQ2FyZE51bV0uZHdNZW1X
bmRLcm5BZGRyLAogICAgICAgICAgICAgICAgICAgICAgIEFDRTUzX0NIQU5fTUVNX0xFTkdUSCwg
TU9EVUxFX05BTUUpOwogICAgREVCVUcoODAsICIlczogZm9wc19vcGVuOiByZWFkaW5nIGZyb20g
Y2FyZCBkYXRhIHRocm91Z2gga2VybmVsOlxuIgogICAgICAgICAgICAgICIgICAweCUwMnggMHgl
MDJ4IDB4JTAyeCAweCUwMnggMHglMDJ4IDB4JTAyeFxuIiwKICAgICAgICAgIE1PRFVMRV9OQU1F
LAogICAgICAgICAgKigodW5zaWduZWQgY2hhciAqKShtX2FDYXJkc1tiQ2FyZE51bV0uZHdNZW1X
bmRLcm5BZGRyKSksCiAgICAgICAgICAqKCgodW5zaWduZWQgY2hhciAqKShtX2FDYXJkc1tiQ2Fy
ZE51bV0uZHdNZW1XbmRLcm5BZGRyKSkrIDEpLAogICAgICAgICAgKigoKHVuc2lnbmVkIGNoYXIg
KikobV9hQ2FyZHNbYkNhcmROdW1dLmR3TWVtV25kS3JuQWRkcikpKyAyKSwKICAgICAgICAgICoo
KCh1bnNpZ25lZCBjaGFyICopKG1fYUNhcmRzW2JDYXJkTnVtXS5kd01lbVduZEtybkFkZHIpKSsg
MyksCiAgICAgICAgICAqKCgodW5zaWduZWQgY2hhciAqKShtX2FDYXJkc1tiQ2FyZE51bV0uZHdN
ZW1XbmRLcm5BZGRyKSkrIDQpLAogICAgICAgICAgKigoKHVuc2lnbmVkIGNoYXIgKikobV9hQ2Fy
ZHNbYkNhcmROdW1dLmR3TWVtV25kS3JuQWRkcikpKyA1KSk7CiAgICBERUJVRyg4MCwgIiVzOiBm
b3BzX29wZW46ICAweCUwMnhcbiIsIE1PRFVMRV9OQU1FLAogICAgICAgICAgKigoKHVuc2lnbmVk
IGNoYXIgKikobV9hQ2FyZHNbYkNhcmROdW1dLmR3TWVtV25kS3JuQWRkcikpKyAxKSk7CiAgICAq
KCgodW5zaWduZWQgY2hhciAqKShtX2FDYXJkc1tiQ2FyZE51bV0uZHdNZW1XbmRLcm5BZGRyKSkr
IDEpID0gMjU1OwogICAgREVCVUcoODAsICIlczogZm9wc19vcGVuOiAgMHglMDJ4XG4iLCBNT0RV
TEVfTkFNRSwKICAgICAgICAgICooKCh1bnNpZ25lZCBjaGFyICopKG1fYUNhcmRzW2JDYXJkTnVt
XS5kd01lbVduZEtybkFkZHIpKSsgMSkpOwoKICAgIC8qIFNldCBOdW1iZXIgb2YgQ2hhbm5lbHMg
Ki8KICAgIG1fYUNhcmRzW2JDYXJkTnVtXS5iTnVtQ2hubHMgPSAoVTgpQUNFNTNfTlVNX0NIQU5T
X1BFUl9DQVJEOwoKICAgIC8qIEFkZCBpbml0aWFsaXNlIGZvciB3YWl0X3F1ZXVlICovCiAgICBp
bml0X3dhaXRxdWV1ZV9oZWFkKCZtX2FwV2FpdFF1ZVtiQ2FyZE51bV0pOwoKICAgIC8qIFJlc2V0
IEJDIEF1dG8gRmxpcCBTdGFjayAqLwogICAgbV9hQ2FyZHNbYkNhcmROdW1dLkNoYW5uZWwuYkF1
dG9GbGlwU3RrID0gMDsKCiAgICAvKiBkZWZpbmUgZGV2aWNlIGFzIG9wZW4gKi8KICAgIG1fYUNh
cmRzW2JDYXJkTnVtXS5DaGFubmVsLmJPcGVuID0gMTsKCiAgICAvKiBkZWZpbmUgQ2FyZCBEZXZp
Y2UgTnVtYmVyICovCiAgICBtX2FDYXJkc1tiQ2FyZE51bV0uYlBjaURldk51bSA9IGJDYXJkTnVt
OyAvL2ptZiBhZGRlZCB0byBhbGxvdyBtdWx0aXBsZSBjYXJkcwogICAgbV9hQ2FyZHNbYkNhcmRO
dW1dLmJNYWpvciAgICAgPSBNQUpPUihpbm9kZS0+aV9yZGV2KTsKICAgIG1fYUNhcmRzW2JDYXJk
TnVtXS5iTWlub3IgICAgID0gYkNhcmROdW07CgogICAgZHVtcFN0cnVjdCgpOwogICAgcmV0dXJu
IFNUQVRVU19BQ0U1M19TVUNDRVNTOwp9CgovKiBJU1IgZm9yIGxlZ2FjeSBBQ0UgZGV2aWNlcy4g
Ki8Kc3RhdGljIGlycXJldHVybl90IHBjbWFjZV9pc3IoaW50IGlycSwgdm9pZCogZGV2X2lkLCBz
dHJ1Y3QgcHRfcmVncyAqcmVncykKewogICAgX191OCAgICAqYnBDaGFuTnVtICAgID0gZGV2X2lk
OyAgICAgICAgICAgICAvKiBQb2ludGVyIHRvIGludGVycnVwdGVkIGRldmljZSAqLwogICAgX191
OCAgICBiU3lzdGVtTnVtICAgID0gKF9fdTgpKCpicENoYW5OdW0pOyAvKiBFbnVtZXJhdGVkIFN5
c3RlbSBOdW1iZXIgKi8KICAgIF9fdTggICAgYkNhcmROdW0gICAgICA9IChfX3U4KShiU3lzdGVt
TnVtKTsgLyogQ2FyZCBudW1iZXIgaW4gc3lzdGVtICgwIC0gMykgKi8KICAgIF9fdTggICAgYkNo
YW5OdW0gICAgICA9IDA7ICAgICAgICAgICAgICAgICAgLyogQ2hhbm5lbCBudW1iZXIgb24gY2Fy
ZCAoMCwgMSkgKi8KLyogICAgX191OCAgIGJJbnRGbGFnICAgICAgPSAweDExOyAqLyAgICAgICAg
ICAgLyogVGhpcyBkZXZpY2UncyBJTlQgZmxhZyAqLwogICAgX191OCAgIGJDdXJBcmVhICAgICAg
PSAweDAwOyAgICAgICAgICAgICAgICAvKiBDdXJyZW50IFN0YWNrIEFyZWEgKEEvQikgKi8KICAg
IF9fdTggICBiQkNFb2YgICAgICAgID0gMHgwMDsgICAgICAgICAgICAgICAgLyogQkMgRW5kLW9m
LUZyYW1lIEludGVycnVwdCAqLwovKiAgICBfX3UxNiAgd0NvbmZpZ1JlZyAgICA9IDB4MTExMTsg
Ki8gICAgICAgICAvKiA2NTU0OSAwODAwIENvbmZpZ3VyYXRpb24gU3BhY2UgKi8KICAgIF9fdTE2
ICB3SW50U3RhdFJlZyAgID0gMHgwMDAwOyAgICAgICAgICAgICAgLyogQWNlIEludGVycnVwdCBT
dGF0dXMgUmVnaXN0ZXIgKi8KICAgIF9fdTE2ICB3Q2ZnUmVnMSAgICAgID0gMHgwMDAwOyAgICAg
ICAgICAgICAgLyogQWNlIENvbmZpZ3VyYXRpb24gUmVnaXN0ZXIgIzEgKi8KICAgIF9fdTY0ICBk
d0NoYW5PZmZzZXQgID0gMHgwMDAwMDAwMDAwMDAwMDAwOyAgLyogSG9sZHMgdGhlIGNoYW5uZWwn
cyBSZWcgYmFzZSBhZGRyICovCgogICAgREVCVUcoMTAsICIlczogZW50ZXJpbmcgbGVnYWN5IEFD
RSBpc3IgcGNtYWNlX2lzclxuIiwgTU9EVUxFX05BTUUpOwogICAgREVCVUcoMTAsICIlczogcGNt
YWNlX2lzcjogYkNoYW5OdW0gJXVcbiIsIE1PRFVMRV9OQU1FLCBiQ2hhbk51bSk7CiAgICBERUJV
RygxMCwgIiVzOiBwY21hY2VfaXNyOiBiQ2FyZE51bSAldVxuIiwgTU9EVUxFX05BTUUsIGJDYXJk
TnVtKTsKCiAgICAvKiBHZXQgQ2hhbm5lbCBPZmZzZXQgKi8KICAgIGR3Q2hhbk9mZnNldCA9IChf
X3U2NCkobV9hQ2FyZHNbYkNhcmROdW1dLmR3UmVnV25kS3JuQWRkciArIChiQ2hhbk51bSoweDAw
ODApKTsgLyogcmVnIHNwYWNlID0gMHg4MCAqLwogICAgREVCVUcoMTAsICIlczogcGNtYWNlX2lz
cjogMDFcbiIsIE1PRFVMRV9OQU1FKTsKICAgIERFQlVHKDEwLCAiJXM6IHBjbWFjZV9pc3I6IGR3
Q2hhbk9mZnNldCAweCVsbFhcbiIsCiAgICAgICAgICBNT0RVTEVfTkFNRSwgZHdDaGFuT2Zmc2V0
KTsKICAgIERFQlVHKDEwLCAiJXM6IHBjbWFjZV9pc3I6IGR3Q2hhbk9mZnNldCAweCVsbFhcbiIs
CiAgICAgICAgICBNT0RVTEVfTkFNRSwgZHdDaGFuT2Zmc2V0ICsgMHgwMDBDKTsKCiAgICAvKiBH
ZXQgSU5URVJSVVBUX1NUQVRVU19SRUcgKi8KICAgIG1fYUNhcmRzW2JDYXJkTnVtXS5DaGFubmVs
LmR3SW50U3RhdHVzID0gKF9fdTMyKXJlYWR3KCh2b2lkKikoZHdDaGFuT2Zmc2V0ICsgMHgwMDBD
KSk7CiAgICBERUJVRygxMCwgIiVzOiBwY21hY2VfaXNyOiAwMlxuIiwgTU9EVUxFX05BTUUpOwoK
ICAgIC8qIFdha2UgdXAgdGhlIGJsb2NrZWQgZHJpdmVyIGxldmVsIElTUiB0aHJlYWQgKi8KICAg
IHdha2VfdXBfaW50ZXJydXB0aWJsZSgmbV9hcFdhaXRRdWVbYkNhcmROdW1dKTsKICAgIG1fYXBX
YWl0RmxhZyA9IDE7CiAgICBERUJVRygxMCwgIiVzOiBwY21hY2VfaXNyOiAwM1xuIiwgTU9EVUxF
X05BTUUpOwoKICAgIC8qIE1ha2Ugc3VyZSBJbnRlcnJ1cHQgU3RhdHVzIFJlZyBpcyB2YWxpZCAq
LwogICAgaWYgKG1fYUNhcmRzW2JDYXJkTnVtXS5DaGFubmVsLmR3SW50U3RhdHVzKQogICAgewog
ICAgICAgIERFQlVHKDEwLCAiJXM6IHBjbWFjZV9pc3I6IDA0XG4iLCBNT0RVTEVfTkFNRSk7CiAg
ICAgICAgLyogQ2hlY2sgZm9yIEJDIEVPRiBJbnRlcnJ1cHQgKi8KICAgICAgICBiQkNFb2YgPSAo
KHdJbnRTdGF0UmVnID4+IDMpICYgMHgxKTsKICAgICAgICBERUJVRygxMCwgIiVzOiBsZWdhY3kg
QUNFIGlzcjogMDVcbiIsIE1PRFVMRV9OQU1FKTsKCiAgICAgICAgLyogRmxpcCBCQyBTdGFja3Mg
aWYgRU9GIEludCBhbmQgaXRzIGVuYWJsZWQgKi8KICAgICAgICBpZiAoKG1fYUNhcmRzW2JDYXJk
TnVtXS5DaGFubmVsLmJBdXRvRmxpcFN0aykgJiYgKGJCQ0VvZikpCiAgICAgICAgewogICAgICAg
ICAgICBERUJVRygxMCwgIiVzOiBsZWdhY3kgQUNFIGlzcjogMDZcbiIsIE1PRFVMRV9OQU1FKTsK
ICAgICAgICAgICAgLyogR2V0IENPTkZJR19SRUdfMSAqLwogICAgICAgICAgICB3Q2ZnUmVnMSA9
IHJlYWR3KCh2b2lkKikoZHdDaGFuT2Zmc2V0ICsgMHgwMDAyKSk7CiAgICAgICAgICAgIERFQlVH
KDEwLCAiJXM6IGxlZ2FjeSBBQ0UgaXNyOiAwN1xuIiwgTU9EVUxFX05BTUUpOwoKICAgICAgICAg
ICAgLyogR2V0IEN1cnJlbnQgQkMgU3RhY2sgQXJlYSAqLwogICAgICAgICAgICBiQ3VyQXJlYSA9
ICgod0NmZ1JlZzEgPj4gMTMpICYgMHgxKTsKICAgICAgICAgICAgREVCVUcoMTAsICIlczogbGVn
YWN5IEFDRSBpc3I6IDA4XG4iLCBNT0RVTEVfTkFNRSk7CiAgICAgICAgICAgIGlmIChiQ3VyQXJl
YSkgIC8qIEEgKi8KICAgICAgICAgICAgewogICAgICAgICAgICAgICAgREVCVUcoMTAsICIlczog
bGVnYWN5IEFDRSBpc3I6IDA5XG4iLCBNT0RVTEVfTkFNRSk7CiAgICAgICAgICAgICAgICB3cml0
ZXcod0NmZ1JlZzEmMHhERkZGLCh2b2lkKikoZHdDaGFuT2Zmc2V0ICsgMHgwMDAyKSk7CiAgICAg
ICAgICAgICAgICBERUJVRygxMCwgIiVzOiBsZWdhY3kgQUNFIGlzcjogMTBcbiIsIE1PRFVMRV9O
QU1FKTsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlICAvKiBCICovCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIERFQlVHKDEwLCAiJXM6IGxlZ2FjeSBBQ0UgaXNyOiAxMVxuIiwg
TU9EVUxFX05BTUUpOwogICAgICAgICAgICAgICAgd3JpdGV3KHdDZmdSZWcxfDB4MjAwMCwodm9p
ZCopKGR3Q2hhbk9mZnNldCArIDB4MDAwMikpOwogICAgICAgICAgICAgICAgREVCVUcoMTAsICIl
czogbGVnYWN5IEFDRSBpc3I6IDEyXG4iLCBNT0RVTEVfTkFNRSk7CiAgICAgICAgICAgIH0KICAg
ICAgICAgICAgREVCVUcoMTAsICIlczogbGVnYWN5IEFDRSBpc3I6IDEzXG4iLCBNT0RVTEVfTkFN
RSk7CiAgICAgICAgfQogICAgICAgIERFQlVHKDEwLCAiJXM6IGxlZ2FjeSBBQ0UgaXNyOiAxNFxu
IiwgTU9EVUxFX05BTUUpOwogICAgfQogICAgLyogQ2xlYXIgSW50ZXJydXB0ICovCiAgICBERUJV
RygxMCwgIiVzOiBsZWdhY3kgQUNFIGlzcjogMTVcbiIsIE1PRFVMRV9OQU1FKTsKICAgIHdyaXRl
dygweDAwMDQsKHZvaWQqKShkd0NoYW5PZmZzZXQgKyAweDAwMDYpKTsKICAgIERFQlVHKDEwLCAi
JXM6IGxlZ2FjeSBBQ0UgaXNyOiAxNlxuIiwgTU9EVUxFX05BTUUpOwoKICAgIHJldHVybiAwOwp9
CgovKiBJU1IgZm9yIEVuaGFuY2VkIE1pbmktQUNFIGRldmljZXMuICovCnN0YXRpYyBpcnFyZXR1
cm5fdCBwY21lbWFjZV9pc3IoaW50IGlycSwgdm9pZCogZGV2X2lkLCBzdHJ1Y3QgcHRfcmVncyAq
cmVncykKewogICAgX191OCAqcGJDYXJkTnVtOyAgICAgIC8qIEluZGljYXRlcyB3aGljaCBjYXJk
IGlzc3VlZCB0aGUgaW50ZXJydXB0LiAqLwogICAgX191NjQgIGR3Q2hhbk9mZnNldDsgIC8qIEhv
bGRzIHRoZSBjaGFubmVsJ3MgUmVnIGJhc2UgYWRkciAqLwogICAgX191MzIgIGR3SW50U3RhdHVz
OyAgIC8qIEhvbGRzIHRoZSBjaGFubmVsJ3MgUmVnIGJhc2UgYWRkciAqLwoKICAgIERFQlVHKDEw
LCAiJXM6IGVudGVyaW5nIEVuaGFuY2VkIE1pbmktQUNFIGlzclxuIiwgTU9EVUxFX05BTUUpOwoK
ICAgIHBiQ2FyZE51bSA9IGRldl9pZDsKCiAgICAvKiBHZXQgQ2hhbm5lbCBPZmZzZXQgKi8KICAg
IGR3Q2hhbk9mZnNldCA9IChfX3UzMikobV9hQ2FyZHNbKnBiQ2FyZE51bV0uZHdSZWdXbmRLcm5B
ZGRyICsgMHgwMDgwKTsgLyogcmVnIHNwYWNlID0gMHg4MCAqLwoKICAgIC8qIE5VTEwgb3V0IHN0
YXR1cyB2YXJpYWJsZSBhbmQgZ2V0IElOVEVSUlVQVF9TVEFUVVNfUkVHJ3MgKi8KICAgIGR3SW50
U3RhdHVzICA9IDA7CiAgICBkd0ludFN0YXR1cyAgPSByZWFkdygodm9pZCopKGR3Q2hhbk9mZnNl
dCArIDB4MDAwM0MpKSA8PCAxNjsKICAgIGR3SW50U3RhdHVzIHw9IHJlYWR3KCh2b2lkKikoZHdD
aGFuT2Zmc2V0ICsgMHgwMDBDKSk7CgogICAgLyogSWYgdGhlcmUgaXMgbm8gc3RhdHVzLCB3ZSBk
aWRuJ3QgZ2VuZXJhdGUgdGhlIGludGVycnVwdC4gKi8KICAgIGlmKCAhZHdJbnRTdGF0dXMgKQog
ICAgICAgICAgICByZXR1cm4gMDsgLyogTm90IHVzLCByZXR1cm4gdG8gT1MgKi8KCiAgICAvKiBB
c3NpZ24gdGhlIHJlYWQgc3RhdHVzIHRvIHRoZSBjYXJkIHN0cnVjdHVyZSBzbyB0aGUgSU9DVEwg
Y2FuIHJldHVybiBpdCB0byB1c2VyIHNwYWNlLiAqLwogICAgbV9hQ2FyZHNbKnBiQ2FyZE51bV0u
Q2hhbm5lbC5kd0ludFN0YXR1cyA9IGR3SW50U3RhdHVzOwoKICAgIC8qIFdha2UgdXAgdGhlIGJs
b2NrZWQgZHJpdmVyIGxldmVsIElTUiB0aHJlYWQgKi8KICAgIHdha2VfdXBfaW50ZXJydXB0aWJs
ZSgmbV9hcFdhaXRRdWVbKnBiQ2FyZE51bV0pOwogICAgbV9hcFdhaXRGbGFnID0gMTsKCiAgICAv
KiBDbGVhciBJbnRlcnJ1cHQgKi8KICAgIGlmKCAhKHJlYWR3KCh2b2lkKikoZHdDaGFuT2Zmc2V0
ICsgMHgwMDA0KSkgJiAweDAwMTApICkKICAgICAgICB3cml0ZXcoMHgwMDA0LCh2b2lkKikoZHdD
aGFuT2Zmc2V0ICsgMHgwMDA2KSk7CgogICAgcmV0dXJuIDA7Cn0KCi8qKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAqIEZ1
bmN0aW9uOiBwY21hY2VfZm9wc19pb2N0bCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqCiAqIERlc2NyaXB0aW9uOiBIYW5kbGVzIGFsbCBpb2N0bCBjYWxs
cyB0byBkZXZpY2UgZHJpdmVyICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIFBhcmFtZXRlcnM6
ICAgaW5vZGUgICAgLSB1c2VkIHRvIGdldCBNaW5vciBudW1iZXIgICAgICAgICAgICAgICAqCiAq
ICAgICAgICAgICAgICAgZmxpcCAgICAgLSBOb3QgVXNlZCAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAqCiAqICAgICAgICAgICAgICAgd0NtZCAgICAgLSBpb2N0bCBjb21tYW5kIHJlcXVl
c3RlZCAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgZHdQYXJhbSAgLSBpb2N0bCBy
ZXR1cm4gZGF0YSB2YXJpYWJsZSAgICAgICAgICAgICAqCiAqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwpzdGF0aWMgaW50
IHBjbWFjZV9mb3BzX2lvY3RsKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmbGlw
LCB1bnNpZ25lZCBpbnQgd0NtZCwgdW5zaWduZWQgbG9uZyBkd1BhcmFtKQp7CiAgICBpbnQgICAg
IG5SZXN1bHQgICAgID0gU1RBVFVTX0FDRTUzX1NVQ0NFU1M7ICAgLyogcmV0dXJuIHZhbHVlICov
CiAgICBfX3U4ICAgIGJDYXJkTnVtICAgID0gTUlOT1IoaW5vZGUtPmlfcmRldik7ICAgLyogQ2Fy
ZCBudW1iZXIgaW4gc3lzdGVtICgwIC0gMykgKi8KICAgIF9fdTggICAgICpicENhcmROdW0gPSAm
bV9EZXZfaWRbYkNhcmROdW1dOyAvKmptZiB1c2VkIHRvIHJlZ2lzdGVyIGludGVycnVwdHMgc2Vw
ZXJhdGxleSBmb3IgZWFjaCBjYXJkICovCiAgICBfX3UzMiAgICBkd0ZsYWdzICAgICA9IDB4MDAw
MDAwMDA7ICAgICAgICAgICAgICAvKiB0ZW1wIHZhcmlhYmxlcyBmb3IgY2xpKCkgKi8KICAgIGly
cXJldHVybl90ICgqcGZJc3IpKGludCwgdm9pZCosIHN0cnVjdCBwdF9yZWdzKikgPSBOVUxMOwoK
LyoKICAgIERFQlVHKDEwLCAiJXM6IGVudGVyaW5nIGZvcHNfaW9jdGw6IGNtZCAldVxuIiwgTU9E
VUxFX05BTUUsIHdDbWQpOwogICAgREVCVUcoODAsICIlczogR0VUX1ZFUlNJT049JWxkXG4iLCBN
T0RVTEVfTkFNRSwgSU9DVExfQUNFNTNfR0VUX1ZFUlNJT04pOwogICAgREVCVUcoODAsICIlczog
R0VUX0NBUkRfSU5GTz0lbGRcbiIsIE1PRFVMRV9OQU1FLCBJT0NUTF9BQ0U1M19HRVRfQ0FSRF9J
TkZPKTsKICAgIERFQlVHKDgwLCAiJXM6IEdFVF9DSEFOTkVMX0lORk89JWxkXG4iLCBNT0RVTEVf
TkFNRSwgSU9DVExfQUNFNTNfR0VUX0NIQU5ORUxfSU5GTyk7CiAgICBERUJVRyg4MCwgIiVzOiBC
TE9DS19JTl9EUklWRVI9JWxkXG4iLCBNT0RVTEVfTkFNRSwgSU9DVExfQUNFNTNfQkxPQ0tfSU5f
RFJJVkVSKTsKICAgIERFQlVHKDgwLCAiJXM6IEJDX0FVVE9fRkxJUFNUSz0lbGRcbiIsIE1PRFVM
RV9OQU1FLCBJT0NUTF9BQ0U1M19CQ19BVVRPX0ZMSVBTVEspOwogICAgREVCVUcoODAsICIlczog
SU5TVEFMTF9JUlE9JWRcbiIsIE1PRFVMRV9OQU1FLCBJT0NUTF9BQ0U1M19JTlNUQUxMX0lSUSk7
CiAgICBERUJVRyg4MCwgIiVzOiBVTklOU1RBTExfSVJRPSVkXG4iLCBNT0RVTEVfTkFNRSwgSU9D
VExfQUNFNTNfVU5JTlNUQUxMX0lSUSk7CiAgICBkdW1wU3RydWN0KCk7CiovCgogICAgLyogUHJv
Y2VzcyB0aGUgY29tbWFuZC4gKi8KICAgIHN3aXRjaCh3Q21kKQogICAgewogICAgICAgIC8qIEdl
dCBEcml2ZXIgVmVyc2lvbiAqLwogICAgICAgIGNhc2UgSU9DVExfQUNFNTNfR0VUX1ZFUlNJT046
CiAgICAgICAgICAgIERFQlVHKDEwLCAiJXM6IGZvcHNfaW9jdGw6IEdFVF9WRVJTSU9OXG4iLCBN
T0RVTEVfTkFNRSk7CiAgICAgICAgICAgICooX191MzIgKilkd1BhcmFtID0gQUNFNTNfVkVSU0lP
TjsKICAgICAgICAgICAgYnJlYWs7CgogICAgICAgIC8qIEJDIEF1dG8gRmxpcCBTdGFjayAqLwog
ICAgICAgIGNhc2UgSU9DVExfQUNFNTNfQkNfQVVUT19GTElQU1RLOgogICAgICAgICAgICBERUJV
RygxMCwgIiVzOiBmb3BzX2lvY3RsOiBCQ19BVVRPX0ZMSVBTVEtcbiIsIE1PRFVMRV9OQU1FKTsK
ICAgICAgICAgICAgbV9hQ2FyZHNbYkNhcmROdW1dLkNoYW5uZWwuYkF1dG9GbGlwU3RrID0gKihf
X3UzMiAqKWR3UGFyYW07CiAgICAgICAgICAgIGJyZWFrOwoKICAgICAgICAvKiBHZXQgc3BlY2lm
aWMgY2FyZCdzIGluZm9ybWF0aW9uICovCiAgICAgICAgY2FzZSBJT0NUTF9BQ0U1M19HRVRfQ0FS
RF9JTkZPOgogICAgICAgICAgICBERUJVRygxMCwgIiVzOiBmb3BzX2lvY3RsOiBHRVRfQ0FSRF9J
TkZPXG4iLCBNT0RVTEVfTkFNRSk7CiAgICAgICAgICAgICgocEFDRTUzX0NBUkQpZHdQYXJhbSkt
PnBsaW5rICAgICAgICAgICAgICA9IG1fYUNhcmRzW2JDYXJkTnVtXS5wbGluazsKICAgICAgICAg
ICAgKChwQUNFNTNfQ0FSRClkd1BhcmFtKS0+YlBjaUJ1c051bSAgICAgICAgID0gbV9hQ2FyZHNb
YkNhcmROdW1dLmJQY2lCdXNOdW07CiAgICAgICAgICAgICgocEFDRTUzX0NBUkQpZHdQYXJhbSkt
PmJQY2lEZXZOdW0gICAgICAgICA9IG1fYUNhcmRzW2JDYXJkTnVtXS5iUGNpRGV2TnVtOwogICAg
ICAgICAgICAoKHBBQ0U1M19DQVJEKWR3UGFyYW0pLT5iUGNpRmNuTnVtICAgICAgICAgPSBtX2FD
YXJkc1tiQ2FyZE51bV0uYlBjaUZjbk51bTsKICAgICAgICAgICAgKChwQUNFNTNfQ0FSRClkd1Bh
cmFtKS0+Yk1ham9yICAgICAgICAgICAgID0gTUFKT1IoaW5vZGUtPmlfcmRldik7CiAgICAgICAg
ICAgICgocEFDRTUzX0NBUkQpZHdQYXJhbSktPmJNaW5vciAgICAgICAgICAgICA9IE1JTk9SKGlu
b2RlLT5pX3JkZXYpOwogICAgICAgICAgICAoKHBBQ0U1M19DQVJEKWR3UGFyYW0pLT53RGV2aWNl
SUQgICAgICAgICAgPSBtX2FDYXJkc1tiQ2FyZE51bV0ud0RldmljZUlEOwogICAgICAgICAgICAo
KHBBQ0U1M19DQVJEKWR3UGFyYW0pLT5kd0NhcmRJRCAgICAgICAgICAgPSBtX2FDYXJkc1tiQ2Fy
ZE51bV0uZHdDYXJkSUQ7CiAgICAgICAgICAgICgocEFDRTUzX0NBUkQpZHdQYXJhbSktPmR3Q2hh
bk1lbUxlbiAgICAgICA9IG1fYUNhcmRzW2JDYXJkTnVtXS5kd0NoYW5NZW1MZW47CiAgICAgICAg
ICAgICgocEFDRTUzX0NBUkQpZHdQYXJhbSktPndJcnEgICAgICAgICAgICAgICA9IG1fYUNhcmRz
W2JDYXJkTnVtXS53SXJxOwogICAgICAgICAgICAoKHBBQ0U1M19DQVJEKWR3UGFyYW0pLT5iTnVt
Q2hubHMgICAgICAgICAgPSBtX2FDYXJkc1tiQ2FyZE51bV0uYk51bUNobmxzOwogICAgICAgICAg
ICAoKHBBQ0U1M19DQVJEKWR3UGFyYW0pLT5kd01lbVduZFBjbWNpYUFkZHIgPSBtX2FDYXJkc1ti
Q2FyZE51bV0uZHdNZW1XbmRQY21jaWFBZGRyOwogICAgICAgICAgICAoKHBBQ0U1M19DQVJEKWR3
UGFyYW0pLT5kd1JlZ1duZFBjbWNpYUFkZHIgPSBtX2FDYXJkc1tiQ2FyZE51bV0uZHdSZWdXbmRQ
Y21jaWFBZGRyOwogICAgICAgICAgICAoKHBBQ0U1M19DQVJEKWR3UGFyYW0pLT5kd1JlZ1duZEty
bkFkZHIgICAgPSBtX2FDYXJkc1tiQ2FyZE51bV0uZHdSZWdXbmRLcm5BZGRyOwogICAgICAgICAg
ICAoKHBBQ0U1M19DQVJEKWR3UGFyYW0pLT5DaGFubmVsICAgICAgICAgICAgPSBtX2FDYXJkc1ti
Q2FyZE51bV0uQ2hhbm5lbDsKICAgICAgICAgICAgYnJlYWs7CgogICAgICAgIC8qIEdldCBTcGVj
aWZpYyBjaGFubmVsJ3MgaW5mb3JtYXRpb24gKi8KICAgICAgICBjYXNlIElPQ1RMX0FDRTUzX0dF
VF9DSEFOTkVMX0lORk86CiAgICAgICAgICAgIERFQlVHKDEwLCAiJXM6IGZvcHNfaW9jdGw6IEdF
VF9DSEFOTkVMX0lORk9cbiIsIE1PRFVMRV9OQU1FKTsKICAgICAgICAgICAgKChwQUNFX0NIQU5O
RUwpZHdQYXJhbSktPmJDYXJkTnVtICAgICAgICA9ICAgIG1fYUNhcmRzW2JDYXJkTnVtXS5DaGFu
bmVsLmJDYXJkTnVtOwogICAgICAgICAgICAoKHBBQ0VfQ0hBTk5FTClkd1BhcmFtKS0+YkNoYW5O
dW0gICAgICAgID0gbV9hQ2FyZHNbYkNhcmROdW1dLkNoYW5uZWwuYkNoYW5OdW07CiAgICAgICAg
ICAgICgocEFDRV9DSEFOTkVMKWR3UGFyYW0pLT5kd01lbVduZFVzckFkZHIgPSAgICBtX2FDYXJk
c1tiQ2FyZE51bV0uQ2hhbm5lbC5kd01lbVduZFVzckFkZHI7CiAgICAgICAgICAgICgocEFDRV9D
SEFOTkVMKWR3UGFyYW0pLT5kd1JlZ1duZFVzckFkZHIgPSAgICBtX2FDYXJkc1tiQ2FyZE51bV0u
Q2hhbm5lbC5kd1JlZ1duZFVzckFkZHI7CiAgICAgICAgICAgICgocEFDRV9DSEFOTkVMKWR3UGFy
YW0pLT53SXJxICAgICAgICAgICAgPSAgICBtX2FDYXJkc1tiQ2FyZE51bV0ud0lycTsKICAgICAg
ICAgICAgKChwQUNFX0NIQU5ORUwpZHdQYXJhbSktPmJCbG9ja2VkICAgICAgICA9ICAgIG1fYUNh
cmRzW2JDYXJkTnVtXS5DaGFubmVsLmJCbG9ja2VkOwogICAgICAgICAgICAoKHBBQ0VfQ0hBTk5F
TClkd1BhcmFtKS0+Yk1tYXBXaW5OdW0gICAgID0gbV9hQ2FyZHNbYkNhcmROdW1dLkNoYW5uZWwu
Yk1tYXBXaW5OdW07CiAgICAgICAgICAgICgocEFDRV9DSEFOTkVMKWR3UGFyYW0pLT5iSXNyRW5h
YmxlZCAgICAgPSBtX2FDYXJkc1tiQ2FyZE51bV0uQ2hhbm5lbC5iSXNyRW5hYmxlZDsKICAgICAg
ICAgICAgKChwQUNFX0NIQU5ORUwpZHdQYXJhbSktPmJPcGVuICAgICAgICAgICA9IG1fYUNhcmRz
W2JDYXJkTnVtXS5DaGFubmVsLmJPcGVuOwogICAgICAgICAgICBicmVhazsKCiAgICAgICAgLyog
QmxvY2sgRHJpdmVyIChTbGVlcCBUaHJlYWQpICovCiAgICAgICAgY2FzZSBJT0NUTF9BQ0U1M19C
TE9DS19JTl9EUklWRVI6CiAgICAgICAgICAgIERFQlVHKDEwLCAiJXM6IGZvcHNfaW9jdGw6IEJM
T0NLX0lOX0RSSVZFUlxuIiwgTU9EVUxFX05BTUUpOwogICAgICAgICAgICBERUJVRyg4MCwgIiVz
OiBmb3BzX2lvY3RsOiBwYXJhbTEgMHglbFhcbiIsIE1PRFVMRV9OQU1FLCBkd1BhcmFtKTsKICAg
ICAgICAgICAgc2F2ZV9mbGFncyhkd0ZsYWdzKTsgLyogU2F2ZSBwcm9jZXNzb3Igc3RhdGUgKi8K
ICAgICAgICAgICAgY2xpKCk7ICAgICAgICAgICAgICAgLyogRGlzYWJsZSBpbnRlcnJ1cHRzICov
CgogICAgICAgICAgICAgLyogSWYgaW50ZXJydXB0cyBhcmUgZGlzYWJsZWQuLiAqLwogICAgICAg
ICAgICBpZiggIW1fYUNhcmRzW2JDYXJkTnVtXS5DaGFubmVsLmJJc3JFbmFibGVkICkKICAgICAg
ICAgICAgewogICAgICAgICAgICAgICAgcmVzdG9yZV9mbGFncyhkd0ZsYWdzKTsgIC8qIFJlc3Rv
cmUgcHJvY2Vzc29yIHN0YXRlICovCiAgICAgICAgICAgICAgICBzdGkoKTsgICAgICAgICAgICAg
ICAgICAgLyogRW5hYmxlIGludGVycnVwdHMgKi8KICAgICAgICAgICAgICAgIG5SZXN1bHQgPSBT
VEFUVVNfQUNFNTNfSU9DVExfSU5URVJSVVBUX05PVF9FTkFCTEVEOwogICAgICAgICAgICAgICAg
YnJlYWs7CiAgICAgICAgICAgIH0KICAgICAgICAgICAgLyogSW50ZXJydXB0cyBhcmUgZW5hYmxl
ZC4uLiAqLwogICAgICAgICAgICByZXN0b3JlX2ZsYWdzKGR3RmxhZ3MpOyAvKiBSZXN0b3JlIHBy
b2Nlc3NvciBzdGF0ZSAqLwogICAgICAgICAgICBzdGkoKTsgICAgICAgICAgICAgICAgICAvKiBm
bGFncyBhbmQgZW5hYmxlIGludGVycnVwdHMgKi8KCiAgICAgICAgICAgIC8qIFB1dCB0byBzbGVl
cCB1bnRpbCBpbnRlcnJ1cHQgb3IgdW5pbnN0YWxsIHdha2VzIHVzICovCiAgICAgICAgICAgIC8v
aW50ZXJydXB0aWJsZV9zbGVlcF9vbigmbV9hcFdhaXRRdWVbYkNhcmROdW1dKTsKICAgICAgICAg
ICAgREVCVUcoODAsICIlczogZm9wc19pb2N0bDogQkxPQ0tfSU5fRFJJVkVSOiBiZWZvcmUgd2Fp
dFxuIiwKICAgICAgICAgICAgICAgICAgTU9EVUxFX05BTUUpOwogICAgICAgICAgICBERUJVRyg4
MCwgIiVzOiBmb3BzX2lvY3RsOiBwYXJhbTIgMHglbFhcbiIsIE1PRFVMRV9OQU1FLCBkd1BhcmFt
KTsKICAgICAgICAgICAgKihfX3UzMiAqKWR3UGFyYW0gPSAwOwogICAgICAgICAgICB3YWl0X2V2
ZW50X2ludGVycnVwdGlibGUobV9hcFdhaXRRdWVbYkNhcmROdW1dLCBtX2FwV2FpdEZsYWcgIT0g
MCk7CiAgICAgICAgICAgIERFQlVHKDgwLCAiJXM6IGZvcHNfaW9jdGw6IEJMT0NLX0lOX0RSSVZF
UjogYWZ0ZXIgd2FpdFxuIiwKICAgICAgICAgICAgICAgICAgTU9EVUxFX05BTUUpOwogICAgICAg
ICAgICBtX2FwV2FpdEZsYWcgPSAwOwoKICAgICAgICAgICAgLyogU2F2ZSBJbnRlcnJ1cHQgU3Rh
dHVzIFJlZ2lzdGVyICovCiAgICAgICAgICAgIERFQlVHKDgwLCAiJXM6IGZvcHNfaW9jdGw6IHBh
cmFtMyAweCVsWFxuIiwgTU9EVUxFX05BTUUsIGR3UGFyYW0pOwogICAgICAgICAgICBkdW1wU3Ry
dWN0KCk7CiAgICAgICAgICAgICooX191MzIgKilkd1BhcmFtID0gbV9hQ2FyZHNbYkNhcmROdW1d
LkNoYW5uZWwuZHdJbnRTdGF0dXM7IC8qIHRoaXMgd2FzIDE2IGJpdCBjYXN0IGZvciBBQ0UuICBJ
cyB0aGlzIGEgcHJvYmxlbT8gIGt3aCAqLwoKICAgICAgICAgICAgYnJlYWs7CiAgICAgICAgLyog
SW5zdGFsbCBJbnRlcnJ1cHQgc3VwcG9ydCAqLwogICAgICAgIGNhc2UgSU9DVExfQUNFNTNfSU5T
VEFMTF9JUlE6CiAgICAgICAgICAgIERFQlVHKDEwLCAiJXM6IGZvcHNfaW9jdGw6IElOU1RBTExf
SVJRXG4iLCBNT0RVTEVfTkFNRSk7CiAgICAgICAgICAgIHNhdmVfZmxhZ3MoZHdGbGFncyk7ICAg
LyogU2F2ZSBwcm9jZXNzb3Igc3RhdGUgKi8KICAgICAgICAgICAgY2xpKCk7ICAgICAgICAgICAg
ICAgICAvKiBEaXNhYmxlIGludGVycnVwdHMgKi8KCiAgICAgICAgICAgIC8qIElmIGFscmVhZHkg
ZW5hYmxlZCwgcmV0dXJuIGVycm9yLiAqLwogICAgICAgICAgICBpZihtX2FDYXJkc1tiQ2FyZE51
bV0uQ2hhbm5lbC5iSXNyRW5hYmxlZCApCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIC8q
IHJlc3RvcmUgc3RhdGUgYW5kIHJldHVybiBlcnJvciAqLwogICAgICAgICAgICAgICAgcmVzdG9y
ZV9mbGFncyhkd0ZsYWdzKTsKICAgICAgICAgICAgICAgIHN0aSgpOwogICAgICAgICAgICAgICAg
blJlc3VsdCA9ICBTVEFUVVNfQUNFNTNfSU9DVExfSVJRX0FMUkVBRFlfSU5TVEFMTEVEOwogICAg
ICAgICAgICAgICAgYnJlYWs7CiAgICAgICAgICAgIH0KCiAgICAgICAgICAgIC8qIE90aGVyd2lz
ZSwgZmxhZyBzdGF0dXMgYXMgZW5hYmxlZCBhbmQgaW5zdGFsbC4gKi8KICAgICAgICAgICAgbV9h
Q2FyZHNbYkNhcmROdW1dLkNoYW5uZWwuYklzckVuYWJsZWQgPSAxOwogICAgICAgICAgICByZXN0
b3JlX2ZsYWdzKGR3RmxhZ3MpOwogICAgICAgICAgICBzdGkoKTsKCiAgICAgICAgICAgIC8qIENy
ZWF0ZSB0aGUgZGV2aWNlIHN0cmluZyBuYW1lIGZvciB1c2UgaW4gJy9wcm9jL2ludGVycnVwdHMn
ICovCiAgICAgICAgICAgIG1fc0Rldk5hbWVbOV0gPSAnYScgKyBiQ2FyZE51bTsKICAgICAgICAg
ICAgbV9zRGV2TmFtZVsxMF0gPSAnXDAnOwoKICAgICAgICAgICAgLyogRGV0ZXJtaW5lIHdoaWNo
IElTUiB0byBiaW5kIHRvIHRoZSBpbnRlcnJ1cHQuICovCiAgICAgICAgICAgIGlmKCBtX2FDYXJk
c1tiQ2FyZE51bV0uZHdDYXJkSUQgPT0gREVWSURfQlU2NTU1M00yXzMwMCApCiAgICAgICAgICAg
ICAgICBwZklzciA9IHBjbWVtYWNlX2lzcjsKICAgICAgICAgICAgZWxzZSBpZiggbV9hQ2FyZHNb
YkNhcmROdW1dLmR3Q2FyZElEID09IERFVklEX0JVNjU1NTBNMl8zMDAgfHwKICAgICAgICAgICAg
ICAgICAgICAgbV9hQ2FyZHNbYkNhcmROdW1dLmR3Q2FyZElEID09IERFVklEX0JVNjU1NTBNMl82
MDIgfHwKICAgICAgICAgICAgICAgICAgICAgbV9hQ2FyZHNbYkNhcmROdW1dLmR3Q2FyZElEID09
IERFVklEX0JVNjU1NTBNMl82MDUgfHwKICAgICAgICAgICAgICAgICAgICAgbV9hQ2FyZHNbYkNh
cmROdW1dLmR3Q2FyZElEID09IERFVklEX0JVNjU1NTFNMl8zMDAgfHwKICAgICAgICAgICAgICAg
ICAgICAgbV9hQ2FyZHNbYkNhcmROdW1dLmR3Q2FyZElEID09IERFVklEX0JVNjU1NTJNMl8zMDAg
ICAgKQogICAgICAgICAgICAgICAgcGZJc3IgPSBwY21hY2VfaXNyOwogICAgICAgICAgICBlbHNl
CiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIG5SZXN1bHQgPSBTVEFUVVNfQUNFNTNfREVW
SUNFX05PVF9FWElTVDsKICAgICAgICAgICAgICAgIGJyZWFrOwogICAgICAgICAgICB9CgogICAg
ICAgICAgICAvKiBSZWdpc3RlciB0aGUgSVJRIHdpdGggdGhlIGtlcm5lbC4gKi8KICAgICAgICAg
ICAgaWYoIHJlcXVlc3RfaXJxKG1fYUNhcmRzW2JDYXJkTnVtXS53SXJxLCAgICAvKiBJUlEgTnVt
YmVyICovCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBwZklzciwgICAgICAgICAgICAgICAg
ICAgICAgLyogSVNSIEZ1bmN0aW9uICovCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBJUlFG
X1NIQVJFRCB8IElSUUZfRElTQUJMRUQsLyogU2xvdyBJU1IgKi8KICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIG1fc0Rldk5hbWUsICAgICAgICAgICAgICAgICAvKiBzdHJpbmcgZm9yICdwcm9j
JyAqLwogICAgICAgICAgICAgICAgICAgICAgICAgICAgYnBDYXJkTnVtICkpICAgICAgICAgICAg
ICAgIC8qIGRldmljZSBpbmRlbnRpZmllciovCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAg
IC8qIGlmIHJlcXVlc3QgZmFpbHMuLi4uICovCiAgICAgICAgICAgICAgICBzYXZlX2ZsYWdzKGR3
RmxhZ3MpOwogICAgICAgICAgICAgICAgY2xpKCk7CiAgICAgICAgICAgICAgICBtX2FDYXJkc1ti
Q2FyZE51bV0uQ2hhbm5lbC5iSXNyRW5hYmxlZCA9IDA7CiAgICAgICAgICAgICAgICByZXN0b3Jl
X2ZsYWdzKGR3RmxhZ3MpOwogICAgICAgICAgICAgICAgc3RpKCk7CiAgICAgICAgICAgICAgICBu
UmVzdWx0ID0gU1RBVFVTX0FDRTUzX0lPQ1RMX1JFUVVFU1RfSVJRX0ZBSUw7CiAgICAgICAgICAg
ICAgICBicmVhazsKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICAgIAogICAgICAg
ICAgICBicmVhazsKCiAgICAgICAgY2FzZSBJT0NUTF9BQ0U1M19VTklOU1RBTExfSVJROiAgICAv
KiBDbGVhbnVwIGFuIGluc3RhbGxlZCBJUlEuICovCiAgICAgICAgICAgIERFQlVHKDEwLCAiJXM6
IGZvcHNfaW9jdGw6IFVOSU5TVEFMTF9JUlFcbiIsIE1PRFVMRV9OQU1FKTsKICAgICAgICAgICAg
LyogSWYgdGhlIGludGVycnVwdCBpcyBub3QgZW5hYmxlZCwgcmV0dXJuIGVycm9yLiAqLwogICAg
ICAgICAgICBzYXZlX2ZsYWdzKGR3RmxhZ3MpOwogICAgICAgICAgICBjbGkoKTsKICAgICAgICAg
ICAgaWYoICFtX2FDYXJkc1tiQ2FyZE51bV0uQ2hhbm5lbC5iSXNyRW5hYmxlZCApCiAgICAgICAg
ICAgIHsKICAgICAgICAgICAgICAgIHJlc3RvcmVfZmxhZ3MoZHdGbGFncyk7CiAgICAgICAgICAg
ICAgICBzdGkoKTsKICAgICAgICAgICAgICAgIG5SZXN1bHQgPSBTVEFUVVNfQUNFNTNfSU9DVExf
SVJRX05PVF9JTlNUQUxMRUQ7CiAgICAgICAgICAgICAgICBicmVhazsKICAgICAgICAgICAgfQoK
ICAgICAgICAgICAgLyogRmxhZyBjYXJkIHN0YXR1cyBhcyBkaXNhYmxlZC4gKi8KICAgICAgICAg
ICAgbV9hQ2FyZHNbYkNhcmROdW1dLkNoYW5uZWwuYklzckVuYWJsZWQgPSAwOwoKICAgICAgICAg
ICAgcmVzdG9yZV9mbGFncyhkd0ZsYWdzKTsKICAgICAgICAgICAgc3RpKCk7CgogICAgICAgICAg
ICAvKiBEZXJlZ2lzdGVyIHRoZSBpbnRlcnJ1cHQgYW5kIGZyZWUgdGhlIElSUS4gKi8KICAgICAg
ICAgICAgZnJlZV9pcnEobV9hQ2FyZHNbYkNhcmROdW1dLndJcnEsIGJwQ2FyZE51bSk7CgogICAg
ICAgICAgICAvKiBXYWtlIHVwIHRoZSBibG9ja2VkIElSUSB0aHJlYWQgc28gaXQgY2FuIHRlcm1p
bmF0ZS4gKi8KICAgICAgICAgICAgd2FrZV91cF9pbnRlcnJ1cHRpYmxlKCZtX2FwV2FpdFF1ZVti
Q2FyZE51bV0pOwogICAgICAgICAgICBtX2FwV2FpdEZsYWcgPSAxOwoKICAgICAgICAgICAgYnJl
YWs7CgogICAgICAgIGRlZmF1bHQ6CiAgICAgICAgICAgIERFQlVHKDEwLCAiJXM6IGVudGVyaW5n
IGZvcHNfaW9jdGw6IHVua25vd24gY21kICV1XG4iLCBNT0RVTEVfTkFNRSwgd0NtZCk7CiAgICAg
ICAgICAgIHJldHVybiBTVEFUVVNfQUNFNTNfSU9DVExfTk9UX0lNUExFTUVOVEVEOwogICAgICAg
IGJyZWFrOwogICAgfQoKICAgIGR1bXBTdHJ1Y3QoKTsKICAgIHJldHVybiBuUmVzdWx0Owp9Cgov
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKgogKiBGdW5jdGlvbjogcGNtYWNlX2ZvcHNfY29tcGF0X2lvY3RsICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBEZXNjcmlwdGlvbjogSGFuZGxl
cyBhbGwgMzJiIGlvY3RsIGNhbGxzIHRvIGRldmljZSBkcml2ZXIgICAgICAgKgogKiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KgogKiBQYXJhbWV0ZXJzOiAgIGZsaXAgICAgIC0gTm90IFVzZWQgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgIHdDbWQgICAgIC0gaW9jdGwgY29tbWFuZCBy
ZXF1ZXN0ZWQgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgIGR3UGFyYW0gIC0gaW9j
dGwgcmV0dXJuIGRhdGEgdmFyaWFibGUgICAgICAgICAgICAgKgogKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3RhdGlj
IGxvbmcgcGNtYWNlX2ZvcHNfY29tcGF0X2lvY3RsKHN0cnVjdCBmaWxlICpmbGlwLCB1bnNpZ25l
ZCBpbnQgd0NtZCwgdW5zaWduZWQgbG9uZyBkd1BhcmFtKQp7CiAgICBzdHJ1Y3QgaW5vZGUgaW5v
ZGU7CiAgICBpbnQgYkNhcmROdW07CgogICAgLyogV2UgbWFuYWdlIG9ubHkgb25lIGNhcmQgaW4g
Y29tcGF0aWJpbGl0eSBtb2RlICovCiAgICBpZiAobV9iTnVtYmVyT2ZDYXJkcyA+IDEpCiAgICAg
ICAgcmV0dXJuIFNUQVRVU19BQ0U1M19JT0NUTF9OT1RfSU1QTEVNRU5URUQ7CgogICAgLyogRmlu
ZCB0aGUgY2FyZCAqLwogICAgZm9yIChiQ2FyZE51bSA9IDA7IGJDYXJkTnVtIDwgQUNFNTNfTUFY
X05VTV9DQVJEUzsgYkNhcmROdW0rKykKICAgIHsKICAgICAgICBpZihtX2FDYXJkc1tiQ2FyZE51
bV0uQ2hhbm5lbC5iT3BlbiAhPSAwKQogICAgICAgIHsKICAgICAgICAgICAgaW5vZGUuaV9yZGV2
ID0gTUtERVYobV9hQ2FyZHNbYkNhcmROdW1dLmJNYWpvciwgYkNhcmROdW0pOwogICAgICAgICAg
ICByZXR1cm4gcGNtYWNlX2ZvcHNfaW9jdGwoJmlub2RlLCBmbGlwLCB3Q21kLCBkd1BhcmFtKTsK
ICAgICAgICB9CiAgICB9CgogICAgcmV0dXJuIFNUQVRVU19BQ0U1M19JT0NUTF9OT1RfSU1QTEVN
RU5URUQ7Cgp9CgovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKgogKiBGdW5jdGlvbjogcGNtYWNlX2ZvcHNfcmVsZWFzZSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBEZXNjcmlw
dGlvbjogSGFuZGxlcyBjbG9zaW5nIG9mIGEgc2luZ2xlIGNoYW5uZWwgKGRldmljZSkgICAgICAg
KgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKgogKiBQYXJhbWV0ZXJzOiAgIGlub2RlIC0gdXNlZCB0byBnZXQgdGhlIE1p
bm9yIE51bWJlciAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgIGZsaXAgIC0gTm90IFVz
ZWQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3RhdGlj
IGludCBwY21hY2VfZm9wc19yZWxlYXNlKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxl
ICpmaWxwKQp7CiAgICAvKiBPYnRhaW4gaW5kZXggaW50byBlbnVtZXJhdGVkIGNhcmQgbGlzdCBm
cm9tIGlub2RlLiAqLwogICAgX191OCAgICBiQ2FyZE51bSA9IE1JTk9SKGlub2RlLT5pX3JkZXYp
OyAgICAvKiBFbnVtZXJhdGVkIGRldmljZSAqLwoKICAgIERFQlVHKDEwLCAiJXM6IGVudGVyaW5n
IGZvcHNfcmVsZWFzZVxuIiwgTU9EVUxFX05BTUUpOwogICAgZHVtcFN0cnVjdCgpOwoKICAgIC8q
IERpc2FibGUgdGhlIGludGVycnVwdCBwcm9jZXNzaW5nIGZvciB0aGlzIGNoYW5uZWwgaWYgbm90
IGFscmVhZHkgZG9uZSBzby4gKi8KICAgIHBjbWFjZV9mb3BzX2lvY3RsKGlub2RlLCBmaWxwLCBJ
T0NUTF9BQ0U1M19VTklOU1RBTExfSVJRLCAwKTsKCiAgICAvKiBDaGVjayB0aGF0IG1pbm9yIG51
bWJlciBjb3JyZXNwb25kcyB0byBhIGNhcmQgaW5zdGFsbGVkIGluIHRoZSBzeXN0ZW0uICovCiAg
ICBpZiAoIGJDYXJkTnVtID49IG1fYk51bWJlck9mQ2FyZHMgKQogICAgICAgIHJldHVybiBTVEFU
VVNfQUNFNTNfREVWSUNFX05PVF9FWElTVDsKCiAgICAvKiBSZXR1cm4gZXJyb3IgaWYgYW4gYXR0
ZW1wdCB3YXMgbWFkZSB0byBjbG9zZSBhbiB1bm9wZW5lZCBjYXJkLiAqLwogICAgaWYgKG1fYUNh
cmRzW2JDYXJkTnVtXS5DaGFubmVsLmJPcGVuID09IDApCiAgICAgICAgcmV0dXJuIFNUQVRVU19B
Q0U1M19DQVJEX05PVF9PUEVOOwoKICAgIC8qIFVubWFwIHRoZSBjaGFubmVscyBSRUdJU1RFUiBt
ZW1vcnkgZnJvbSB1c2VyIHNwYWNlIChpZiBub3QgYWxyZWFkeSBkb25lKSAqLwogICAgaWYoIG1f
YUNhcmRzW2JDYXJkTnVtXS5DaGFubmVsLmR3UmVnV25kVXNyQWRkcikKICAgIHsKICAgICAgICBt
X2FDYXJkc1tiQ2FyZE51bV0uQ2hhbm5lbC5kd1JlZ1duZFVzckFkZHIgPSAoX191MzIpTlVMTDsK
ICAgIH0KCiAgICAvKiBVbm1hcCB0aGUgY2hhbm5lbHMgQUNFTUVNIG1lbW9yeSBmcm9tIHVzZXIg
c3BhY2UgKGlmIG5vdCBhbHJlYWR5IGRvbmUpICovCiAgICBpZiggbV9hQ2FyZHNbYkNhcmROdW1d
LkNoYW5uZWwuZHdNZW1XbmRVc3JBZGRyKQogICAgewogICAgICAgIG1fYUNhcmRzW2JDYXJkTnVt
XS5DaGFubmVsLmR3TWVtV25kVXNyQWRkciA9IChfX3UzMilOVUxMOwogICAgfQoKICAgIC8qIERl
ZmluZSBkZXZpY2UgYXMgY2xvc2VkICovCiAgICBtX2FDYXJkc1tiQ2FyZE51bV0uQ2hhbm5lbC5i
T3BlbiA9IDA7CgogICAgLyogVW5tYXAgdGhlIGNoYW5uZWwgUkVHSVNURVIgbWVtb3J5IGZyb20g
a2VybmVsIHNwYWNlIChpZiBub3QgYWxyZWFkeSBkb25lKSAqLwogICAgaWYoIG1fYUNhcmRzW2JD
YXJkTnVtXS5kd1JlZ1duZEtybkFkZHIgKQogICAgewogICAgICAgIGlvdW5tYXAoICh2b2lkKilt
X2FDYXJkc1tiQ2FyZE51bV0uZHdSZWdXbmRLcm5BZGRyICk7CiAgICAgICAgLyogR0xTICovCiAg
ICAgICAgcmVsZWFzZV9tZW1fcmVnaW9uKG1fYUNhcmRzW2JDYXJkTnVtXS5kd1JlZ1duZFBjbWNp
YUFkZHIsCiAgICAgICAgICAgICAgICAgICAgICAgICAgIEFDRTUzX0NIQU5fUkVHX0xFTkdUSCk7
CiAgICAgICAgbV9hQ2FyZHNbYkNhcmROdW1dLmR3UmVnV25kS3JuQWRkciA9IChfX3UzMilOVUxM
OwogICAgfQoKICAgIC8qIFVubWFwIHRoZSBjaGFubmVsIERBVEEgbWVtb3J5IGZyb20ga2VybmVs
IHNwYWNlIChpZiBub3QgYWxyZWFkeSBkb25lKSAqLwogICAgaWYoIG1fYUNhcmRzW2JDYXJkTnVt
XS5kd01lbVduZEtybkFkZHIgKQogICAgewogICAgICAgIGlvdW5tYXAoICh2b2lkKiltX2FDYXJk
c1tiQ2FyZE51bV0uZHdNZW1XbmRLcm5BZGRyICk7CiAgICAgICAgLyogR0xTICovCiAgICAgICAg
cmVsZWFzZV9tZW1fcmVnaW9uKG1fYUNhcmRzW2JDYXJkTnVtXS5kd01lbVduZFBjbWNpYUFkZHIs
CiAgICAgICAgICAgICAgICAgICAgICAgICAgIEFDRTUzX0NIQU5fTUVNX0xFTkdUSCk7CiAgICAg
ICAgbV9hQ2FyZHNbYkNhcmROdW1dLmR3TWVtV25kS3JuQWRkciA9IChfX3UzMilOVUxMOwogICAg
fQoKICAgIC8qIENsZWFyIG1tYXAgd2luZG93IGNvdW50LiAqLwogICAgbV9hQ2FyZHNbYkNhcmRO
dW1dLkNoYW5uZWwuYk1tYXBXaW5OdW0gPSAwOwoKICAgIC8qIEZsYWcgaW50ZXJydXB0cyBhcyBk
aXNhYmxlZC4gKi8KICAgIG1fYUNhcmRzW2JDYXJkTnVtXS5DaGFubmVsLmJJc3JFbmFibGVkID0g
MDsKCiAgICBkdW1wU3RydWN0KCk7CiAgICByZXR1cm4gU1RBVFVTX0FDRTUzX1NVQ0NFU1M7Cn0K
Ci8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqCiAqIEZ1bmN0aW9uOiBwY21hY2Vfdm1vcHNfY2xvc2UgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIERlc2NyaXB0aW9uOiBVc2Vk
IGluIGp1bmN0aW9uIHdpdGggdW5tYXBwaW5nIG1lbW9yeSAgICAgICAgICAgICAqCiAqICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAqCiAqIFBhcmFtZXRlcnM6ICAgdm1hIC0gaW5mb3JtYXRpb24gYWJvdXQgdGhlIHZtYSAgICAg
ICAgICAgICAgICAgICAqCiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqLwpzdGF0aWMgdm9pZCBwY21hY2Vfdm1vcHNfY2xv
c2Uoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpCnsKICAgIC8qIE9idGFpbiBpbmRleCBpbnRv
IGVudW1lcmF0ZWQgY2FyZCBsaXN0IGZyb20gaW5vZGUuICovCiAgICBfX3U4ICAgIHU4Q2FyZE51
bWJlciAgICAgPU1JTk9SKHZtYS0+dm1fZmlsZS0+Zl9kZW50cnktPmRfaW5vZGUtPmlfcmRldik7
ICAgIC8qIENhcmQgbnVtYmVyIGluIHN5c3RlbSAoMCAtIDMpICovCgogICAgREVCVUcoMTAsICIl
czogZW50ZXJpbmcgdm1vcHNfY2xvc2UgKCVkKVxuIiwKICAgICAgICAgIE1PRFVMRV9OQU1FLCBt
X2FDYXJkc1t1OENhcmROdW1iZXJdLkNoYW5uZWwuYk1tYXBXaW5OdW0pOwogICAgZHVtcFN0cnVj
dCgpOwoKICAgIC8qIEluZGljYXRlIGVycm9yIGlmIHRvbyBtYW55ICdtdW5tYXAncyB3ZXJlIGF0
dGVtcHRlZC4gKi8KICAgIGlmKCAobV9hQ2FyZHNbdThDYXJkTnVtYmVyXS5DaGFubmVsLmJNbWFw
V2luTnVtID09IDApIHx8CiAgICAgICAgKG1fYUNhcmRzW3U4Q2FyZE51bWJlcl0uQ2hhbm5lbC5i
TW1hcFdpbk51bSA+IDIpICkKCiAgICB7CiAgICAgICAgcHJpbnRrKCIlczogcGNtYWNlX3Ztb3Bz
X2Nsb3NlKCk6IFRvbyBtYW55ICdtdW5tYXAnIGF0dGVtcHRzIVxuIiwKICAgICAgICAgICAgICAg
TU9EVUxFX05BTUUpOwogICAgICAgIHJldHVybjsKICAgIH0KCiAgICAvKiBOdWxsIHVzZXIgd2lu
ZG93IHBvaW50ZXIgYW5kIGRlY3JlbWVudCAnbW1hcCcgY291bnQuICovCiAgICBpZiggdm1hLT52
bV9zdGFydCA9PSBtX2FDYXJkc1t1OENhcmROdW1iZXJdLkNoYW5uZWwuZHdSZWdXbmRVc3JBZGRy
ICkKICAgIHsKICAgICAgICBtX2FDYXJkc1t1OENhcmROdW1iZXJdLkNoYW5uZWwuZHdSZWdXbmRV
c3JBZGRyID0gKF9fdTMyKU5VTEw7CiAgICAgICAgbV9hQ2FyZHNbdThDYXJkTnVtYmVyXS5DaGFu
bmVsLmJNbWFwV2luTnVtLS07CiAgICB9CiAgICBlbHNlIGlmKCB2bWEtPnZtX3N0YXJ0ID09IG1f
YUNhcmRzW3U4Q2FyZE51bWJlcl0uQ2hhbm5lbC5kd01lbVduZFVzckFkZHIgKQogICAgewogICAg
ICAgIG1fYUNhcmRzW3U4Q2FyZE51bWJlcl0uQ2hhbm5lbC5kd01lbVduZFVzckFkZHIgPSAoX191
MzIpTlVMTDsKICAgICAgICBtX2FDYXJkc1t1OENhcmROdW1iZXJdLkNoYW5uZWwuYk1tYXBXaW5O
dW0tLTsKICAgIH0KICAgIGVsc2UKICAgIHsKICAgICAgICBwcmludGsoIiVzOiBwY21hY2Vfdm1v
cHNfY2xvc2UoKTogJ211bm1hcCcgZmFpbGVkISAgQmFkIGJhc2UgYWRkcmVzcy5cbiIsCiAgICAg
ICAgICAgICAgIE1PRFVMRV9OQU1FKTsKICAgIH0KICAgIGR1bXBTdHJ1Y3QoKTsKfQoKLyogVk0g
T3BlcmF0aW9uIG92ZXJyaWRlcyAqLwpzdHJ1Y3Qgdm1fb3BlcmF0aW9uc19zdHJ1Y3Qgdm1fb3Bz
ID0gewogICAgY2xvc2U6ICBwY21hY2Vfdm1vcHNfY2xvc2UsCn07CgpzdGF0aWMgdm9pZCBtbWFw
X2Vycm9yX2NsZWFudXAoX191MzIgZHdQY21jaWFXaW5TaXplLCBfX3U4IGJDYXJkTnVtKQp7CiAg
ICBERUJVRygxMCwgIiVzOiBlbnRlcmluZyBtbWFwX2Vycm9yX2NsZWFudXBcbiIsIE1PRFVMRV9O
QU1FKTsKCiAgICBzd2l0Y2goZHdQY21jaWFXaW5TaXplKQogICAgewogICAgICAgIGNhc2UgQUNF
NTNfQ0hBTl9SRUdfTEVOR1RIOgogICAgICAgICAgICBpZiggbV9hQ2FyZHNbYkNhcmROdW1dLkNo
YW5uZWwuYk1tYXBXaW5OdW0gPT0gMCApCiAgICAgICAgICAgICAgICBtX2FDYXJkc1tiQ2FyZE51
bV0uQ2hhbm5lbC5kd1JlZ1duZFVzckFkZHIgPSAoX191MzIpTlVMTDsKICAgICAgICAgICAgYnJl
YWs7CgogICAgICAgIGNhc2UgQUNFNTNfQ0hBTl9NRU1fTEVOR1RIOgogICAgICAgICAgICBpZigg
bV9hQ2FyZHNbYkNhcmROdW1dLkNoYW5uZWwuYk1tYXBXaW5OdW0gPT0gMSApCiAgICAgICAgICAg
ICAgICBtX2FDYXJkc1tiQ2FyZE51bV0uQ2hhbm5lbC5kd01lbVduZFVzckFkZHIgPSAoX191MzIp
TlVMTDsKICAgICAgICAgICAgYnJlYWs7CiAgICB9Cn0KCnN0YXRpYyBpbnQgcGNtYWNlX2ZvcHNf
bW1hcChzdHJ1Y3QgZmlsZSAqZmlscCwgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpCnsKICAg
IC8qIEJhc2UgYWRkcmVzcyBhbmQgc2l6ZSBvZiBQQ0kgc3BhY2Ugd2luZG93IHRvIGJlIHJlbWFw
cGVkLiAqLwogICAgX191MzIgICAgZHdQY21jaWFXaW5CYXNlQWRkciwgZHdQY21jaWFXaW5TaXpl
ID0gdm1hLT52bV9lbmQgLSB2bWEtPnZtX3N0YXJ0OwoKICAgIC8qIE9idGFpbiBpbmRleCBpbnRv
IGVudW1lcmF0ZWQgY2FyZCBsaXN0IGZyb20gZmlsZSBwb2ludGVyLiBDQU4gVEhJUyBCRSBET05F
IFZJQSAndm1hJyBrd2ggKi8KICAgIF9fdTggICAgdThDYXJkTnVtYmVyICAgICA9IE1JTk9SKGZp
bHAtPmZfZGVudHJ5LT5kX2lub2RlLT5pX3JkZXYpOyAgICAvKiBDYXJkIG51bWJlciBpbiBzeXN0
ZW0gKDAgLSAzKSAqLwogICAgX191MzIgICBkd1ZNT2Zmc2V0OwoKICAgIERFQlVHKDEwLCAiJXM6
IGVudGVyaW5nIGZvcHNfbW1hcCBmb3IgY2FyZCAlZFxuIiwKICAgICAgICAgIE1PRFVMRV9OQU1F
LCB1OENhcmROdW1iZXIpOwogICAgZHVtcFN0cnVjdCgpOwoKICAgIGR3Vk1PZmZzZXQgPSB2bWEt
PnZtX3Bnb2ZmPDxQQUdFX1NISUZUOyAvL2ptZiBLZXJuZWwgY2hhbmdlZCBzdHJ1Y3R1cmUgaW4g
Mi40LlgKCiAgICAvKiBBc3NvY2lhdGUgb3VyIG1vZHVsZSBWTSBvcGVyYXRpb25zIHdpdGggb3Vy
ICdtbWFwJy4gKi8KICAgIHZtYS0+dm1fb3BzID0gJnZtX29wczsKCiAgICAvKiBDaGVjayB0aGF0
IG1pbm9yIG51bWJlciBjb3JyZXNwb25kcyB0byBhIGNhcmQgaW4gdGhlIHN5c3RlbS4gKi8KICAg
IGlmICggdThDYXJkTnVtYmVyID49IG1fYk51bWJlck9mQ2FyZHMpCiAgICAgICAgcmV0dXJuIFNU
QVRVU19BQ0U1M19ERVZJQ0VfTk9UX0VYSVNUOwoKICAgIC8qIFJldHVybiBlcnJvciBpZiBhbiBh
dHRlbXB0IHdhcyBtYWRlIHRvICdtbWFwJyBhbiB1bm9wZW5lZCBjYXJkLiAqLwogICAgaWYoICFt
X2FDYXJkc1t1OENhcmROdW1iZXJdLkNoYW5uZWwuYk9wZW4gKQogICAgICAgIHJldHVybiBTVEFU
VVNfQUNFNTNfQ0FSRF9OT1RfT1BFTjsKCiAgICAvKiBDaGVjayBpZiAnbW1hcCcgaXMgY2FsbGVk
IG1vcmUgdGltZXMgdGhhbiBuZWNlc3NhcnkuICovCiAgICBpZihtX2FDYXJkc1t1OENhcmROdW1i
ZXJdLkNoYW5uZWwuYk1tYXBXaW5OdW0gPT0gQUNFNTNfTUFYX1VTRVJfTUVNX1dJTkRPV1MpCiAg
ICAgICAgcmV0dXJuIFNUQVRVU19BQ0U1M19NTUFQX0NBUkRfQUxSRUFEWV9NTUFQUEVEOwoKICAg
IERFQlVHKDgwLCAiJXM6IGZvcHNfbW1hcDogd2luU2l6ZSAlZCAoJWQgJWQpXG4iLAogICAgICAg
ICAgTU9EVUxFX05BTUUsIGR3UGNtY2lhV2luU2l6ZSwKICAgICAgICAgIEFDRTUzX0NIQU5fUkVH
X0xFTkdUSCwgQUNFNTNfQ0hBTl9NRU1fTEVOR1RIKTsKICAgIERFQlVHKDgwLCAiJXM6IGZvcHNf
bW1hcDogc3RhcnQgJWx4XG4iLAogICAgICAgICAgTU9EVUxFX05BTUUsIHZtYS0+dm1fc3RhcnQp
OwogICAgREVCVUcoODAsICIlczogZm9wc19tbWFwOiBlbmQgJWx4XG4iLAogICAgICAgICAgTU9E
VUxFX05BTUUsIHZtYS0+dm1fZW5kKTsKICAgIERFQlVHKDgwLCAiJXM6IGZvcHNfbW1hcDogb2Zm
c2V0ICV4XG4iLAogICAgICAgICAgTU9EVUxFX05BTUUsIGR3Vk1PZmZzZXQpOwogICAgREVCVUco
ODAsICIlczogZm9wc19tbWFwOiBQQUdFX1NISUZUICV4XG4iLAogICAgICAgICAgTU9EVUxFX05B
TUUsIFBBR0VfU0hJRlQpOwogICAgREVCVUcoODAsICIlczogZm9wc19tbWFwOiBQQUdFX1NJWkUg
JWx4XG4iLAogICAgICAgICAgTU9EVUxFX05BTUUsIFBBR0VfU0laRSk7CgogICAgLyogU2VlIHdo
aWNoIHdpbmRvdyB0byBtbWFwLiAqLwogICAgc3dpdGNoKGR3UGNtY2lhV2luU2l6ZSkKICAgIHsK
ICAgICAgICBjYXNlIEFDRTUzX0NIQU5fUkVHX0xFTkdUSDoKICAgICAgICAgICAgaWYoICEobV9h
Q2FyZHNbdThDYXJkTnVtYmVyXS5DaGFubmVsLmJNbWFwV2luTnVtID09IDApICkKICAgICAgICAg
ICAgICAgIHJldHVybiBTVEFUVVNfQUNFNTNfTU1BUF9TRVFVRU5DRV9FUlJPUjsKCiAgICAgICAg
ICAgIGR3UGNtY2lhV2luQmFzZUFkZHIgPSBtX2FDYXJkc1t1OENhcmROdW1iZXJdLmR3UmVnV25k
UGNtY2lhQWRkcjsKICAgICAgICAgICAgbV9hQ2FyZHNbdThDYXJkTnVtYmVyXS5DaGFubmVsLmR3
UmVnV25kVXNyQWRkciA9IHZtYS0+dm1fc3RhcnQ7CiAgICAgICAgICAgIGJyZWFrOwoKICAgICAg
ICBjYXNlIEFDRTUzX0NIQU5fTUVNX0xFTkdUSDoKICAgICAgICAgICAgaWYoICEobV9hQ2FyZHNb
dThDYXJkTnVtYmVyXS5DaGFubmVsLmJNbWFwV2luTnVtID09IDEpICkKICAgICAgICAgICAgICAg
IHJldHVybiBTVEFUVVNfQUNFNTNfTU1BUF9TRVFVRU5DRV9FUlJPUjsKCiAgICAgICAgICAgIGR3
UGNtY2lhV2luQmFzZUFkZHIgPSAobV9hQ2FyZHNbdThDYXJkTnVtYmVyXS5kd01lbVduZFBjbWNp
YUFkZHIpOwogICAgICAgICAgICBtX2FDYXJkc1t1OENhcmROdW1iZXJdLkNoYW5uZWwuZHdNZW1X
bmRVc3JBZGRyID0gdm1hLT52bV9zdGFydDsKICAgICAgICAgICAgYnJlYWs7CgogICAgICAgIGRl
ZmF1bHQ6CiAgICAgICAgICAgIHJldHVybiBTVEFUVVNfQUNFNTNfTU1BUF9JTlZBTElEX1dJTkRP
V19TSVpFOwogICAgfQoKICAgIERFQlVHKDgwLCAiJXM6IGZvcHNfbW1hcDogV25kUGNtY2lhV2lu
QWRkciAleFxuIiwKICAgICAgICAgIE1PRFVMRV9OQU1FLCBkd1BjbWNpYVdpbkJhc2VBZGRyKTsK
ICAgIERFQlVHKDgwLCAiJXM6IGZvcHNfbW1hcDogV25kUGNtY2lhV2luU2l6ZSAleFxuIiwKICAg
ICAgICAgIE1PRFVMRV9OQU1FLCBkd1BjbWNpYVdpblNpemUpOwoKICAgIC8qIFNpemUgbXVzdCBi
ZSBhIG11bHRpcGxlIG9mIFBBR0VfU0laRS4gKi8KICAgIGlmKCBkd1BjbWNpYVdpblNpemUgJSBQ
QUdFX1NJWkUgKQogICAgewogICAgICAgIG1tYXBfZXJyb3JfY2xlYW51cChkd1BjbWNpYVdpblNp
emUsIHU4Q2FyZE51bWJlcik7CiAgICAgICAgcmV0dXJuIFNUQVRVU19BQ0U1M19NTUFQX0lOVkFM
SURfUEFHRV9TSVpFOwogICAgfQoKICAgIC8qIFBoeXNpY2FsIHdpbmRvdyBtdXN0IGJlIHBhZ2Ug
YWxpZ25lZC4gKi8KICAgIGlmKCBkd1ZNT2Zmc2V0ICYgKFBBR0VfU0laRSAtIDEpICkKICAgIHsK
ICAgICAgICBtbWFwX2Vycm9yX2NsZWFudXAoZHdQY21jaWFXaW5TaXplLCB1OENhcmROdW1iZXIp
OwogICAgICAgIHJldHVybiBTVEFUVVNfQUNFNTNfTU1BUF9CQURfQUxJR05NRU5UOwogICAgfQog
ICAgCiAgICBERUJVRyg4MCwgIiVzOiBmb3BzX21tYXA6IHJlbWFwIFxuIiwgTU9EVUxFX05BTUUp
OwoKICAgIC8qIFJlbWFwIHRoZSBQQ0kgd2luZG93IHRvIHVzZXIgc3BhY2UuICovCiAgICAvKiBH
TFMgKi8KICAgIHJlcXVlc3RfbWVtX3JlZ2lvbih2bWEtPnZtX3N0YXJ0LCBkd1BjbWNpYVdpblNp
emUsIE1PRFVMRV9OQU1FKTsKICAgIC8vcmVxdWVzdF9tZW1fcmVnaW9uKGR3UGNtY2lhV2luQmFz
ZUFkZHIsIGR3UGNtY2lhV2luU2l6ZSwgTU9EVUxFX05BTUUpOwogICAgaWYoIGlvX3JlbWFwX3Bm
bl9yYW5nZSh2bWEsIAogICAgICAgICAgICAgICAgICAgICAgICAgICB2bWEtPnZtX3N0YXJ0LAog
ICAgICAgICAgICAgICAgICAgICAgICAgICAoZHdQY21jaWFXaW5CYXNlQWRkciArIGR3Vk1PZmZz
ZXQpID4+IFBBR0VfU0hJRlQsCiAgICAgICAgICAgICAgICAgICAgICAgICAgIGR3UGNtY2lhV2lu
U2l6ZSwKICAgICAgICAgICAgICAgICAgICAgICAgICAgdm1hLT52bV9wYWdlX3Byb3QpIAogICAg
ICApCiAgICB7CiAgICAgICAgbW1hcF9lcnJvcl9jbGVhbnVwKGR3UGNtY2lhV2luU2l6ZSwgdThD
YXJkTnVtYmVyKTsKICAgICAgICByZXR1cm4gU1RBVFVTX0FDRTUzX01NQVBfUkVNQVBfRkFJTDsK
ICAgIH0KCiAgICAvKiBJbmNyZW1lbnQgJ21tYXAnIGNvdW50LiAqLwogICAgbV9hQ2FyZHNbdThD
YXJkTnVtYmVyXS5DaGFubmVsLmJNbWFwV2luTnVtKys7CgogICAgLyogUmV0dXJuIHN1Y2Nlc3Mu
ICovCiAgICBkdW1wU3RydWN0KCk7CiAgICByZXR1cm4gU1RBVFVTX0FDRTUzX1NVQ0NFU1M7Cn0K
Ci8qIEp1bXAgdGFibGUgdXNlZCB0byBpbnZva2UgZHJpdmVyIGZ1bmN0aW9ucyAqLwpzdHJ1Y3Qg
ZmlsZV9vcGVyYXRpb25zIG1fZm9GaWxlT3BzID0gewogICAgaW9jdGw6ICAgICAgICBwY21hY2Vf
Zm9wc19pb2N0bCwKICAgIGNvbXBhdF9pb2N0bDogcGNtYWNlX2ZvcHNfY29tcGF0X2lvY3RsLAog
ICAgbW1hcDogICAgICAgICBwY21hY2VfZm9wc19tbWFwLAogICAgb3BlbjogICAgICAgICBwY21h
Y2VfZm9wc19vcGVuLAogICAgcmVsZWFzZTogICAgICBwY21hY2VfZm9wc19yZWxlYXNlCn07Cgov
Ki0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS1FTkQgT0YgQ0hBUiBEUklWRVIgRlVOQ1RJT05T
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLwoKLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tU1RBUlQgT0YgQ0FSRCBTRVJWSUNFUyBGVU5DVElPTlMtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tKi8KCi8qPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQoKICAgIHBjbWFjZV9jc19hdHRhY2goKSBjcmVhdGVz
IGFuICJpbnN0YW5jZSIgb2YgdGhlIGRyaXZlciwgYWxsb2NhdGluZwogICAgbG9jYWwgZGF0YSBz
dHJ1Y3R1cmVzIGZvciBvbmUgZGV2aWNlLiAgVGhlIGRldmljZSBpcyByZWdpc3RlcmVkCiAgICB3
aXRoIENhcmQgU2VydmljZXMuCiAgICBUaGUgZGV2X2xpbmsgc3RydWN0dXJlIGlzIGluaXRpYWxp
emVkLCBidXQgd2UgZG9uJ3QgYWN0dWFsbHkKICAgIGNvbmZpZ3VyZSB0aGUgY2FyZCBhdCB0aGlz
IHBvaW50IC0tIHdlIHdhaXQgdW50aWwgd2UgcmVjZWl2ZSBhCiAgICBjYXJkIGluc2VydGlvbiBl
dmVudC4KCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0qLwpzdGF0aWMgaW50IHBjbWFjZV9jc19hdHRhY2goc3RydWN0
IHBjbWNpYV9kZXZpY2UgKmxpbmspCnsKICAgIGxvY2FsX2luZm9fdCAqbG9jYWw7CiAgICAvL2Nv
bmZfcmVnX3QgY2xpZW50X3JlZzsKICAgIC8vaW50IHJldDsKICAgIC8vY3Nfc3RhdHVzX3Qgc3Rh
dHVzOwogICAgLy9jb25maWdfaW5mb190IGNvbmY7CgogICAgREVCVUcoMTAsICIlczogZW50ZXJp
bmcgYXR0YWNoOiAlcyAlc1xuIiwKICAgICAgICAgIE1PRFVMRV9OQU1FLCBkZXZfZHJpdmVyX3N0
cmluZygmbGluay0+ZGV2KSwgbGluay0+ZGV2LmJ1c19pZCk7CiAgICBQcmludFNlcnZpbmZvKGxp
bmspOwoKICAgIC8qIEFsbG9jYXRlIHNwYWNlIGZvciBwcml2YXRlIGRldmljZS1zcGVjaWZpYyBk
YXRhICovCiAgICBsb2NhbCA9IGttYWxsb2Moc2l6ZW9mKGxvY2FsX2luZm9fdCksIEdGUF9LRVJO
RUwpOwogICAgaWYgKCFsb2NhbCkKICAgICAgICByZXR1cm4gLUVOT01FTTsKICAgIERFQlVHKDgw
LCAiJXM6IGxvY2FsIDB4JTAxNmxseCwgc2l6ZSAlbHVcbiIsCiAgICAgICAgICBNT0RVTEVfTkFN
RSwgKF9fdTY0KWxvY2FsLCBzaXplb2YobG9jYWxfaW5mb190KSk7CgogICAgbWVtc2V0KGxvY2Fs
LCAwLCBzaXplb2YobG9jYWxfaW5mb190KSk7CiAgICBsb2NhbC0+bGluayA9IGxpbms7CiAgICBs
aW5rLT5wcml2ID0gbG9jYWw7CgogICAgLyoKICAgICAgR2VuZXJhbCBzb2NrZXQgY29uZmlndXJh
dGlvbiBkZWZhdWx0cyBjYW4gZ28gaGVyZS4gIEluIHRoaXMKICAgICAgY2xpZW50LCB3ZSBhc3N1
bWUgdmVyeSBsaXR0bGUsIGFuZCByZWx5IG9uIHRoZSBDSVMgZm9yIGFsbW9zdAogICAgICBldmVy
eXRoaW5nLiAgSW4gbW9zdCBjbGllbnRzLCBtYW55IGRldGFpbHMgKGkuZS4sIG51bWJlciwgc2l6
ZXMsCiAgICAgIGFuZCBhdHRyaWJ1dGVzIG9mIElPIHdpbmRvd3MpIGFyZSBmaXhlZCBieSB0aGUg
bmF0dXJlIG9mIHRoZQogICAgICBkZXZpY2UsIGFuZCBjYW4gYmUgaGFyZC13aXJlZCBoZXJlLgog
ICAgKi8KICAgIGxpbmstPmNvbmYuQXR0cmlidXRlcyA9IENPTkZfRU5BQkxFX0lSUTsKICAgIGxp
bmstPmNvbmYuQXR0cmlidXRlcyB8PSBDT05GX0VOQUJMRV9ETUE7CiAgICBsaW5rLT5jb25mLklu
dFR5cGUgPSBJTlRfTUVNT1JZX0FORF9JTzsKICAgIGxpbmstPmNvbmYuQ29uZmlnQmFzZSA9IDB4
MjAwOwoKICAgIC8qIENvbmZpZ3VyZSBDYXJkICovCiAgICBwY21hY2VfY3NfY29uZmlnKGxpbmsp
OwoKICAgIHJldHVybiAwOwp9IC8qIHBjbWFjZV9jc19hdHRhY2ggKi8KCi8qPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQoKICAgIFRoaXMgZGVsZXRlcyBhIGRyaXZlciAiaW5zdGFuY2UiLiAgVGhlIGRldmljZSBpcyBk
ZS1yZWdpc3RlcmVkCiAgICB3aXRoIENhcmQgU2VydmljZXMuICBJZiBpdCBoYXMgYmVlbiByZWxl
YXNlZCwgYWxsIGxvY2FsIGRhdGEKICAgIHN0cnVjdHVyZXMgYXJlIGZyZWVkLiAgT3RoZXJ3aXNl
LCB0aGUgc3RydWN0dXJlcyB3aWxsIGJlIGZyZWVkCiAgICB3aGVuIHRoZSBkZXZpY2UgaXMgcmVs
ZWFzZWQuCgo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09Ki8Kc3RhdGljIHZvaWQgcGNtYWNlX2NzX2RldGFjaChzdHJ1
Y3QgcGNtY2lhX2RldmljZSAqbGluaykKewogICAgREVCVUcoMTAsICIlczogZW50ZXJpbmcgZGV0
YWNoOiAlcyAlc1xuIiwKICAgICAgICAgIE1PRFVMRV9OQU1FLCBkZXZfZHJpdmVyX3N0cmluZygm
bGluay0+ZGV2KSwgbGluay0+ZGV2LmJ1c19pZCk7CgogICAgLyogUmVsZWFzZSAqLwogICAgcGNt
YWNlX2NzX3JlbGVhc2UobGluayk7CgogICAgLyogVGhpcyBwb2ludHMgdG8gdGhlIHBhcmVudCBs
b2NhbF9pbmZvX3Qgc3RydWN0ICovCiAgICBrZnJlZShsaW5rLT5wcml2KTsKfSAvKiBwY21hY2Vf
Y3NfZGV0YWNoICovCgovKj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KCiAgICBwY21hY2VfY3Nfc3VzcGVuZCgpIG1h
bmFnZSBTVVNQRU5EL1JFU0VUX1BIWVNJQ0FMIGV2ZW50cwoKPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PSovCnN0YXRp
YyBpbnQgcGNtYWNlX2NzX3N1c3BlbmQoc3RydWN0IHBjbWNpYV9kZXZpY2UgKmxpbmspCnsKICAg
IGxvY2FsX2luZm9fdCAqbG9jYWwgPSAobG9jYWxfaW5mb190ICopbGluay0+cHJpdjsKCiAgICBE
RUJVRygxMCwgIiVzOiBlbnRlcmluZyBzdXNwZW5kOiAlcyAlc1xuIiwKICAgICAgICAgIE1PRFVM
RV9OQU1FLCBkZXZfZHJpdmVyX3N0cmluZygmbGluay0+ZGV2KSwgbGluay0+ZGV2LmJ1c19pZCk7
CgogICAgLyogTWFyayB0aGUgZGV2aWNlIGFzIHN0b3BwZWQsIHRvIGJsb2NrIElPIHVudGlsIGxh
dGVyICovCiAgICBsb2NhbC0+c3RvcCA9IDE7CiAgICBpZiAobGluay0+b3BlbikKICAgICAgICBw
Y21jaWFfZGlzYWJsZV9kZXZpY2UobGluayk7CgogICAgcmV0dXJuIDA7Cn0gLyogcGNtYWNlX2Nz
X3N1c3BlbmQgKi8KCi8qPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PQoKICAgIHBjbWFjZV9jc19yZXN1bWUoKSBtYW5h
Z2UgUkVTVU1FL0NBUkRfUkVTRVQgZXZlbnRzCgo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ki8Kc3RhdGljIGludCBw
Y21hY2VfY3NfcmVzdW1lKHN0cnVjdCBwY21jaWFfZGV2aWNlICpsaW5rKQp7CiAgICBsb2NhbF9p
bmZvX3QgKmxvY2FsID0gKGxvY2FsX2luZm9fdCAqKWxpbmstPnByaXY7CiAgICBjb25maWdfcmVx
X3QgY29uZjsKCiAgICBERUJVRygxMCwgIiVzOiBlbnRlcmluZyByZXN1bWU6ICVzICVzXG4iLAog
ICAgICAgICAgTU9EVUxFX05BTUUsIGRldl9kcml2ZXJfc3RyaW5nKCZsaW5rLT5kZXYpLCBsaW5r
LT5kZXYuYnVzX2lkKTsKCiAgICBpZiAobGluay0+b3BlbikKICAgICAgICBwY21jaWFfcmVxdWVz
dF9jb25maWd1cmF0aW9uKGxpbmssICZjb25mKTsKICAgIGxvY2FsLT5zdG9wID0gMDsKICAgIC8q
CiAgICAgIEluIGEgbm9ybWFsIGRyaXZlciwgYWRkaXRpb25hbCBjb2RlIG1heSBnbyBoZXJlIHRv
IHJlc3RvcmUKICAgICAgdGhlIGRldmljZSBzdGF0ZSBhbmQgcmVzdGFydCBJTy4KICAgICovCgog
ICAgcmV0dXJuIDA7Cn0gLyogcGNtYWNlX2NzX3Jlc3VtZSAqLwoKCi8qKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAqIEZ1
bmN0aW9uOiAgICBwY21hY2VfY3NfR2V0VHVwbGUgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqCiAqIERlc2NyaXB0aW9uOiBHZXRzIGEgVHVwbGUgZnJvbSB0aGUg
UENNQ0lBIGNhcmQgKHVzZSBhcHByb3ByaWF0ZSAqCiAqICAgICAgICAgICAgICBwYXJ0IG9mIHRo
ZSBjaXNwYXJzZSBzdHJ1Y3QgcmVxdWVzdGVkKSAgICAgICAgICAgICAqCiAqICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAq
IFBhcmFtZXRlcnM6ICBuRGVzcmllZFR1cGxlIC0gUGFzcyBhIHZhbGlkIHR1cGxlIHR5cGUgYXMg
ICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRlZmluZWQgaW4gY2lz
dHBsLmggZWcuICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIENJ
U1RQTF9DT05GSUcgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAg
ICAgICAgcGNpc3BhcnNlIC0gUGFzcyBhIGNpc3BhcnNlIHN0cnVjdCB0byBDb250YWluICAgICAq
CiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgdGhlIENJUyBkYXRhIHJlcXVlc3RlZCAgICAg
ICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAqCiAqIHJldHVybiAgICAgICAgMCAgLSBTdWNjZXNzOyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgITAg
LSBGYWlsdXJlOyBlcnJvciBjb2RlcyBhcmUgZGVmaW5lZCBieSBDYXJkICAgICAqCiAqICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBTZXJ2aWNlcyBmdW5jdGlvbnMgICAgICAgICAgICAgICAg
ICAqCiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqLwpzdGF0aWMgaW50IHBjbWFjZV9jc19HZXRUdXBsZShpbnQgbkRlc2ly
ZWRUdXBsZSwgY2lzcGFyc2VfdCAqcGNpc3BhcnNlKQp7CiAgICBzdHJ1Y3QgcGNtY2lhX2Rldmlj
ZSAqaGFuZGxlOwogICAgdHVwbGVfdCB0dXBsZTsKICAgIHVfY2hhciBidWZbVFVQTEVfQlVGRkVS
X1NJWkVdOwogICAgaW50IG5TdGF0dXMgPSAxOwoKICAgIERFQlVHKDEwLCAiJXM6IGVudGVyaW5n
IEdldFR1cGxlXG4iLCBNT0RVTEVfTkFNRSk7CgogICAgaWYobV9hQ2FyZHNbbV9iTnVtYmVyT2ZD
YXJkc10ucGxpbmsgIT0gTlVMTCkKICAgIHsKICAgICAgICBpZihtX2FDYXJkc1ttX2JOdW1iZXJP
ZkNhcmRzXS5wbGluayAhPSBOVUxMKQogICAgICAgIHsKICAgICAgICAgICAgaGFuZGxlID0gbV9h
Q2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10ucGxpbms7CiAgICAgICAgICAgIHR1cGxlLkF0dHJpYnV0
ZXMgPSAwOwogICAgICAgICAgICB0dXBsZS5UdXBsZURhdGEgPSBidWY7CiAgICAgICAgICAgIHR1
cGxlLlR1cGxlRGF0YU1heCA9IChjaXNkYXRhX3Qpc2l6ZW9mKGJ1Zik7CiAgICAgICAgICAgIHR1
cGxlLlR1cGxlT2Zmc2V0ID0gMDsKICAgICAgICAgICAgdHVwbGUuRGVzaXJlZFR1cGxlID0gbkRl
c2lyZWRUdXBsZTsKICAgICAgICAgICAgblN0YXR1cyA9IHBjbWNpYV9nZXRfZmlyc3RfdHVwbGUo
aGFuZGxlLCAmdHVwbGUpOwogICAgICAgICAgICBpZihuU3RhdHVzID09IENTX1NVQ0NFU1MpCiAg
ICAgICAgICAgIHsKICAgICAgICAgICAgICAgIG5TdGF0dXMgPSBwY21jaWFfZ2V0X3R1cGxlX2Rh
dGEoaGFuZGxlLCAmdHVwbGUpOwogICAgICAgICAgICAgICAgaWYoblN0YXR1cyA9PSBDU19TVUND
RVNTKQogICAgICAgICAgICAgICAgewogICAgICAgICAgICAgICAgICAgIG5TdGF0dXMgPSBwY21j
aWFfcGFyc2VfdHVwbGUoaGFuZGxlLCAmdHVwbGUsIHBjaXNwYXJzZSk7CiAgICAgICAgICAgICAg
ICB9CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICB9CgogICAgcmV0dXJuIG5TdGF0dXM7Cn0K
Ci8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqCiAqIEZ1bmN0aW9uOiAgICBwY21hY2VfY3NfR2V0RGV2aWNlVHVwbGVJbmZv
ICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIERlc2NyaXB0aW9uOiBHZXRz
IGEgRGV2aWNlIHR1cGxlIGZyb20gdGhlIFBDTUNJQSBjYXJkIGFuZCAgICAgICAqCiAqICAgICAg
ICAgICAgICBzdG9yZXMgaW5mbyBpbiBtX2FDYXJkc1ttX2JOdW1iZXJPZkNhcmRzXS5DSVMgICAg
ICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAqCiAqIFBhcmFtZXRlcnM6ICBoYW5kbGUgLSBQYXNzIGEgdmFsaWQgY2xp
ZW50IGhhbmRsZSAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIHJldHVybiAgICAgICAg
MCAgLSBTdWNjZXNzOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAg
ICAgICAgICAgICAgITAgLSBGYWlsdXJlOyBlcnJvciBjb2RlcyBhcmUgZGVmaW5lZCBieSBDYXJk
ICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICBTZXJ2aWNlcyBmdW5jdGlvbnMg
ICAgICAgICAgICAgICAgICAqCiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwpzdGF0aWMgaW50IHBjbWFjZV9jc19HZXRE
ZXZpY2VUdXBsZUluZm8oc3RydWN0IHBjbWNpYV9kZXZpY2UgKmhhbmRsZSkKewogICAgY2lzcGFy
c2VfdCBjaXNwYXJzZTsKICAgIGNpc3RwbF9kZXZpY2VfdCAqcGRldmljZSA9ICYoY2lzcGFyc2Uu
ZGV2aWNlKTsKICAgIGludCBuU3RhdHVzOwoKICAgIERFQlVHKDEwLCAiJXM6IGVudGVyaW5nIEdl
dERldmljZVR1cGxlSW5mbzogJXMgJXNcbiIsCiAgICAgICAgICBNT0RVTEVfTkFNRSwgZGV2X2Ry
aXZlcl9zdHJpbmcoJmhhbmRsZS0+ZGV2KSwgaGFuZGxlLT5kZXYuYnVzX2lkKTsKCiAgICBpZigo
blN0YXR1cyA9IHBjbWFjZV9jc19HZXRUdXBsZShDSVNUUExfREVWSUNFLCAmY2lzcGFyc2UpKSA9
PSAwKQogICAgewogICAgICAgIG1fYUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy51bkFjY2Vz
c1NwZWVkID0gcGRldmljZS0+ZGV2WzBdLnNwZWVkOwogICAgICAgIG1fYUNhcmRzW21fYk51bWJl
ck9mQ2FyZHNdLkNJUy51bk1lbW9yeVNpemUgPSBwZGV2aWNlLT5kZXZbMF0uc2l6ZTsKICAgIH0K
ICAgIHJldHVybiBuU3RhdHVzOwp9CgovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiBGdW5jdGlvbjogICAgcGNtYWNl
X2NzX0dldENvbmZpZ1R1cGxlSW5mbyAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KgogKiBEZXNjcmlwdGlvbjogR2V0cyBhIENvbmZpZyB0dXBsZSBmcm9tIHRoZSBQQ01DSUEgY2Fy
ZCBhbmQgc3RvcmVzKgogKiAgICAgICAgICAgICAgaW5mbyBpbiBtX2FDYXJkc1ttX2JOdW1iZXJP
ZkNhcmRzXS5DSVMgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBQYXJhbWV0ZXJzOiAgaGFu
ZGxlIC0gUGFzcyBhIHZhbGlkIGNsaWVudCBoYW5kbGUgICAgICAgICAgICAgICAgKgogKiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKgogKiByZXR1cm4gICAgICAgIDAgIC0gU3VjY2VzczsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICEwIC0gRmFpbHVyZTsgZXJyb3IgY29k
ZXMgYXJlIGRlZmluZWQgYnkgQ2FyZCAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgU2VydmljZXMgZnVuY3Rpb25zICAgICAgICAgICAgICAgICAgKgogKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3Rh
dGljIGludCBwY21hY2VfY3NfR2V0Q29uZmlnVHVwbGVJbmZvKHN0cnVjdCBwY21jaWFfZGV2aWNl
ICpoYW5kbGUpCnsKICAgIGNpc3BhcnNlX3QgY2lzcGFyc2U7CiAgICBjaXN0cGxfY29uZmlnX3Qg
KnBjb25maWcgPSAmKGNpc3BhcnNlLmNvbmZpZyk7CiAgICBpbnQgblN0YXR1czsKCiAgICBERUJV
RygxMCwgIiVzOiBlbnRlcmluZyBHZXRDb25maWdUdXBsZUluZm86ICVzICVzXG4iLAogICAgICAg
ICAgTU9EVUxFX05BTUUsIGRldl9kcml2ZXJfc3RyaW5nKCZoYW5kbGUtPmRldiksIGhhbmRsZS0+
ZGV2LmJ1c19pZCk7CgogICAgaWYoKG5TdGF0dXMgPSBwY21hY2VfY3NfR2V0VHVwbGUoQ0lTVFBM
X0NPTkZJRywgJmNpc3BhcnNlKSkgPT0gMCkKICAgIHsKICAgICAgICBtX2FDYXJkc1ttX2JOdW1i
ZXJPZkNhcmRzXS5DSVMudW5Db25maWdCYXNlID0gcGNvbmZpZy0+YmFzZTsKICAgICAgICBtX2FD
YXJkc1ttX2JOdW1iZXJPZkNhcmRzXS5DSVMudW5QcmVzZW50ID0gcGNvbmZpZy0+cm1hc2tbMF07
CiAgICAgICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uQ0lTLnVjQ29uZmlnSW5kZXggPSBw
Y29uZmlnLT5sYXN0X2lkeDsKICAgIH0KICAgIHJldHVybiBuU3RhdHVzOwp9CgovKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KgogKiBGdW5jdGlvbjogICAgIHBjbWFjZV9jc19HZXRDRlRhYmxlVHVwbGVJbmZvICAgICAgICAg
ICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBEZXNjcmlwdGlvbjogR2V0cyBhIENmdGFibGVf
ZW50cnkgdHVwbGUgZnJvbSB0aGUgUENNQ0lBIGNhcmQgICAgKgogKiAgICAgICAgICAgICAgYW5k
IHN0b3JlcyBpbmZvIGluICBtX2FDYXJkc1ttX2JOdW1iZXJPZkNhcmRzXS5DSVMgKgogKiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKgogKiBQYXJhbWV0ZXJzOiAgaGFuZGxlIC0gUGFzcyBhIHZhbGlkIGNsaWVudCBoYW5kbGUg
ICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiByZXR1cm4gICAgICAgIDAgIC0gU3VjY2Vz
czsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAg
ICEwIC0gRmFpbHVyZTsgZXJyb3IgY29kZXMgYXJlIGRlZmluZWQgYnkgQ2FyZCAgICAgKgogKiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgU2VydmljZXMgZnVuY3Rpb25zICAgICAgICAgICAg
ICAgICAgKgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKi8Kc3RhdGljIGludCBwY21hY2VfY3NfR2V0Q0ZUYWJsZVR1cGxl
SW5mbyhzdHJ1Y3QgcGNtY2lhX2RldmljZSAqaGFuZGxlKQp7CiAgICBjaXNwYXJzZV90IGNpc3Bh
cnNlOwogICAgY2lzdHBsX2NmdGFibGVfZW50cnlfdCAqcGVudHJ5ID0gJihjaXNwYXJzZS5jZnRh
YmxlX2VudHJ5KTsKICAgIGNpc3RwbF9pb190ICpwaW8gPSAmKHBlbnRyeS0+aW8pOwogICAgY2lz
dHBsX2lycV90ICpwaXJxID0gJihwZW50cnktPmlycSk7CiAgICBjaXN0cGxfbWVtX3QgKnBtZW0g
PSAmKHBlbnRyeS0+bWVtKTsKICAgIGludCBuSW5kZXg7CiAgICBpbnQgblN0YXR1czsKCiAgICBE
RUJVRygxMCwgIiVzOiBlbnRlcmluZyBHZXRDRlRhYmxlVHVwbGVJbmZvOiAlcyAlc1xuIiwKICAg
ICAgICAgIE1PRFVMRV9OQU1FLCBkZXZfZHJpdmVyX3N0cmluZygmaGFuZGxlLT5kZXYpLCBoYW5k
bGUtPmRldi5idXNfaWQpOwoKICAgIGlmKChuU3RhdHVzID0gcGNtYWNlX2NzX0dldFR1cGxlKENJ
U1RQTF9DRlRBQkxFX0VOVFJZLCAmY2lzcGFyc2UpKSA9PSAwKQogICAgewogICAgICAgIG1fYUNh
cmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy51Y0NvbmZpZ0luZGV4ID0gcGVudHJ5LT5pbmRleDsK
ICAgICAgICBtX2FDYXJkc1ttX2JOdW1iZXJPZkNhcmRzXS5DSVMuaW8uZmxhZ3MgPSBwaW8tPmZs
YWdzOwogICAgICAgIG1fYUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy5pby5ud2luID0gcGlv
LT5ud2luOwogICAgICAgIHByaW50aygiJXM6IENJUzogSU8gcG9ydCB3aW5kb3dzOiAlZCIsIE1P
RFVMRV9OQU1FLCBwaW8tPm53aW4pOwogICAgICAgIC8vIFN0b3JlIG11bHRpcGxlIElPIHdpbmRv
dyBpbmZvCiAgICAgICAgZm9yKG5JbmRleCA9IDA7IG5JbmRleCA8IG1fYUNhcmRzW21fYk51bWJl
ck9mQ2FyZHNdLkNJUy5pby5ud2luOyBuSW5kZXgrKykKICAgICAgICB7CiAgICAgICAgICAgIHBy
aW50aygiIEJhc2U6IDB4JTA0eCBMZW46IDB4JTA0eCIsIHBpby0+d2luW25JbmRleF0uYmFzZSwg
cGlvLT53aW5bbkluZGV4XS5sZW4pOwogICAgICAgICAgICBtX2FDYXJkc1ttX2JOdW1iZXJPZkNh
cmRzXS5DSVMuaW8ud2luW25JbmRleF0uYmFzZSA9IHBpby0+d2luW25JbmRleF0uYmFzZTsKICAg
ICAgICAgICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uQ0lTLmlvLndpbltuSW5kZXhdLmxl
biA9IHBpby0+d2luW25JbmRleF0ubGVuOwogICAgICAgIH0KCiAgICAgICAgbV9hQ2FyZHNbbV9i
TnVtYmVyT2ZDYXJkc10uQ0lTLmlycS5JUlFJbmZvMSA9IHBpcnEtPklSUUluZm8xOwogICAgICAg
IG1fYUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy5pcnEuSVJRSW5mbzIgPSBwaXJxLT5JUlFJ
bmZvMjsKICAgICAgICBwcmludGsoIiBBbGxvd2VkIElSUXM6ICIpOwogICAgICAgIGlmKChwaXJx
LT5JUlFJbmZvMSAmIElSUV9JTkZPMl9WQUxJRCkgIT0gMCkKICAgICAgICB7CiAgICAgICAgICAg
IGZvcihuSW5kZXggPSAwOyBuSW5kZXggPCAxNjsgbkluZGV4KyspICAvLyBEaXNscGF5IGFsbG93
ZWQgSVJRcwogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBpZigocGlycS0+SVJRSW5mbzIg
JiAoMSA8PCBuSW5kZXgpKSAhPSAwKQogICAgICAgICAgICAgICAgcHJpbnRrKCIleCIsIG5JbmRl
eCk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICAgICAgZWxzZQogICAgICAgICAgICBwcmlu
dGsoIiV4IiwgcGlycS0+SVJRSW5mbzEpOyAgLy8gRGlzcGxheSBzaW5nbGUgYWxsb3dlZCBJUlEg
KGhvcGUgaXRzIGZyZWUgOikKICAgICAgICBtX2FDYXJkc1ttX2JOdW1iZXJPZkNhcmRzXS5DSVMu
bWVtLm53aW4gPSBwbWVtLT5ud2luOwogICAgICAgIHByaW50aygiIG1lbSB3aW5kb3dzOiAlZCIs
IG1fYUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy5tZW0ubndpbik7CiAgICAgICAgZm9yKG5J
bmRleCA9IDA7IG5JbmRleCA8ICBwbWVtLT5ud2luOyBuSW5kZXgrKykgIC8vIFN0b3JlIG11bHRp
cGxlIG1lbW9yeSB3aW5kb3cgaW5mbwogICAgICAgIHsKICAgICAgICAgICAgbV9hQ2FyZHNbbV9i
TnVtYmVyT2ZDYXJkc10uQ0lTLm1lbS53aW5bbkluZGV4XS5sZW4gPQogICAgICAgICAgICAgICAg
cG1lbS0+d2luW25JbmRleF0ubGVuOwogICAgICAgICAgICBtX2FDYXJkc1ttX2JOdW1iZXJPZkNh
cmRzXS5DSVMubWVtLndpbltuSW5kZXhdLmNhcmRfYWRkciA9CiAgICAgICAgICAgICAgICBwbWVt
LT53aW5bbkluZGV4XS5jYXJkX2FkZHI7CiAgICAgICAgICAgIHByaW50aygiIDB4JTA0eC0weCUw
NHgiLAogICAgICAgICAgICAgICAgICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uQ0lTLm1l
bS53aW5bbkluZGV4XS5jYXJkX2FkZHIsCiAgICAgICAgICAgICAgICAgICBtX2FDYXJkc1ttX2JO
dW1iZXJPZkNhcmRzXS5DSVMubWVtLndpbltuSW5kZXhdLmNhcmRfYWRkcgogICAgICAgICAgICAg
ICAgICAgKyBtX2FDYXJkc1ttX2JOdW1iZXJPZkNhcmRzXS5DSVMubWVtLndpbltuSW5kZXhdLmxl
bik7CiAgICAgICAgfQogICAgICAgIHByaW50aygiXG4iKTsKICAgIH0KICAgIHJldHVybiBuU3Rh
dHVzOwp9CgovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKgogKiBGdW5jdGlvbjogICAgIHBjbWFjZV9jc19HZXRNYW5maWRU
dXBsZUluZm8gICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBEZXNjcmlwdGlv
bjogR2V0cyBhIG1hbmZpZCB0dXBsZSBmcm9tIHRoZSBQQ01DSUEgY2FyZCBhbmQgICAgICAgKgog
KiAgICAgICAgICAgICAgc3RvcmVzIGluZm8gaW4gbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10u
Q0lTICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgKgogKiBQYXJhbWV0ZXJzOiAgaGFuZGxlIC0gUGFzcyBhIHZh
bGlkIGNsaWVudCBoYW5kbGUgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiByZXR1cm4g
ICAgICAgIDAgIC0gU3VjY2VzczsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KgogKiAgICAgICAgICAgICAgICEwIC0gRmFpbHVyZTsgZXJyb3IgY29kZXMgYXJlIGRlZmluZWQg
YnkgQ2FyZCAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU2VydmljZXMgZnVu
Y3Rpb25zICAgICAgICAgICAgICAgICAgKgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3RhdGljIGludCBwY21hY2Vf
Y3NfR2V0TWFuZmlkVHVwbGVJbmZvKHN0cnVjdCBwY21jaWFfZGV2aWNlICpoYW5kbGUpCnsKICAg
IGNpc3BhcnNlX3QgY2lzcGFyc2U7CiAgICBpbnQgblN0YXR1czsKICAgIGNpc3RwbF9tYW5maWRf
dCAqcG1hbmZpZCA9ICZjaXNwYXJzZS5tYW5maWQ7CgogICAgREVCVUcoMTAsICIlczogZW50ZXJp
bmcgR2V0TWFuZmlkVHVwbGVJbmZvOiAlcyAlc1xuIiwKICAgICAgICAgIE1PRFVMRV9OQU1FLCBk
ZXZfZHJpdmVyX3N0cmluZygmaGFuZGxlLT5kZXYpLCBoYW5kbGUtPmRldi5idXNfaWQpOwoKICAg
IGlmKChuU3RhdHVzID0gcGNtYWNlX2NzX0dldFR1cGxlKENJU1RQTF9NQU5GSUQsICZjaXNwYXJz
ZSkpID09IDApCiAgICB7CiAgICAgICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uQ0lTLm1h
bmZpZC5tYW5mID0gcG1hbmZpZC0+bWFuZjsKICAgICAgICBtX2FDYXJkc1ttX2JOdW1iZXJPZkNh
cmRzXS5DSVMubWFuZmlkLmNhcmQgPSBwbWFuZmlkLT5jYXJkOwogICAgICAgIG1fYUNhcmRzW21f
Yk51bWJlck9mQ2FyZHNdLndEZXZpY2VJRCA9CiAgICAgICAgICAgIG1fYUNhcmRzW21fYk51bWJl
ck9mQ2FyZHNdLkNJUy5tYW5maWQuY2FyZDsKICAgIH0KICAgIHJldHVybiBuU3RhdHVzOwp9Cgov
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKgogKiBGdW5jdGlvbjogICAgICBwY21hY2VfY3NfR2V0Q2lzSU8gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBEZXNjcmlwdGlvbjogQ29waWVz
IGFuIElPIHR1cGxlIGluZm8gZnJvbSB0aGUgUENNQ0lBIGNhcmQgaW50byAgKgogKiAgICAgICAg
ICAgICAgaW4gbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uQ0lTICAgICAgICAgICAgICAgICAg
KgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKgogKiBQYXJhbWV0ZXJzOiAgcGlvIC0gUGFzcyBhbiBpbyBzdHJ1Y3QgY29u
dGFpbmluZyBDSVMgZGF0YSAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgYXF1aXJlZCBm
cm9tICBjaXNwYXJzZS5jZnRhYmxlX2VudHJ5LmlvICAgICAgKgogKiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiByZXR1
cm4gICAgICAgIDAgLSBTdWNjZXNzOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKgogKiAgICAgICAgICAgICAgIDEgLSBGYWlsdXJlOyBObyBpbyB3aW5kb3dzIGluZm8gd2Fz
IGF2YWlsYWJsZSAgICAgKgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3RhdGljIGludCBwY21hY2VfY3NfR2V0Q2lz
SU8oaW9fcmVxX3QgKnBpbykKewogICAgaW50IG5TdGF0dXM7CgogICAgREVCVUcoMTAsICIlczog
ZW50ZXJpbmcgR2V0Q2lzSU9cbiIsIE1PRFVMRV9OQU1FKTsKCiAgICBpZihtX2FDYXJkc1ttX2JO
dW1iZXJPZkNhcmRzXS5DSVMuaW8ubndpbiA+IDApICAvLyBDb3B5IGZpcnN0IGlvIHdpbmRvdyBp
bmZvIGlmIGF2YWlsYWJsZQogICAgewogICAgICAgIHBpby0+QmFzZVBvcnQxID0gbV9hQ2FyZHNb
bV9iTnVtYmVyT2ZDYXJkc10uQ0lTLmlvLndpblswXS5iYXNlOwogICAgICAgIHBpby0+TnVtUG9y
dHMxID0gbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uQ0lTLmlvLndpblswXS5sZW47CiAgICAg
ICAgLy9TZXQgSU8gdG8gOCBiaXQgaWYgc3BlY2lmaWVkIGJ5IENJUwogICAgICAgIGlmKG1fYUNh
cmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy5pby5mbGFncyAmIENJU1RQTF9JT184QklUKQogICAg
ICAgICAgICBwaW8tPkF0dHJpYnV0ZXMxID0gSU9fREFUQV9QQVRIX1dJRFRIXzg7CiAgICAgICAg
Ly9TZXQgSU8gdG8gMTYgYml0IGlmIHNwZWNpZmllZCBieSBDSVMKICAgICAgICBlbHNlIGlmKG1f
YUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy5pby5mbGFncyAmIENJU1RQTF9JT18xNkJJVCkK
ICAgICAgICAgICAgcGlvLT5BdHRyaWJ1dGVzMSA9IElPX0RBVEFfUEFUSF9XSURUSF8xNjsKICAg
ICAgICBlbHNlCiAgICAgICAgICAgIHBpby0+QXR0cmlidXRlczEgPSBJT19EQVRBX1BBVEhfV0lE
VEhfQVVUTzsgIC8vU2V0IElPIHRvIEF1dG8gaWYgbm90IHNwZWNpZmllZAogICAgICAgIHBpby0+
SU9BZGRyTGluZXMgPSBtX2FDYXJkc1ttX2JOdW1iZXJPZkNhcmRzXS5DSVMuaW8uZmxhZ3MgJiBD
SVNUUExfSU9fTElORVNfTUFTSzsKICAgICAgICBpZihtX2FDYXJkc1ttX2JOdW1iZXJPZkNhcmRz
XS5DSVMuaW8ubndpbiA+IDEpIC8vIENvcHkgc2Vjb25kIGlvIHdpbmRvdyBpbmZvIGlmIGF2YWls
YWJsZQogICAgICAgIHsKICAgICAgICAgICAgcGlvLT5CYXNlUG9ydDIgPSBtX2FDYXJkc1ttX2JO
dW1iZXJPZkNhcmRzXS5DSVMuaW8ud2luWzFdLmJhc2U7CiAgICAgICAgICAgIHBpby0+TnVtUG9y
dHMyID0gbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uQ0lTLmlvLndpblsxXS5sZW47CiAgICAg
ICAgICAgIHBpby0+QXR0cmlidXRlczIgPSBwaW8tPkF0dHJpYnV0ZXMxOwogICAgICAgIH0KICAg
ICAgICAvLyBJZ25vcmUgb3RoZXIgaW8gd2luZG93IGluZm8sIExpbnV4IENhcmQgU2VydmljZXMg
Y2FuJ3QgdXNlIGl0IGFueXdheSA6KQoKICAgICAgICBuU3RhdHVzID0gMDsKICAgIH0KICAgIGVs
c2UKICAgICAgICBuU3RhdHVzID0gMTsKICAgIHJldHVybiBuU3RhdHVzOwp9CgovKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KgogKiBGdW5jdGlvbjogICAgICBwY21hY2VfY3NfY29uZmlnSU8gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBEZXNjcmlwdGlvbjogQ29uZmlndXJlIGRldmlj
ZSBJTyB1c2luZyBkZXZpY2UgQ0lTLiAgSU8gaXMgb25seSAgKgogKiAgICAgICAgICAgICAgcmVx
dWVzdGVkLCB0aGUgQ2FyZCBTZXJ2aWNlcyBjYWxsLCAgICAgICAgICAgICAgICAgKgogKiAgICAg
ICAgICAgICAgUmVxdWVzdENvbmZpZ3VyYXRpb24sIGRvZXMgdGhlIGFjdHVhbCBjb25maWcuICAg
ICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKgogKiBQYXJhbWV0ZXJzOiAgcGxpbmsgLSBQYXNzIHRoZSBkZXZpY2Ug
bGluazsgQ2FsbCBmcm9tIHRoZSAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICBwY21h
Y2VfY3NfY29uZmlnSU8obGluaykgZnVuY3Rpb24gICAgICAgKgogKiAgICAgICAgICAgICAgICAg
ICAgICBwYXNzaW5nIGxpbmssIHNhbWUgYXMgcGxpbmsgKHVzZWQgcCBhcyAgICAgKgogKiAgICAg
ICAgICAgICAgICAgICAgICBwb2ludGVyIHByZWZpeCkuICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKgogKiByZXR1cm46ICAgICAgIDAgIC0gU3VjY2VzczsgRGV2aWNlIElP
IHdhcyBzdWNjZXNzZnVsbHkgcmVxdWVzdGVkKgogKiAgICAgICAgICAgICAgICEwIC0gRmFpbHVy
ZS4gRXJyb3IgY29kZXMgYXJlIGRlZmluZWQgYnkgQ2FyZCAgICAgKgogKiAgICAgICAgICAgICAg
ICAgICAgU2VydmljZXMgZnVuY3Rpb25zICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKi8Kc3RhdGljIGludCBwY21hY2VfY3NfY29uZmlnSU8oc3RydWN0IHBjbWNpYV9kZXZp
Y2UgKnBsaW5rKQp7CiAgICBpbnQgblN0YXR1czsKCiAgICBERUJVRygxMCwgIiVzOiBlbnRlcmlu
ZyBjb25maWdJTzogJXMgJXNcbiIsCiAgICAgICAgICBNT0RVTEVfTkFNRSwgZGV2X2RyaXZlcl9z
dHJpbmcoJnBsaW5rLT5kZXYpLCBwbGluay0+ZGV2LmJ1c19pZCk7CgogICAgcGxpbmstPmlvLkJh
c2VQb3J0MSA9IDA7ICAvL2lvX3JlcV90CiAgICBwbGluay0+aW8uTnVtUG9ydHMxID0gMDsKICAg
IHBsaW5rLT5pby5BdHRyaWJ1dGVzMSA9IDA7CiAgICBwbGluay0+aW8uQmFzZVBvcnQyID0gMDsK
ICAgIHBsaW5rLT5pby5OdW1Qb3J0czIgPSAwOwogICAgcGxpbmstPmlvLkF0dHJpYnV0ZXMyID0g
MDsKICAgIHBsaW5rLT5pby5JT0FkZHJMaW5lcyA9IDA7CiAgICBpZigoblN0YXR1cyA9IHBjbWFj
ZV9jc19HZXRDaXNJTygmKHBsaW5rLT5pbykpKSA9PSAwKQogICAgICAgIG5TdGF0dXMgPSBwY21j
aWFfcmVxdWVzdF9pbyhwbGluaywgJihwbGluay0+aW8pKTsKICAgIHJldHVybiBuU3RhdHVzOwp9
CgovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKgogKiBGdW5jdGlvbjogICAgICBwY21hY2VfY3NfR2V0Q2lzSVJRICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBEZXNjcmlwdGlvbjogQ29w
aWVzIGFuIElSUSB0dXBsZSBpbmZvIGZyb20gdGhlIFBDTUNJQSBjYXJkIGludG8gKgogKiAgICAg
ICAgICAgICAgaW4gbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uQ0lTICAgICAgICAgICAgICAg
ICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKgogKiBQYXJhbWV0ZXJzOiAgcGlycXJlcSAtIFBhc3MgYW4gaXJxIHN0
cnVjdCBjb250YWluaW5nIENJUyBkYXRhOyAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgIGFx
dWlyZWQgZnJvbSBjaXNwYXJzZS5jZnRhYmxlX2VudHJ5LmlycSAgKgogKiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBy
ZXR1cm46ICAgICAgIFZvaWQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKi8Kc3RhdGljIHZvaWQgcGNtYWNlX2NzX0dldENpc0lSUShpcnFf
cmVxX3QgKnBpcnFyZXEpCnsKICAgIERFQlVHKDEwLCAiJXM6IGVudGVyaW5nIEdldENpc0lSUVxu
IiwgTU9EVUxFX05BTUUpOwoKICAgIHBpcnFyZXEtPklSUUluZm8xID0gbV9hQ2FyZHNbbV9iTnVt
YmVyT2ZDYXJkc10uQ0lTLmlycS5JUlFJbmZvMTsKCiAgICBwaXJxcmVxLT5JUlFJbmZvMiA9IG1f
YUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy5pcnEuSVJRSW5mbzI7Cn0KCi8qKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
CiAqIEZ1bmN0aW9uOiAgICAgICBwY21hY2VfY3NfY29uZmlnSVJRICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAqCiAqIERlc2NyaXB0aW9uOiBDb25maWd1cmUgZGV2aWNl
IElSUSB1c2luZyBkZXZpY2UgQ0lTLiBJUlEgaXMgT05MWSAqCiAqICAgICAgICAgICAgICByZXF1
ZXN0ZWQuIEEgQ2FyZCBTZXJ2aWNlcyBjYWxsICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAg
ICAgICAgICBSZXF1ZXN0Q29uZmlndXJhdGlvbiBkb2VzIHRoZSBhY3R1YWwgY29uZmlnICAgICAg
ICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAqCiAqIFBhcmFtZXRlcnM6ICBwbGluayAtIFBhc3MgdGhlIGRldmljZSBs
aW5rOyBDYWxsIGZyb20gdGhlICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgIHBjbWFj
ZV9jc19jb25maWdJTyhsaW5rKSBmdW5jdGlvbiAgICAgICAgICAqCiAqICAgICAgICAgICAgICAg
ICAgICAgIHBhc3NpbmcgbGluaywgc2FtZSBhcyBwbGluayAodXNlZCBwIGFzICAgICAqCiAqICAg
ICAgICAgICAgICAgICAgICAgIHBvaW50ZXIgcHJlZml4KS4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqCiAqIHJldHVybjogICAgICAgMCAtIFN1Y2Nlc3M7ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgMSAtIEZhaWx1
cmU7IG5vIGlvIHdpbmRvd3MgaW5mbyB3YXMgYXZhaWxhYmxlICAgICAqCiAqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwpz
dGF0aWMgaW50IHBjbWFjZV9jc19jb25maWdJUlEoc3RydWN0IHBjbWNpYV9kZXZpY2UgKnBsaW5r
KQp7CiAgICBpbnQgblN0YXR1cyA9IDA7CiAgICBpcnFfcmVxX3QgcGlycXJlcTsKCiAgICBERUJV
RygxMCwgIiVzOiBlbnRlcmluZyBjb25maWdJUlE6ICVzICVzXG4iLAogICAgICAgICAgTU9EVUxF
X05BTUUsIGRldl9kcml2ZXJfc3RyaW5nKCZwbGluay0+ZGV2KSwgcGxpbmstPmRldi5idXNfaWQp
OwoKICAgIHBpcnFyZXEuQXR0cmlidXRlcyAgICA9IElSUV9GT1JDRURfUFVMU0UgfCBJUlFfVFlQ
RV9USU1FIHwgSVJRX0ZJUlNUX1NIQVJFRDsKICAgIHBpcnFyZXEuQXNzaWduZWRJUlEgICA9IDA7
CiAgICBwaXJxcmVxLklSUUluZm8xICAgICAgPSAwOwogICAgcGlycXJlcS5JUlFJbmZvMiAgICAg
ID0gMDsKICAgIHBpcnFyZXEuSGFuZGxlciAgICAgICA9IE5VTEw7CiAgICBwaXJxcmVxLkluc3Rh
bmNlICAgICAgPSBOVUxMOwoKICAgIHBjbWFjZV9jc19HZXRDaXNJUlEoJnBpcnFyZXEpOwogICAg
REVCVUcoODAsICIlczogY29uZmlnSVJROiBhZnRlciBHZXRDaXNJUlFcbiIsIE1PRFVMRV9OQU1F
KTsKCiAgICBuU3RhdHVzID0gcGNtY2lhX3JlcXVlc3RfaXJxKHBsaW5rLCAmcGlycXJlcSk7CiAg
ICBERUJVRyg4MCwgIiVzOiBjb25maWdJUlE6IGFmdGVyIHJlcXVlc3RfaXJxOiBzdGF0dXMgJWRc
biIsCiAgICAgICAgICBNT0RVTEVfTkFNRSwgblN0YXR1cyk7CiAgICBpZihuU3RhdHVzID09IENT
X1NVQ0NFU1MpCiAgICB7CiAgICAgICAgbV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10uY0lSUVJl
cXVlc3QgPSBfX1JFUVVFU1RFRF9fOwogICAgfQogICAgZWxzZQogICAgewogICAgICAgIHByaW50
aygiJXM6IENJUyBJUlEgcmVxdWVzdCBmYWlsZWQsIHNlYXJjaGluZyBmb3IgYSBzcGFyZSBJUlEg
IiwKICAgICAgICAgICAgICAgTU9EVUxFX05BTUUpOwogICAgICAgIHBpcnFyZXEuSVJRSW5mbzEg
PSAxOwogICAgICAgIGRvICAvLyBTZWFyY2ggZm9yIGFuIElSUSBpZiBDSVMgSVJRIGZhaWxlZAog
ICAgICAgIHsKICAgICAgICAgICAgaWYoKG5TdGF0dXMgPSBwY21jaWFfcmVxdWVzdF9pcnEocGxp
bmssICZwaXJxcmVxKSkgIT0gMCkKICAgICAgICAgICAgewogICAgICAgICAgICAgICAgcGlycXJl
cS5JUlFJbmZvMSsrOwogICAgICAgICAgICB9CiAgICAgICAgfQogICAgICAgIHdoaWxlKChuU3Rh
dHVzICE9IDApICYmIChwaXJxcmVxLklSUUluZm8xID49IDEpICYmIChwaXJxcmVxLklSUUluZm8x
IDw9IDE1ICkpOwogICAgfQoKICAgIHBsaW5rLT5pcnEuQXNzaWduZWRJUlEgPSBwaXJxcmVxLkFz
c2lnbmVkSVJROwoKICAgIHJldHVybihuU3RhdHVzKTsKfQoKLyoqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKICogRnVuY3Rp
b246ICAgICAgICBwY21hY2VfY3NfR2V0Q2lzV2luZG93cyAgICAgICAgICAgICAgICAgICAgICAg
ICoKICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICoKICogRGVzY3JpcHRpb246IENvcGllcyBhbiBJUlEgdHVwbGUgaW5mbyBm
cm9tICAgICAgICAgICAgICAgICAgICAgICoKICogICAgICAgICAgICAgIG1fYUNhcmRzW21fYk51
bWJlck9mQ2FyZHNdLkNJUyBpbnRvIHRoZSB3aW5kb3cgICAgICoKICogICAgICAgICAgICAgIHJl
cXVlc3Qgc3RydWN0ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICoKICogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICoKICogUGFyYW1ldGVyczogIHBuTnVtV2luZG93cyAtIFBhc3MgYW4gaW50ZWdlcjsgdGhl
IG51bWJlciBvZiAgICAgICoKICogICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1lbW9yeSB3
aW5kb3dzIHdpbGwgYmUgcGFzc2VkIGJhY2sgICoKICogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICoKICogcmV0dXJuOiAgICAg
ICAwICAtIFN1Y2Nlc3M7IENJUyB3aW5kb3dzIGluZm8gcmV0cmlldmVkIGFuZCAgICAgICoKICog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIG51bWJlciBvZiB3aW5kb3dzIHJldHVybmVkICAg
ICAgICAgICoKICogICAgICAgICAgICAgICAhMCAtIEZhaWx1cmU7IEVycm9yIGNvZGVzIGFyZSBk
ZWZpbmVkIGJ5IENhcmQgICAgICoKICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICBTZXJ2
aWNlcyAgICAgICAgICAgICAgICAgICAgICAgICAgICoKICoqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKiovCnN0YXRpYyBpbnQg
cGNtYWNlX2NzX0dldENpc1dpbmRvd3MoaW50ICpwbk51bVdpbmRvd3MpCnsKICAgIGludCBuSW5k
ZXg7CiAgICBpbnQgblN0YXR1czsKCiAgICBERUJVRygxMCwgIiVzOiBlbnRlcmluZyBHZXRDaXNX
aW5kb3dzXG4iLCBNT0RVTEVfTkFNRSk7CgogICAgaWYobV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJk
c10uQ0lTLm1lbS5ud2luID4gMCkKICAgIHsKICAgICAgICAvLyBDb3B5IGVhY2ggd2luZG93IGlu
Zm8KICAgICAgICBmb3IobkluZGV4ID0gMDsgbkluZGV4IDwgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZD
YXJkc10uQ0lTLm1lbS5ud2luOyBuSW5kZXgrKykKICAgICAgICB7CiAgICAgICAgICAgIC8vQ2hl
Y2sgZm9yIHZhbGlkIGxlbmd0aAogICAgICAgICAgICBpZigobV9hQ2FyZHNbbV9iTnVtYmVyT2ZD
YXJkc10uQ0lTLm1lbS53aW5bbkluZGV4XS5sZW4gJSAweDEwMDApID09IDApCiAgICAgICAgICAg
ICAgICBtX0NhcmRJT1ttX2JOdW1iZXJPZkNhcmRzXS5XaW5BcnJbbkluZGV4XS5yZXEuU2l6ZSA9
CiAgICAgICAgICAgICAgICAgICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uQ0lTLm1lbS53
aW5bbkluZGV4XS5sZW47CiAgICAgICAgICAgIGVsc2UgIC8vIEV4dGVuZCB3aW5kb3cgc2l6ZSB0
byBhIG11bHRpcGxlIG9mIDRLIHJlcXVpcmVkIGJ5IENhcmQgU2VydmljZXMKICAgICAgICAgICAg
ewogICAgICAgICAgICAgICAgbV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10uV2luQXJyW25JbmRl
eF0ucmVxLlNpemUgPQogICAgICAgICAgICAgICAgICAgIG1fYUNhcmRzW21fYk51bWJlck9mQ2Fy
ZHNdLkNJUy5tZW0ud2luW25JbmRleF0ubGVuCiAgICAgICAgICAgICAgICAgICAgLSAobV9hQ2Fy
ZHNbbV9iTnVtYmVyT2ZDYXJkc10uQ0lTLm1lbS53aW5bbkluZGV4XS5sZW4gJSAweDEwMDApICsg
MHgxMDAwOwogICAgICAgICAgICAgICAgcHJpbnRrKCIlczogRml4aW5nIGludmFsaWQgQ0lTIHdp
bmRvd1slZF0gc2l6ZSAweCV4ID0+IDB4JXhcbiIsCiAgICAgICAgICAgICAgICAgICAgICAgTU9E
VUxFX05BTUUsIG5JbmRleCwKICAgICAgICAgICAgICAgICAgICAgICBtX2FDYXJkc1ttX2JOdW1i
ZXJPZkNhcmRzXS5DSVMubWVtLndpbltuSW5kZXhdLmxlbiwKICAgICAgICAgICAgICAgICAgICAg
ICBtX0NhcmRJT1ttX2JOdW1iZXJPZkNhcmRzXS5XaW5BcnJbbkluZGV4XS5yZXEuU2l6ZSk7CiAg
ICAgICAgICAgIH0KICAgICAgICAgICAgbV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10uV2luQXJy
W25JbmRleF0ubWFwLkNhcmRPZmZzZXQgPQogICAgICAgICAgICAgICAgbV9hQ2FyZHNbbV9iTnVt
YmVyT2ZDYXJkc10uQ0lTLm1lbS53aW5bbkluZGV4XS5jYXJkX2FkZHI7CiAgICAgICAgICAgIG1f
Q2FyZElPW21fYk51bWJlck9mQ2FyZHNdLldpbkFycltuSW5kZXhdLnJlcS5BY2Nlc3NTcGVlZCA9
CiAgICAgICAgICAgICAgICBtX2FDYXJkc1ttX2JOdW1iZXJPZkNhcmRzXS5DSVMudW5BY2Nlc3NT
cGVlZDsKICAgICAgICB9CiAgICAgICAgblN0YXR1cyA9IDA7CiAgICB9CiAgICBlbHNlCiAgICAg
ICAgblN0YXR1cyA9IDE7CiAgICAqcG5OdW1XaW5kb3dzID0gbV9hQ2FyZHNbbV9iTnVtYmVyT2ZD
YXJkc10uQ0lTLm1lbS5ud2luOwogICAgcmV0dXJuIG5TdGF0dXM7Cn0KCi8qKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAq
IEZ1bmN0aW9uOiAgcGNtYWNlX2NzX1JlcXVlc3RXaW5kb3dzICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAqCiAqIERlc2NyaXB0aW9uOiAgUmVxdWVzdHMgZGV2aWNlIG1l
bW9yeSB3aW5kb3dzIGFzIGRlZmluZWQgYnkgICAgICAqCiAqICAgICAgICAgICAgICAgZGV2aWNl
IENJUy4gQ0lTIGluZm8gaXMgcmV0cmlldmVkIGZyb20gICAgICAgICAgICAqCiAqICAgICAgICAg
ICAgICAgbV9hQ2FyZFttX2JOdW1iZXJPZkNhcmRzXS5DSVMgV2luZG93cyBhcmUgICAgICAgICAq
CiAqICAgICAgICAgICAgICAgcmVxdWVzdGVkIHVzaW5nIG1fQ2FyZElPW21fYk51bWJlck9mQ2Fy
ZHNdOyB0aGUgICAqCiAqICAgICAgICAgICAgICAgcGh5c2ljYWwgbWVtb3J5IHBvaW50ZXJzIGFy
ZSAgc3RvcmVkIGhlcmUgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIFBhcmFtZXRlcnM6ICBwbk51
bVdpbmRvd3MgLSBQYXNzIGFuIGludGVnZXI7IHRoZSBudW1iZXIgb2YgICAgICAqCiAqICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBtZW1vcnkgd2luZG93cyB3aWxsIGJlIHBhc3NlZCBiYWNr
ICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAqCiAqIHJldHVybjogICAgICAgMCAtIFN1Y2Nlc3M7IFdpbmRvdyBhZGRy
ZXNzZXM6ICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAg
MSAtIEZhaWx1cmU7IEEgd2luZG93IG1lbW9yeSBtYXAgZmFpbGVkOyBkcml2ZXIgICAqCiAqICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHdpbGwgbm90IGZ1bmN0aW9uIHByb3Blcmx5ICAgICAg
ICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgMiAtIEZhaWx1cmU7IEEgd2luZG93
IHJlcXVlc3QgZmFpbGVkOyBkcml2ZXIgd2lsbCAqCiAqICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIG5vdCBmdW5jdGlvbiBwcm9wZXJseSAgICAgICAgICAgICAgICAqCiAqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwpz
dGF0aWMgaW50IHBjbWFjZV9jc19SZXF1ZXN0V2luZG93cyhzdHJ1Y3QgcGNtY2lhX2RldmljZSAq
cGxpbmspCnsKICAgIGludCBuOwogICAgaW50IG5TdGF0dXMgPSAwOwoKICAgIERFQlVHKDEwLCAi
JXM6IGVudGVyaW5nIFJlcXVlc3RXaW5kb3dzOiAlcyAlc1xuIiwKICAgICAgICAgIE1PRFVMRV9O
QU1FLCBkZXZfZHJpdmVyX3N0cmluZygmcGxpbmstPmRldiksIHBsaW5rLT5kZXYuYnVzX2lkKTsK
CiAgICBmb3IobiA9IDA7IG4gPCBtX0NhcmRJT1ttX2JOdW1iZXJPZkNhcmRzXS5uTnVtV2luZG93
czsgbisrKSAgLy8gUmVxdWVzdCBlYWNoIG1lbW9yeSB3aW5kb3cKICAgIHsKICAgICAgICBpZigo
blN0YXR1cyA9IHBjbWNpYV9yZXF1ZXN0X3dpbmRvdygmcGxpbmssICYobV9DYXJkSU9bbV9iTnVt
YmVyT2ZDYXJkc10uV2luQXJyW25dLnJlcSksICYobV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10u
V2luQXJyW25dLndpbmhhbmRsZSkpKSA9PSAwKQogICAgICAgIHsKICAgICAgICAgICAgaWYocGNt
Y2lhX21hcF9tZW1fcGFnZShtX0NhcmRJT1ttX2JOdW1iZXJPZkNhcmRzXS5XaW5BcnJbbl0ud2lu
aGFuZGxlLCAmKG1fQ2FyZElPW21fYk51bWJlck9mQ2FyZHNdLldpbkFycltuXS5tYXApKSA9PSAw
KQogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICBtX0NhcmRJT1ttX2JOdW1iZXJPZkNhcmRz
XS5XaW5BcnJbbl0udWxXaW5kb3dTaXplID0KICAgICAgICAgICAgICAgICAgICBtX0NhcmRJT1tt
X2JOdW1iZXJPZkNhcmRzXS5XaW5BcnJbbl0ucmVxLlNpemU7CiAgICAgICAgICAgICAgICBtX0Nh
cmRJT1ttX2JOdW1iZXJPZkNhcmRzXS5XaW5BcnJbbl0ucG5EaXJlY3RQaHlzaWNhbEFkZHIgPQog
ICAgICAgICAgICAgICAgICAgICh2b2lkKikobV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10uV2lu
QXJyW25dLnJlcS5CYXNlKTsKICAgICAgICAgICAgICAgIG1fQ2FyZElPW21fYk51bWJlck9mQ2Fy
ZHNdLldpbkFycltuXS5jQXJyV2luZG93UmVxdWVzdCA9CiAgICAgICAgICAgICAgICAgICAgX19S
RVFVRVNURURfXzsKICAgICAgICAgICAgfQogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgIHsK
ICAgICAgICAgICAgICAgIHByaW50aygiJXM6IFdpbmRvdyBtYXAgZmFpbGVkXG4iLCBNT0RVTEVf
TkFNRSk7CiAgICAgICAgICAgICAgICBuU3RhdHVzID0gMTsKICAgICAgICAgICAgfQogICAgICAg
IH0KICAgICAgICBlbHNlCiAgICAgICAgewogICAgICAgICAgICBwcmludGsoIiVzOiBSZXF1ZXN0
V2luZG93cyBmYWlsZWQgV2luQXJyWyVkXSBBdHQ6IDB4JXggQmFzZTogMHglbHggU2l6ZTogMHgl
eCBTcGVlZDogJWRcbiIsCiAgICAgICAgICAgICAgICAgICBNT0RVTEVfTkFNRSwgbiwgbV9DYXJk
SU9bbV9iTnVtYmVyT2ZDYXJkc10uV2luQXJyW25dLnJlcS5BdHRyaWJ1dGVzLAogICAgICAgICAg
ICAgICAgICAgbV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10uV2luQXJyW25dLnJlcS5CYXNlLAog
ICAgICAgICAgICAgICAgICAgbV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10uV2luQXJyW25dLnJl
cS5TaXplLAogICAgICAgICAgICAgICAgICAgbV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10uV2lu
QXJyW25dLnJlcS5BY2Nlc3NTcGVlZCk7CiAgICAgICAgICAgIG5TdGF0dXMgPSAyOwogICAgICAg
IH0KICAgIH0KICAgIHJldHVybiBuU3RhdHVzOwp9CgovKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiBGdW5jdGlvbjog
IHBjbWFjZV9jc19jb25maWdXaW5kb3dzICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKgogKiBEZXNjcmlwdGlvbjogIFJlcXVlc3RzIGRldmljZSBtZW1vcnkgd2luZG93cyBh
cyBkZWZpbmVkIGJ5ICAgICAgKgogKiAgICAgICAgICAgICAgIGRldmljZSBDSVMuIENJUyBpbmZv
IGlzIHJldHJpZXZlZCBmcm9tICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgIEFDYXJkWzBd
LkNJUyBXaW5kb3dzIGFyZSByZXF1ZXN0ZWQgdXNpbmcgICAgICAgICAgKgogKiAgICAgICAgICAg
ICAgIG1fQ2FyZElPW21fYk51bWJlck9mQ2FyZHNdOyB0aGUgcGh5c2ljYWwgbWVtb3J5ICAgKgog
KiAgICAgICAgICAgICAgIHBvaW50ZXJzIGFyZSBzdG9yZWQgaGVyZS4gV2luZG93cyBhcmUgT05M
WSAgICAgICAgKgogKiAgICAgICAgICAgICAgIHJlcXVlc3RlZDsgQSBDYXJkIFNlcnZpY2VzIGNh
bGwgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgIFJlcXVlc3RDb25maWd1cmF0
aW9uIGRvZXMgdGhlIGFjdHVhbCBjb25maWcgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBQYXJhbWV0
ZXJzOiAgTm9uZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKgogKiByZXR1cm46ICAgICAgIDAgLSBTdWNjZXNzOyBXaW5kb3cgYWRkcmVz
c2VzOiAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgIDEg
LSBGYWlsdXJlOyBBIHdpbmRvdyBtZW1vcnkgbWFwIGZhaWxlZDsgZHJpdmVyICAgKgogKiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB3aWxsIG5vdCBmdW5jdGlvbiBwcm9wZXJseSAgICAgICAg
ICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgIDIgLSBGYWlsdXJlOyBBIHdpbmRvdyBy
ZXF1ZXN0IGZhaWxlZDsgZHJpdmVyIHdpbGwgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBub3QgZnVuY3Rpb24gcHJvcGVybHkgICAgICAgICAgICAgICAgKgogKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3Rh
dGljIGludCBwY21hY2VfY3NfY29uZmlnV2luZG93cyhzdHJ1Y3QgcGNtY2lhX2RldmljZSAqcGxp
bmspCnsKICAgIGludCBuTnVtV2luZG93czsKICAgIGludCBuU3RhdHVzOwoKICAgIERFQlVHKDEw
LCAiJXM6IGVudGVyaW5nIGNvbmZpZ1dpbmRvd3M6ICVzICVzXG4iLAogICAgICAgICAgTU9EVUxF
X05BTUUsIGRldl9kcml2ZXJfc3RyaW5nKCZwbGluay0+ZGV2KSwgcGxpbmstPmRldi5idXNfaWQp
OwoKICAgIGlmKHBjbWFjZV9jc19HZXRDaXNXaW5kb3dzKCZuTnVtV2luZG93cykgPT0gMCkKICAg
IHsKICAgICAgICBtX0NhcmRJT1ttX2JOdW1iZXJPZkNhcmRzXS5uTnVtV2luZG93cyA9IG5OdW1X
aW5kb3dzOwogICAgICAgIG5TdGF0dXMgPSBwY21hY2VfY3NfUmVxdWVzdFdpbmRvd3MocGxpbmsp
OwogICAgfQogICAgZWxzZQogICAgICAgIG5TdGF0dXMgPSAxOwogICAgcmV0dXJuIG5TdGF0dXM7
Cn0KCi8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqCiAqIEZ1bmN0aW9uOiAgcGNtYWNlX2NzX1dyaXRlQ29uZmlnUmVnaXN0
ZXIgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIERlc2NyaXB0aW9uOiAg
V3JpdGVzIGEgdmFsdWUgdG8gdGhlIHNwZWNpZmllZCBjb25maWcgcmVnaXN0ZXI7ICAqCiAqICAg
ICAgICAgICAgICAgU2VlIENhcmQgU2VydmljZXMgZG9jdW1lbnRhdGlvbiBmb3IgZGV0YWlscyAg
ICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqCiAqIFBhcmFtZXRlcnM6ICAgaGFuZGxlIC0gUGFzcyBhIHZhbGlk
IGNsaWVudCBoYW5kbGU7IGFxdWlyZWQgZnJvbSAqCiAqICAgICAgICAgICAgICAgICAgICAgICAg
cGxpbmstPmhhbmRsZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAq
ICAgICAgICAgICAgICAgdW5DSVNSZWcgLSBQYXNzIHRoZSBDSVNSZWcgb2Zmc2V0IGZvciB0aGUg
cmVnaXN0ZXIqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICB0byBiZSB1cGRhdGVkICAgICAg
ICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgIHVuVmFs
dWUgLSBQYXNzIHRoZSB2YWx1ZSB0byBiZSB3cml0dGVuICAgICAgICAgICAqCiAqICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAq
CiAqIHJldHVybjogICAgICAgMCAgLSBzdWNjZXNzOyBUaGUgdmFsdWUgd2FzIHN1Y2Nlc3NmdWxs
eSB3cml0dGVuICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICB0byB0aGUgc3BlY2lm
aWVkIHJlZ2lzdGVyICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgITAg
LSBGYWlsdXJlOyBFcnJvciBjb2RlcyBhcmUgYXMgZGVmaW5lZCBieSBDYXJkICAqCiAqICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBTZXJ2aWNlcyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAqCiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqLwovKnN0YXRpYyBpbnQgcGNtYWNlX2NzX1dyaXRlQ29uZmlnUmVnaXN0
ZXIoc3RydWN0IHBjbWNpYV9kZXZpY2UgKmhhbmRsZSwKICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB1X2ludCB1bkNJU1JlZywKICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB1X2ludCB1blZhbHVlKQp7CiAgICBjb25mX3JlZ190IGNvbmZyZWc7
CgogICAgREVCVUcoMTAsICIlczogZW50ZXJpbmcgV3JpdGVDb25maWdSZWdpc3RlcjogJXMgJXNc
biIsCiAgICAgICAgICBNT0RVTEVfTkFNRSwgZGV2X2RyaXZlcl9zdHJpbmcoJmhhbmRsZS0+ZGV2
KSwgaGFuZGxlLT5kZXYuYnVzX2lkKTsKCiAgICBjb25mcmVnLkZ1bmN0aW9uID0gMDsKICAgIGNv
bmZyZWcuQWN0aW9uID0gQ1NfV1JJVEU7CiAgICBjb25mcmVnLk9mZnNldCA9IHVuQ0lTUmVnOwog
ICAgY29uZnJlZy5WYWx1ZSA9IHVuVmFsdWU7CiAgICByZXR1cm4gcGNtY2lhX2FjY2Vzc19jb25m
aWd1cmF0aW9uX3JlZ2lzdGVyKGhhbmRsZSwgJmNvbmZyZWcpOwp9Ki8KCi8qKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAq
IEZ1bmN0aW9uOiAgcGNtYWNlX2NzX0dldENvbmZpZ09wdGlvblJlZ2lzdGVyICAgICAgICAgICAg
ICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqCiAqIERlc2NyaXB0aW9uOiAgIFJlYWRzIHRoZSBkZXZpY2UgY29u
ZmlnIG9wdGlvbiByZWdpc3RlciAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgIFRoZSByZWdp
c3RlciBjb250YWlucyB0aGUgZm9sbG93aW5nIGluZm8gICAgICAgICAqCiAqICAgICAgICAgICAg
ICAgIENPUl9DT05GSUdfTUFTSyBpcyB1c2VkIHRvIGdldCB0aGUgaW5kZXggb2YgdGhlICAqCiAq
ICAgICAgICAgICAgICAgIGNhcmQncyBjdXJyZW50IG9wZXJhdGluZyBtb2RlICAgICAgICAgICAg
ICAgICAgICAqCiAqICAgICAgICAgICAgICAgIENPUl9MRUxFVkVMX0lSUSBzcGVjaWZpZXMgdGhh
dCB0aGUgY2FyZCBzaG91bGQgICAqCiAqICAgICAgICAgICAgICAgIGdlbmVyYXRlIGxldmVsIG1v
ZGUgaW50ZXJydXB0cyAoZGVmYXVsdCkgICAgICAgICAqCiAqICAgICAgICAgICAgICAgIENPUl9T
T0ZUX1JFU0VUIFNldHRpbmcgcGVyZm9ybXMgYSAnc29mdCByZXNldCcuICAqCiAqICAgICAgICAg
ICAgICAgIFVzZSBDYXJkIFNlcnZpY2VzIGNhbGwgUmVzZXRDYXJkIGluc3RlYWQgICAgICAgICAq
CiAqICAgICAgICAgICAgICAgIFNlZSBDYXJkIFNlcnZpY2VzIGRvY3VtZW50YXRpb24gZm9yIG1v
cmUgICAgICAgICAqCiAqICAgICAgICAgICAgICAgIGluZm9ybWF0aW9uICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIFBhcmFtZXRlcnM6ICAgIGhh
bmRsZSAtIFBhc3MgYSB2YWxpZCBjbGllbnQgaGFuZGxlOyBhcXVpcmVkICAgICAqCiAqICAgICAg
ICAgICAgICAgICAgICAgICAgIGZyb20gcGxpbmstPmhhbmRsZSAgICAgICAgICAgICAgICAgICAg
ICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgIHB1blZhbHVlIC0gUGFzcyBhbiB1bnNp
Z25lZCBpbnQsIHRoZSByZWdpc3RlciAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAg
dmFsdWUgd2lsbCBiZSBwYXNzZWQgYmFjayAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIHJl
dHVybjogICAgICAgIDAgIC0gU3VjY2VzczsgVGhlIHZhbHVlIHdhcyBzdWNjZXNzZnVsbHkgcmVh
ZCAgICAqCiAqICAgICAgICAgICAgICAgICEwIC0gRmFpbHVyZTsgRXJyb3IgY29kZXMgYXJlIGFz
IGRlZmluZWQgYnkgQ2FyZCAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU2Vydmlj
ZXMgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwovKnN0YXRpYyBpbnQg
cGNtYWNlX2NzX0dldENvbmZpZ09wdGlvblJlZ2lzdGVyKHN0cnVjdCBwY21jaWFfZGV2aWNlICpo
YW5kbGUsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdV9pbnQg
KnB1blZhbHVlKQp7CiAgICBpbnQgblN0YXR1czsKICAgIGNvbmZfcmVnX3QgY29uZnJlZzsKCiAg
ICBERUJVRygxMCwgIiVzOiBlbnRlcmluZyBHZXRDb25maWdPcHRpb25SZWdpc3RlcjogJXMgJXNc
biIsCiAgICAgICAgICBNT0RVTEVfTkFNRSwgZGV2X2RyaXZlcl9zdHJpbmcoJmhhbmRsZS0+ZGV2
KSwgaGFuZGxlLT5kZXYuYnVzX2lkKTsKCiAgICBjb25mcmVnLkZ1bmN0aW9uID0gMDsgIC8vIEln
bm9yZWQgYnkgdGhpcyBDYXJkIFNlcnZpY2VzIGZ1bmN0aW9uIGNhbGwKICAgIGNvbmZyZWcuQWN0
aW9uID0gQ1NfUkVBRDsKICAgIGNvbmZyZWcuT2Zmc2V0ID0gQ0lTUkVHX0NPUjsgIC8vIFNwZWNp
Zml5IENvbmZpZ09wdGlvbiByZWdpc3RlcgogICAgaWYoKG5TdGF0dXMgPSBwY21jaWFfYWNjZXNz
X2NvbmZpZ3VyYXRpb25fcmVnaXN0ZXIoaGFuZGxlLCAmY29uZnJlZykpID09IDApCiAgICAgICAg
KnB1blZhbHVlID0gY29uZnJlZy5WYWx1ZTsKICAgIHJldHVybiBuU3RhdHVzOwp9Ki8KCi8qKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqCiAqIEZ1bmN0aW9uOiAgcGNtYWNlX2NzX1NldENvbmZpZ09wdGlvblJlZ2lzdGVyICAg
ICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIERlc2NyaXB0aW9uOiAgIFB1dHMgdGhl
IGRldmljZSBpbiB0aGUgb3BlcmF0aW5nIG1vZGUgc3BlY2lmaWVkICAqCiAqICAgICAgICAgICAg
ICAgIGJ5IHRoZSBkZXZpY2UgQ0lTIFdyaXRlcyB0byB0aGUgZGV2aWNlIGNvbmZpZyAgICAqCiAq
ICAgICAgICAgICAgICAgIG9wdGlvbiByZWdpc3Rlci4gVGhlIHJlZ2lzdGVyIGNvbnRhaW5zIHRo
ZSAgICAgICAqCiAqICAgICAgICAgICAgICAgIGZvbGxvd2luZyBpbmZvOi0gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgIENPUl9DT05GSUdfTUFTSyBp
cyB1c2VkIHRvIHNldCB0aGUgaW5kZXggb2YgdGhlICAqCiAqICAgICAgICAgICAgICAgIGNhcmQn
cyBjdXJyZW50IG9wZXJhdGluZyBtb2RlICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAg
ICAgICAgIENPUl9MRUxFVkVMX0lSUSBzcGVjaWZpZXMgdGhhdCB0aGUgY2FyZCBzaG91bGQgICAq
CiAqICAgICAgICAgICAgICAgIGdlbmVyYXRlIGxldmVsIG1vZGUgaW50ZXJydXB0cyAoZGVmYXVs
dCkgICAgICAgICAqCiAqICAgICAgICAgICAgICAgIENPUl9TT0ZUX1JFU0VUIFNldHRpbmcgcGVy
Zm9ybXMgYSAnc29mdCByZXNldCcuICAqCiAqICAgICAgICAgICAgICAgIFVzZSBDYXJkIFNlcnZp
Y2VzIGNhbGwgUmVzZXRDYXJkIGluc3RlYWQgICAgICAgICAqCiAqICAgICAgICAgICAgICAgIFNl
ZSBDYXJkIFNlcnZpY2VzIGRvY3VtZW50YXRpb24gZm9yIG1vcmUgICAgICAgICAqCiAqICAgICAg
ICAgICAgICAgIGluZm9ybWF0aW9uICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAqCiAqIFBhcmFtZXRlcnM6ICAgIGhhbmRsZSAtIFBhc3MgYSB2YWxpZCBj
bGllbnQgaGFuZGxlOyBhcXVpcmVkIGZyb20qCiAqICAgICAgICAgICAgICAgICAgICAgICAgIHBs
aW5rLT5oYW5kbGUgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIHJl
dHVybjogICAgICAgICAwICAtIFN1Y2Nlc3M7IFRoZSB2YWx1ZSB3YXMgc3VjY2Vzc2Z1bGx5IHJl
YWQgICAqCiAqICAgICAgICAgICAgICAgICAhMCAtIEZhaWx1cmU7IEVycm9yIGNvZGVzIGFyZSBh
cyBkZWZpbmVkIGJ5ICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIENhcmRT
ZXJ2aWNlcyAgICAgICAgICAgICAgICAgICAgICAqCiAqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwpzdGF0aWMgaW50IHBj
bWFjZV9jc19TZXRDb25maWdPcHRpb25SZWdpc3RlcihzdHJ1Y3QgcGNtY2lhX2RldmljZSAqaGFu
ZGxlKQp7CiAgICBjb25mX3JlZ190IGNvbmZyZWc7CgogICAgREVCVUcoMTAsICIlczogZW50ZXJp
bmcgU2V0Q29uZmlnT3B0aW9uUmVnaXN0ZXI6ICVzICVzXG4iLAogICAgICAgICAgTU9EVUxFX05B
TUUsIGRldl9kcml2ZXJfc3RyaW5nKCZoYW5kbGUtPmRldiksIGhhbmRsZS0+ZGV2LmJ1c19pZCk7
CgogICAgY29uZnJlZy5GdW5jdGlvbiA9IDA7ICAvLyBJZ25vcmVkIGJ5IHRoZSBBY2Nlc3NDb25m
aWd1cmF0aW9uUmVnaXN0ZXIgQ1MgZnVuY3Rpb24gY2FsbAogICAgY29uZnJlZy5BY3Rpb24gPSBD
U19XUklURTsKICAgIGNvbmZyZWcuT2Zmc2V0ID0gQ0lTUkVHX0NPUjsgIC8vIFNlcGNpZnkgdGhl
IENvbmZpZ09wdGlvbiByZWdpc3RlcgogICAgY29uZnJlZy5WYWx1ZSA9IG1fYUNhcmRzW21fYk51
bWJlck9mQ2FyZHNdLkNJUy51Y0NvbmZpZ0luZGV4OwogICAgLy9Xcml0ZSBDYXJkIG1vZGUgdG8g
cmVnaXN0ZXIgZnJvbSBkZXZpY2UgQ0lTCiAgICByZXR1cm4gcGNtY2lhX2FjY2Vzc19jb25maWd1
cmF0aW9uX3JlZ2lzdGVyKGhhbmRsZSwgJmNvbmZyZWcpOwp9CgovKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiBGdW5j
dGlvbjogIHBjbWFjZV9jc19HZXRUdXBsZUluZm8gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKgogKiBEZXNjcmlwdGlvbjogICBHZXRzIHRoZSBkZXZpY2UgQ0lTIGlu
Zm8gdG8gY29uZmlndXJlIHRoZSBjYXJkICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBQYXJhbWV0ZXJzOiAg
ICBoYW5kbGUgLSBQYXNzIGEgdmFsaWQgY2xpZW50IGhhbmRsZSAgICAgICAgICAgICAgKgogKiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKgogKiByZXR1cm46ICAgICAwICAtIFN1Y2Nlc3M7IEFsbCBDSVMgdHVwbGVzIHdlcmUg
cmVhZCBzdWNjZXNzZnVsbHkgKgogKiAgICAgICAgICAgICAhMCAtIEZhaWx1cmU7IEVycm9yIGNv
ZGVzIGFyZSBhcyBkZWZpbmVkIGJ5ICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAg
ICAgIENhcmRTZXJ2aWNlcyAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8K
c3RhdGljIGludCBwY21hY2VfY3NfR2V0VHVwbGVJbmZvKHN0cnVjdCBwY21jaWFfZGV2aWNlICpo
YW5kbGUpCnsKICAgIGludCBuU3RhdHVzID0gMDsKCiAgICBERUJVRygxMCwgIiVzOiBlbnRlcmlu
ZyBHZXRUdXBsZUluZm86ICVzICVzXG4iLAogICAgICAgICAgTU9EVUxFX05BTUUsIGRldl9kcml2
ZXJfc3RyaW5nKCZoYW5kbGUtPmRldiksIGhhbmRsZS0+ZGV2LmJ1c19pZCk7CgogICAgaWYocGNt
YWNlX2NzX0dldERldmljZVR1cGxlSW5mbyhoYW5kbGUpICE9IDApCiAgICAgICAgblN0YXR1cyA9
IDE7CiAgICBpZihwY21hY2VfY3NfR2V0Q29uZmlnVHVwbGVJbmZvKGhhbmRsZSkgIT0gMCkKICAg
ICAgICBuU3RhdHVzID0gMjsKICAgIGlmKHBjbWFjZV9jc19HZXRDRlRhYmxlVHVwbGVJbmZvKGhh
bmRsZSkgIT0gMCkKICAgICAgICBuU3RhdHVzID0gMzsKICAgIGlmKHBjbWFjZV9jc19HZXRNYW5m
aWRUdXBsZUluZm8oaGFuZGxlKSAhPSAwKQogICAgICAgIG5TdGF0dXMgPSA0OwogICAgcmV0dXJu
IG5TdGF0dXM7Cn0KCi8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqCiAqIEZ1bmN0aW9uOiAgcGNtYWNlX2NzX0Rpc2xwYXlL
bm93bkNhcmRzICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIERlc2Ny
aXB0aW9uOiAgIERpc2xwYXlzIHRoZSBsaXN0IG9mIGNhcmRzIGtub3duIGJ5IHRoaXMgZHJpdmVy
ICAqCiAqICAgICAgICAgICAgICAgIENhbGwgdGhpcyBmdW5jdGlvbiBpZiBhbiB1bmtub3duIGNh
cmQgaXMgZm91bmQgICAqCiAqICAgICAgICAgICAgICAgIHRvIG5vdGlmeSBvZiBjYXJkcyBrbm93
biBieSB0aGlzIGRyaXZlciAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIFBhcmFtZXRlcnM6ICAg
IGhhbmRsZSAtIFBhc3MgYSB2YWxpZCBjbGllbnQgaGFuZGxlOyBhcXVpcmVkIGZyb20qCiAqICAg
ICAgICAgICAgICAgICAgICAgICAgIHBsaW5rLT5oYW5kbGUgICAgICAgICAgICAgICAgICAgICAg
ICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqCiAqIHJldHVybjogICAgIHZvaWQgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwpzdGF0aWMgdm9pZCBw
Y21hY2VfY3NfRGlzbHBheUtub3duQ2FyZHModm9pZCkKewogICAgaW50IG5TdHJpbmdJbmRleCA9
IDA7CgogICAgd2hpbGUobV9jc3pBcnJLbm93bkNhcmRzW25TdHJpbmdJbmRleF1bMF0gIT0gMCkK
ICAgIHsKICAgICAgICBwcmludGsoIiVzOiBLbm93biBDYXJkczogJXNcbiIsIE1PRFVMRV9OQU1F
LCBtX2NzekFycktub3duQ2FyZHNbblN0cmluZ0luZGV4XSk7CiAgICAgICAgblN0cmluZ0luZGV4
Kys7CiAgICB9Cn0KCi8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqCiAqIEZ1bmN0aW9uOiAgcGNtYWNlX2NzX1Byb2Nlc3NW
ZXJzaW9uMVR1cGxlICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIERlc2Ny
aXB0aW9uOiAgIENoZWNrcyB3aGV0aGVyIHRoZSBjYXJkIGlzIGtub3duIGJ5IHRoZSBkcml2ZXIg
ICAqCiAqICAgICAgICAgICAgICAgIFRoZSBjYXJkIGRlYXRhaWxzIGFyZSBzdG9yZWQgYXMgdGV4
dCBmb3JtYXQgaW4gICAqCiAqICAgICAgICAgICAgICAgIHRoZSBWZXJzaW9uMSB0dXBsZS4gVGhl
IFZlcnNpb24xIHR1cGxlIGNvbnRhaW5zICAqCiAqICAgICAgICAgICAgICAgIDQgc3RyaW5ncywg
dGhlIHNlY29uZCBzdHJpbmcgaXMgdGhlIGNhcmQgbW9kZWwgICAqCiAqICAgICAgICAgICAgICAg
IFRoZSBjYXJkIG1vZGVsIHN0cmluZyBpcyBtYXRjaGVkIGJ5IGEgbGlzdCBvZiAgICAqCiAqICAg
ICAgICAgICAgICAgIG1vZGVscyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqCiAqIFBhcmFtZXRlcnM6ICAgIGhhbmRsZSAtIFBhc3MgYSB2YWxp
ZCBjbGllbnQgaGFuZGxlOyBhcXVpcmVkICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAg
IGZyb20gcGxpbmstPmhhbmRsZSAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAq
IHJldHVybjogICAgIDAgIC0gU3VjY2VzczsgVGhlIENJUyB3YXMgcmVhZCBhbmQgdGhlIG1vZGVs
IHRleHQgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1hdGNoZWQgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAhMCAtIEZhaWx1cmU7IEVycm9y
IGNvZGVzIGFyZSBhcyBkZWZpbmVkIGJ5ICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIENhcmRTZXJ2aWNlcyAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
LwpzdGF0aWMgaW50IHBjbWFjZV9jc19Qcm9jZXNzVmVyc2lvbjFUdXBsZShzdHJ1Y3QgcGNtY2lh
X2RldmljZSAqaGFuZGxlKQp7CiAgICBjaXNwYXJzZV90IGNpc3BhcnNlOwogICAgY2lzdHBsX3Zl
cnNfMV90ICpwdmVyc2lvbl8xID0gJihjaXNwYXJzZS52ZXJzaW9uXzEpOwogICAgaW50IG5TdHJp
bmdJbmRleDsKCiAgICBjaGFyKiBzelN0cmluZzsKICAgIGNoYXIgc3pNZXNzYWdlWzEwMDBdOyAg
IC8vIFVzZWQgdG8gZGlzcGxheSBjYXJkIGRldGFpbHMKICAgIGludCBuU3RhdHVzOwogICAgVTMy
QklUICAgIGFkd0NhcmRJRFtBQ0U1M19NQVhfTlVNX0tOT1dOX0NBUkRTXSA9IHsgREVWSURfQlU2
NTU1ME0yXzMwMCwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIERFVklEX0JVNjU1NTBNMl82MDIsCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBERVZJRF9CVTY1NTUxTTJfMzAwLAogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgREVWSURfQlU2
NTU1Mk0yXzMwMCwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIERFVklEX0JVNjU1NTNNMl8zMDAsCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBERVZJRF9CVTY1NTUwTTJfNjA1ICB9OwoKICAg
IG1fYUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLmR3Q2FyZElEID0gVU5LTk9XTl9DQVJEOwoKICAg
IERFQlVHKDEwLCAiJXM6IGVudGVyaW5nIFByb2Nlc3NWZXJzaW9uMVR1cGxlOiAlcyAlc1xuIiwK
ICAgICAgICAgIE1PRFVMRV9OQU1FLCBkZXZfZHJpdmVyX3N0cmluZygmaGFuZGxlLT5kZXYpLCBo
YW5kbGUtPmRldi5idXNfaWQpOwoKICAgIGlmKChuU3RhdHVzID0gcGNtYWNlX2NzX0dldFR1cGxl
KENJU1RQTF9WRVJTXzEsICZjaXNwYXJzZSkpID09IDApCiAgICB7CiAgICAgICAgLy8gRGlzbHBh
eSBDYXJkIGRldGFpbHMKICAgICAgICBzek1lc3NhZ2VbMF0gPSAwOwogICAgICAgIGZvcihuU3Ry
aW5nSW5kZXggPSAwOyBuU3RyaW5nSW5kZXggPCBwdmVyc2lvbl8xLT5uczsgblN0cmluZ0luZGV4
KyspCiAgICAgICAgewogICAgICAgICAgICBzelN0cmluZyA9ICYocHZlcnNpb25fMS0+c3RyW3B2
ZXJzaW9uXzEtPm9mc1tuU3RyaW5nSW5kZXhdXSk7CiAgICAgICAgICAgIHN0cmNhdChzek1lc3Nh
Z2UsIHN6U3RyaW5nKTsKICAgICAgICAgICAgc3RyY2F0KHN6TWVzc2FnZSwgIiAiKTsKICAgICAg
ICB9CiAgICAKICAgICAgICBwcmludGsoIiVzOiBDYXJkOiAlc1xuIiwgTU9EVUxFX05BTUUsIHN6
TWVzc2FnZSk7CgogICAgICAgIGlmKHB2ZXJzaW9uXzEtPm5zID49IDIpICAvLyBDaGVjayB3aGV0
aGVyIG1vZGVsIGlzIGtub3duCiAgICAgICAgewogICAgICAgICAgICBzelN0cmluZyA9ICYocHZl
cnNpb25fMS0+c3RyW3B2ZXJzaW9uXzEtPm9mc1sxXV0pOwogICAgICAgICAgICBuU3RyaW5nSW5k
ZXggPSAwOwogICAgICAgICAgICB3aGlsZShtX2NzekFycktub3duQ2FyZHNbblN0cmluZ0luZGV4
XVswXSAhPSAwKSAgLy8gQ2hlY2sgYWdhaW5zdCBlYWNoIGtub3duIG1vZGVsCiAgICAgICAgICAg
IHsKICAgICAgICAgICAgICAgIGlmKHN0cmNtcChtX2NzekFycktub3duQ2FyZHNbblN0cmluZ0lu
ZGV4XSwgc3pTdHJpbmcpID09IDApCiAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAg
ICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uZHdDYXJkSUQgPSBhZHdDYXJkSURbblN0cmlu
Z0luZGV4XTsKICAgICAgICAgICAgICAgIH0KCiAgICAgICAgICAgICAgICBuU3RyaW5nSW5kZXgr
KzsKICAgICAgICAgICAgfQogICAgICAgIH0KICAgIH0KCiAgICAvLyBEaXNwbGF5IGxpc3Qgb2Yg
a25vd24gY2FyZHMgaWYgY2FyZCBpcyBub3Qga25vd24KICAgIGlmKG1fYUNhcmRzW21fYk51bWJl
ck9mQ2FyZHNdLmR3Q2FyZElEID09IFVOS05PV05fQ0FSRCkKICAgICAgICBwY21hY2VfY3NfRGlz
bHBheUtub3duQ2FyZHMoKTsKICAgIHJldHVybiBuU3RhdHVzOwp9CgovKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiBG
dW5jdGlvbjogcGNtYWNlX2NzX0NsZWFyQ2FyZElPU3RydWN0ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKgogKiBEZXNjcmlwdGlvbjogICBNYWtlcyBzdXJlIG5vIHJlc291
cmNlcyBhcmUgcmVxdWVzdGVkLiBTb21lICAgICAgKgogKiAgICAgICAgICAgICAgICBjYXJkcyBy
ZXF1ZXN0IElPLCBzb21lIGRvbid0IGV0Yy4gIE1ha2Ugc3VyZSAgICAgKgogKiAgICAgICAgICAg
ICAgICBvbmx5IG5lZWRlZCByZXNvdXJjZXMgYXJlIHJlcXVlc3RlZCAgICAgICAgICAgICAgKgog
KiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKgogKiBQYXJhbWV0ZXJzOiAgIHBsaW5rIC0gUGFzcyBhIHZhbGlkIGRldmljZSBw
b2ludGVyLiAgSXQgaXMgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgYXF1aXJlZCBm
cm9tIHRoZSBkZXZpY2UgZXZlbnQgaGFuZGxlciAgICAgKgogKiAgICAgICAgICAgICAgICAgICAg
ICAgZ2VuZXJhbGx5IHBjbWFjZV9jc19jb25maWcoKSAgICAgICAgICAgICAgKgogKiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KgogKiByZXR1cm46ICAgICB2b2lkICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3RhdGljIHZvaWQgcGNtYWNlX2NzX0NsZWFyQ2Fy
ZElPU3RydWN0KHN0cnVjdCBwY21jaWFfZGV2aWNlICpwbGluaykKewogICAgaW50IG5JbmRleDsK
CiAgICBERUJVRygxMCwgIiVzOiBlbnRlcmluZyBDbGVhckNhcmRJT1N0cnVjdDogJXMgJXNcbiIs
CiAgICAgICAgICBNT0RVTEVfTkFNRSwgZGV2X2RyaXZlcl9zdHJpbmcoJnBsaW5rLT5kZXYpLCBw
bGluay0+ZGV2LmJ1c19pZCk7CgogICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10ucGxpbmsg
PSBwbGluazsKICAgIG1fYUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy51bkFjY2Vzc1NwZWVk
ID0gMDsKICAgIG1fYUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy51bk1lbW9yeVNpemUgPSAw
OwogICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uZHdDYXJkSUQgPSAtMTsKICAgIG1fQ2Fy
ZElPW21fYk51bWJlck9mQ2FyZHNdLmNJT1JlcXVlc3QgPSBfX05PVFJFUVVFU1RFRF9fOwogICAg
bV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10uY0lSUVJlcXVlc3QgPSBfX05PVFJFUVVFU1RFRF9f
OwoKICAgIG1fYUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy51Y0NvbmZpZ0luZGV4ID0gMDsK
CiAgICBtX2FDYXJkc1ttX2JOdW1iZXJPZkNhcmRzXS5DSVMuaW8ubndpbiA9IDA7CiAgICBtX2FD
YXJkc1ttX2JOdW1iZXJPZkNhcmRzXS5DSVMuaXJxLklSUUluZm8xID0gMDsKICAgIG1fYUNhcmRz
W21fYk51bWJlck9mQ2FyZHNdLkNJUy5pcnEuSVJRSW5mbzIgPSAwOwogICAgbV9hQ2FyZHNbbV9i
TnVtYmVyT2ZDYXJkc10uQ0lTLm1lbS5ud2luID0gMDsKCiAgICAvLyBJbml0aWFsaXNlIG1lbW9y
eSB3aW5kb3cgaW5mbwogICAgZm9yKG5JbmRleCA9IDA7IG5JbmRleCA8IEFDRTUzX01BWF9OVU1f
V0lORE9XUzsgbkluZGV4KyspCiAgICB7CiAgICAgICAgbV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJk
c10uV2luQXJyW25JbmRleF0ucmVxLkF0dHJpYnV0ZXMgPQogICAgICAgICAgICBXSU5fREFUQV9X
SURUSF8xNiB8IFdJTl9NRU1PUllfVFlQRV9DTSB8IFdJTl9FTkFCTEUgfCBXSU5fVVNFX1dBSVQ7
CiAgICAgICAgbV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10uV2luQXJyW25JbmRleF0ucmVxLkJh
c2UgPSAwOwogICAgICAgIG1fQ2FyZElPW21fYk51bWJlck9mQ2FyZHNdLldpbkFycltuSW5kZXhd
LndpbmhhbmRsZSA9CiAgICAgICAgICAgICh3aW5kb3dfaGFuZGxlX3QpcGxpbms7CiAgICAgICAg
bV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10uV2luQXJyW25JbmRleF0udWxXaW5kb3dTaXplID0g
MDsKICAgICAgICBtX0NhcmRJT1ttX2JOdW1iZXJPZkNhcmRzXS5XaW5BcnJbbkluZGV4XS5wbkRp
cmVjdFBoeXNpY2FsQWRkciA9ICBOVUxMOwogICAgICAgIG1fQ2FyZElPW21fYk51bWJlck9mQ2Fy
ZHNdLldpbkFycltuSW5kZXhdLnBuRGlyZWN0S2VybmVsQWRkciA9IE5VTEw7CiAgICAgICAgbV9D
YXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10uV2luQXJyW25JbmRleF0uY0FycldpbmRvd1JlcXVlc3Qg
PQogICAgICAgICAgICBfX05PVFJFUVVFU1RFRF9fOwogICAgfQp9CgovKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiBG
dW5jdGlvbjogcGNtYWNlX2NzX0luaXRLbm93bkNhcmRMaXN0ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKgogKiBEZXNjcmlwdGlvbjogICBJbml0aWFsaXNlcyB0aGUgbGlz
dCBvZiBjYXJkIG1vZGVsIHN0cmluZ3Mgd2l0aCAgKgogKiAgICAgICAgICAgICAgICBtYXRjaGlu
ZyBtYWNybyBuYW1lcyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgog
KiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKgogKiBOb3RlOiBXaGVuIGFkZGluZyBuZXcga25vd24gY2FyZCBtb2RlbHMgdG8g
dGhlIGxpc3QsIG1ha2Ugc3VyZSAgKgogKiAgICAgICB0aGUgdmFsdWUgb2YgTUFYX05VTV9LTk9X
Tl9DQVJEUyBpcyBncmVhdGVyIHRoYW4gdGhlIGNhcmQgKgogKiAgICAgICBuYW1lIG1hY3JvcyB1
c2VkLiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KgogKiBQYXJhbWV0ZXJzOiAgIHZvaWQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKgogKiByZXR1cm46ICAgICAgIHZvaWQgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3RhdGlj
IHZvaWQgcGNtYWNlX2NzX0luaXRLbm93bkNhcmRMaXN0KHZvaWQpCnsKICAgIGludCBuSW5kZXg7
CgogICAgREVCVUcoMTAsICIlczogZW50ZXJpbmcgSW5pdEtub3duQ2FyZExpc3RcbiIsIE1PRFVM
RV9OQU1FKTsKCiAgICBmb3IobkluZGV4ID0gMDsgbkluZGV4IDwgQUNFNTNfTUFYX05VTV9LTk9X
Tl9DQVJEUzsgbkluZGV4KyspCiAgICAgICAgbV9jc3pBcnJLbm93bkNhcmRzW25JbmRleF1bMF0g
PSAwOwogICAgc3RyY3B5KG1fY3N6QXJyS25vd25DYXJkc1tERVZJRF9TVFJJTkdORFhfQlU2NTU1
ME0yXzMwMF0sICJCVS02NTU1ME0yLTMwMCIpOwogICAgc3RyY3B5KG1fY3N6QXJyS25vd25DYXJk
c1tERVZJRF9TVFJJTkdORFhfQlU2NTU1ME0yXzYwMl0sICJCVS02NTU1ME0yLTYwMiIpOwogICAg
c3RyY3B5KG1fY3N6QXJyS25vd25DYXJkc1tERVZJRF9TVFJJTkdORFhfQlU2NTU1MU0yXzMwMF0s
ICJCVS02NTU1MU0yLTMwMCIpOwogICAgc3RyY3B5KG1fY3N6QXJyS25vd25DYXJkc1tERVZJRF9T
VFJJTkdORFhfQlU2NTU1Mk0yXzMwMF0sICJCVS02NTU1Mk0yLTMwMCIpOwogICAgc3RyY3B5KG1f
Y3N6QXJyS25vd25DYXJkc1tERVZJRF9TVFJJTkdORFhfQlU2NTU1M00yXzMwMF0sICJCVS02NTU1
M00yLTMwMCIpOwogICAgc3RyY3B5KG1fY3N6QXJyS25vd25DYXJkc1tERVZJRF9TVFJJTkdORFhf
QlU2NTU1ME0yXzYwNV0sICJCVS02NTU1ME0yLTYwNSIpOwp9CgovKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiBGdW5j
dGlvbjogcGNtYWNlX2NzX1JlcXVlc3RDb25maWd1cmF0aW9uICAgICAgICAgICAgICAgICAgICAg
ICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKgogKiBEZXNjcmlwdGlvbjogIFRoZSBDYXJkIGNvbmZpZ3VyYXRpb24g
b2NjdXJzIGhlcmUuIEl0IGNvbmZpZ3VyZXMgKgogKiAgICAgICAgICAgICAgIHJlc291cmNlcyBy
ZXF1ZXN0ZWQuIFVzZSBDYXJkU2VydmljZXMgY2FsbHMgdG8gICAgKgogKiAgICAgICAgICAgICAg
IHJlcXVlc3QgY2FyZCByZXNvdXJjZXMgYmVmb3JlIGNhbGxpbmcgdGhpcyAgICAgICAgKgogKiAg
ICAgICAgICAgICAgIGZ1bmN0aW9uICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBQYXJhbWV0ZXJz
OiAgIHBsaW5rIC0gUGFzcyBhIHZhbGlkIGRldmljZSBwb2ludGVyLiAgICAgICAgICAgICAgKgog
KiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKgogKiByZXR1cm46ICAgICAgIDAgIC0gU3VjY2VzczsgQWxsIHJlc291cmNlcyBy
ZXF1ZXN0ZWQgd2VyZSAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3Vj
Y2Vzc2Z1bGx5IGNvbmZpZ3VyZWQgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICEwIC0g
RmFpbHVyZTsgRXJyb3IgY29kZXMgYXJlIGFzIGRlZmluZWQgYnkgICAgICAgKgogKiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgQ2FyZFNlcnZpY2VzICAgICAgICAgICAgICAgICAgICAgICAg
KgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKi8Kc3RhdGljIGludCBwY21hY2VfY3NfUmVxdWVzdENvbmZpZ3VyYXRpb24o
c3RydWN0IHBjbWNpYV9kZXZpY2UgKnBsaW5rKQp7CiAgICBpbnQgblN0YXR1czsKCiAgICBERUJV
RygxMCwgIiVzOiBlbnRlcmluZyBSZXF1ZXN0Q29uZmlndXJhdGlvbjogJXMgJXNcbiIsCiAgICAg
ICAgICBNT0RVTEVfTkFNRSwgZGV2X2RyaXZlcl9zdHJpbmcoJnBsaW5rLT5kZXYpLCBwbGluay0+
ZGV2LmJ1c19pZCk7CgogICAgLyogc2V0IGNhcmQgaW5mb3JtYXRpb24gKi8KICAgIG1fYUNhcmRz
W21fYk51bWJlck9mQ2FyZHNdLkNoYW5uZWwuYk9wZW4gPSAwOwoKICAgIC8qCiAgICAgICBUaGlz
IGFjdHVhbGx5IGNvbmZpZ3VyZXMgdGhlIFBDTUNJQSBzb2NrZXQgLS0gc2V0dGluZyB1cAogICAg
ICAgdGhlIEkvTyB3aW5kb3dzIGFuZCB0aGUgaW50ZXJydXB0IG1hcHBpbmcsIGFuZCBwdXR0aW5n
IHRoZQogICAgICAgY2FyZCBhbmQgaG9zdCBpbnRlcmZhY2UgaW50byAiTWVtb3J5IGFuZCBJTyIg
bW9kZS4KICAgICovCiAgICBwbGluay0+Y29uZi5BdHRyaWJ1dGVzID0gQ09ORl9FTkFCTEVfSVJR
IHwgQ09ORl9FTkFCTEVfRE1BOwogICAgcGxpbmstPmNvbmYuSW50VHlwZSA9IElOVF9NRU1PUllf
QU5EX0lPOwogICAgcGxpbmstPmNvbmYuQ29uZmlnQmFzZSA9IG1fYUNhcmRzW21fYk51bWJlck9m
Q2FyZHNdLkNJUy51bkNvbmZpZ0Jhc2U7CiAgICBwbGluay0+Y29uZi5Db25maWdJbmRleCA9IG1f
YUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy51Y0NvbmZpZ0luZGV4OwogICAgcGxpbmstPmNv
bmYuUHJlc2VudCA9IG1fYUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLkNJUy51blByZXNlbnQ7CiAg
ICBpZigoblN0YXR1cyA9IHBjbWNpYV9yZXF1ZXN0X2NvbmZpZ3VyYXRpb24ocGxpbmssICZwbGlu
ay0+Y29uZikpICE9IDApCiAgICB7CiAgICAgICAgcHJpbnRrKCIlczogUmVxdWVzdENvbmZpZ3Vy
YXRpb24gZmFpbGVkXG4iLCBNT0RVTEVfTkFNRSk7CiAgICAgICAgcGNtYWNlX2NzX3JlbGVhc2Uo
cGxpbmspOwogICAgfTsKICAgIHJldHVybiBuU3RhdHVzOwp9CgovKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiBGdW5j
dGlvbjogcGNtYWNlX2NzX1ZhbGlkYXRlQ0lTICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKgogKiBEZXNjcmlwdGlvbjogIFJldHVybnMgd2hldGhlciB0aGUgY2Fy
ZCBDSVMgaXMgdmFsaWQuICBUaGlzIGlzICAgKgogKiAgICAgICAgICAgICAgIGRldGVybWluZWQg
YnkgQ2FyZCBTZXJ2aWNlcy4gIFRoZSBkcml2ZXIgZXhpdHMgICAgKgogKiAgICAgICAgICAgICAg
IHdpdGhvdXQgYXR0ZW1wdGluZyB0byBjb25maWd1cmUgaWYgdGhlIENJUyBpcyAgICAgKgogKiAg
ICAgICAgICAgICAgIGludmFsaWQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBQYXJhbWV0ZXJz
OiAgIHBsaW5rIC0gUGFzcyBhIHZhbGlkIGRldmljZSBwb2ludGVyLiAgICAgICAgICAgICAgKgog
KiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKgogKiByZXR1cm46ICAgICAgIDAgIC0gU3VjY2VzczsgVGhlIENJUyBpcyB2YWxp
ZCAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICEwIC0gRmFpbHVyZTsgRXJy
b3IgY29kZXMgYXJlIGFzIGRlZmluZWQgYnkgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgQ2FyZFNlcnZpY2VzICAgICAgICAgICAgICAgICAgICAgICAgKgogKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
Ki8Kc3RhdGljIGludCBwY21hY2VfY3NfVmFsaWRhdGVDSVMoc3RydWN0IHBjbWNpYV9kZXZpY2Ug
KnBsaW5rKQp7CiAgICBjaXNpbmZvX3QgY2lzaW5mbzsKICAgIGludCBuU3RhdHVzOwoKICAgIERF
QlVHKDEwLCAiJXM6IGVudGVyaW5nIFZhbGlkYXRlQ0lTOiAlcyAlc1xuIiwKICAgICAgICAgIE1P
RFVMRV9OQU1FLCBkZXZfZHJpdmVyX3N0cmluZygmcGxpbmstPmRldiksIHBsaW5rLT5kZXYuYnVz
X2lkKTsKCiAgICBuU3RhdHVzID0gcGNtY2lhX3ZhbGlkYXRlX2NpcyhwbGluaywgJmNpc2luZm8p
OwogICAgaWYoblN0YXR1cyA9PSBDU19TVUNDRVNTKQogICAgewogICAgICAgIG1fYUNhcmRzW21f
Yk51bWJlck9mQ2FyZHNdLnBsaW5rID0gcGxpbms7CiAgICB9CiAgICBlbHNlCiAgICB7CiAgICAg
ICAgcHJpbnRrKCIlczogVmFsaWRhdGVDSVMgZmFpbGVkLCBjYW5ub3QgY29uZmlndXJlIGNhcmQs
IGV4aXRpbmciLAogICAgICAgICAgICAgICBNT0RVTEVfTkFNRSk7CiAgICAgICAgcGNtYWNlX2Nz
X3JlbGVhc2UocGxpbmspOwogICAgfQoKICAgIHJldHVybihuU3RhdHVzKTsKfQoKLyoqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioKICogRnVuY3Rpb246ICBwY21hY2VfY3NfU3RvcmVDYXJkSW5mbyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICoKICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICoKICogRGVzY3JpcHRpb246ICBTdG9yZXMgcmVzb3Vy
Y2UgY29uZmlndXJhdGlvbiBkZWF0aWxzIGluIG1fYUNhcmRzLioKICogICAgICAgICAgICAgICBD
YXJkIHNlcnZpY2VzIHJlcXVlc3QgY29uZmlndXJhdGlvbiBtdXN0IGJlICAgICAgICoKICogICAg
ICAgICAgICAgICBjYWxsZWQgYmVmb3JlIHRoaXMgZnVuY3Rpb24gaXMgY2FsbGVkLiAgICAgICAg
ICAgICoKICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICoKICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICoKICogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICoKICogUGFyYW1ldGVyczog
ICBwbGluayAtIFBhc3MgYSB2YWxpZCBkZXZpY2UgcG9pbnRlci4gICAgICAgICAgICAgICoKICog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICoKICogcmV0dXJuOiAgICAgICB2b2lkICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICoKICoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKiovCnN0YXRpYyB2b2lkIHBjbWFjZV9jc19T
dG9yZUNhcmRJbmZvKHN0cnVjdCBwY21jaWFfZGV2aWNlICpwbGluaykKewogICAgREVCVUcoMTAs
ICIlczogZW50ZXJpbmcgU3RvcmVDYXJkSW5mbzogJXMgJXNcbiIsCiAgICAgICAgICBNT0RVTEVf
TkFNRSwgZGV2X2RyaXZlcl9zdHJpbmcoJnBsaW5rLT5kZXYpLCBwbGluay0+ZGV2LmJ1c19pZCk7
CgogICAgLyogc2V0IGNhcmQgaW5mb3JtYXRpb24gKi8KICAgIG1fYUNhcmRzW21fYk51bWJlck9m
Q2FyZHNdLmR3Q2hhbk1lbUxlbiAgPQogICAgICAgIG1fYUNhcmRzW21fYk51bWJlck9mQ2FyZHNd
LkNJUy5tZW0ud2luWzFdLmxlbjsKICAgIG1fYUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLmJQY2lC
dXNOdW0gICAgPSAwOwogICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uYlBjaURldk51bSAg
ICA9IDA7CiAgICBtX2FDYXJkc1ttX2JOdW1iZXJPZkNhcmRzXS5iUGNpRmNuTnVtICAgID0gMDsK
ICAgIG1fYUNhcmRzW21fYk51bWJlck9mQ2FyZHNdLndJcnEgICAgICAgICAgPSBwbGluay0+aXJx
LkFzc2lnbmVkSVJROwogICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uYk51bUNobmxzICAg
ICA9IDI7CiAgICBtX2FDYXJkc1ttX2JOdW1iZXJPZkNhcmRzXS5DaGFubmVsLmJPcGVuID0gMDsK
CiAgICAvKiBQY21jaWEgV2luZG93cyAqLwogICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10u
ZHdNZW1XbmRQY21jaWFBZGRyID0KICAgICAgICAoVTMyKShtX0NhcmRJT1ttX2JOdW1iZXJPZkNh
cmRzXS5XaW5BcnJbMV0ucmVxLkJhc2UpOwogICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10u
ZHdSZWdXbmRQY21jaWFBZGRyID0KICAgICAgICAoVTMyKShtX0NhcmRJT1ttX2JOdW1iZXJPZkNh
cmRzXS5XaW5BcnJbMF0ucmVxLkJhc2UpOwogICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10u
ZHdSZWdXbmRLcm5BZGRyICAgID0gKFUzMilOVUxMOwogICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZD
YXJkc10uZHdNZW1XbmRLcm5BZGRyICAgID0gKFUzMilOVUxMOwoKICAgIC8qIENoYW5uZWwgMCAq
LwogICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uQ2hhbm5lbC5kd01lbVduZFVzckFkZHIg
PSAoVTMyKU5VTEw7CgogICAgbV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJkc10uQ2hhbm5lbC5kd1Jl
Z1duZFVzckFkZHIgPSAoVTMyKU5VTEw7Cn0KCi8qKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAqIEZ1bmN0aW9uOiAgcGNt
YWNlX2NzX0Rpc3BsYXlDYXJkSW5mbyAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAqCiAqIERlc2NyaXB0aW9uOiAgRGlzcGxheXMgY2FyZCBpbmZvLiAgVGhpcyBpcyBjYWxs
ZWQgYWZ0ZXIgdGhlICAgICAqCiAqICAgICAgICAgICAgICAgY2FyZCBpcyBjb25maWd1cmVkLiAg
cHJpbnRzIHJlc291cmNlIGluZm8gICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAq
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAqCiAqIFBhcmFtZXRlcnM6ICAgcGxpbmsgLSBQYXNzIGEgdmFsaWQgZGV2aWNlIHBv
aW50ZXIuICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIHJldHVybjogICAgICAgdm9pZCAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
LwpzdGF0aWMgdm9pZCBwY21hY2VfY3NfRGlzcGxheUNhcmRJbmZvKHN0cnVjdCBwY21jaWFfZGV2
aWNlICpwbGluaykKewogICAgaW50IG5JbmRleDsKCiAgICBERUJVRygxMCwgIiVzOiBlbnRlcmlu
ZyBEaXNwbGF5Q2FyZEluZm86ICVzICVzXG4iLAogICAgICAgICAgTU9EVUxFX05BTUUsIGRldl9k
cml2ZXJfc3RyaW5nKCZwbGluay0+ZGV2KSwgcGxpbmstPmRldi5idXNfaWQpOwoKICAgIC8qIEZp
bmFsbHksIHJlcG9ydCB3aGF0IHdlJ3ZlIGRvbmUgKi8KICAgIHByaW50ayhLRVJOX0lORk8gIiVz
OiBpbmRleCAweCUwMngiLCBwbGluay0+ZGV2bmFtZSwgcGxpbmstPmNvbmYuQ29uZmlnSW5kZXgp
OwogICAgaWYgKHBsaW5rLT5pby5OdW1Qb3J0czEpCiAgICB7CiAgICAgICAgcHJpbnRrKCIsIGlv
IDB4JTA0eC0weCUwNHgiLCBwbGluay0+aW8uQmFzZVBvcnQxLAogICAgICAgICAgICAgICBwbGlu
ay0+aW8uQmFzZVBvcnQxICsgcGxpbmstPmlvLk51bVBvcnRzMSAtIDEpOwogICAgfQogICAgaWYg
KHBsaW5rLT5pby5OdW1Qb3J0czIpCiAgICB7CiAgICAgICAgcHJpbnRrKCIgJiAweCUwNHgtMHgl
MDR4IiwgcGxpbmstPmlvLkJhc2VQb3J0MiwKICAgICAgICAgICAgICAgcGxpbmstPmlvLkJhc2VQ
b3J0MiArIHBsaW5rLT5pby5OdW1Qb3J0czIgLSAxKTsKICAgIH0KICAgIGlmIChwbGluay0+Y29u
Zi5BdHRyaWJ1dGVzICYgQ09ORl9FTkFCTEVfSVJRKQogICAgewogICAgICAgIHByaW50aygiLCBp
cnEgJWQiLCBwbGluay0+aXJxLkFzc2lnbmVkSVJRKTsKICAgIH0KCiAgICBwcmludGsoIlxuJXM6
IE1lbW9yeSBXaW5kb3dzOlxuIiwgTU9EVUxFX05BTUUpOwogICAgbkluZGV4ID0gMDsKICAgIHdo
aWxlKG1fQ2FyZElPW21fYk51bWJlck9mQ2FyZHNdLldpbkFycltuSW5kZXhdLmNBcnJXaW5kb3dS
ZXF1ZXN0ID09IF9fUkVRVUVTVEVEX18pCiAgICB7CiAgICAgICAgcHJpbnRrKCIlczogICAgd2lu
WyVkXTogMHglbHgtMHglbHggQCBDYXJkIE9mZnNldDogMHgleFxuIiwKICAgICAgICAgICAgICAg
TU9EVUxFX05BTUUsIG5JbmRleCwKICAgICAgICAgICAgICAgbV9DYXJkSU9bbV9iTnVtYmVyT2ZD
YXJkc10uV2luQXJyW25JbmRleF0ucmVxLkJhc2UsCiAgICAgICAgICAgICAgIG1fQ2FyZElPW21f
Yk51bWJlck9mQ2FyZHNdLldpbkFycltuSW5kZXhdLnJlcS5CYXNlCiAgICAgICAgICAgICAgICsg
bV9DYXJkSU9bbV9iTnVtYmVyT2ZDYXJkc10uV2luQXJyW25JbmRleF0ucmVxLlNpemUgLSAxLAog
ICAgICAgICAgICAgICBtX0NhcmRJT1ttX2JOdW1iZXJPZkNhcmRzXS5XaW5BcnJbbkluZGV4XS5t
YXAuQ2FyZE9mZnNldCk7CiAgICAgICAgbkluZGV4Kys7CiAgICB9CgogICAgaWYobV9DYXJkSU9b
bV9iTnVtYmVyT2ZDYXJkc10ubk51bVdpbmRvd3MgPT0gMCkKICAgIHsKICAgICAgICBwcmludGso
IiVzOiAgICBObyB3aW5kb3dzIHByb3ZpZGVkIGJ5IENJU1xuIiwgTU9EVUxFX05BTUUpOwogICAg
fQoKICAgIHByaW50aygiJXM6IE1vZHVsZSBMb2FkZWQ6XG4gIChFTkhBTkNFRCBNSU5JKSBBQ0U6
IC0gVXNlICcvdXNyL3NiaW4vZGRjX3BjbWFjZV9sb2FkJyB0byB1c2UgdGhpcyBkZXZpY2VcbiIs
CiAgICAgICAgICAgTU9EVUxFX05BTUUpOwoKICAgaWYobV9hQ2FyZHNbbV9iTnVtYmVyT2ZDYXJk
c10uZHdDYXJkSUQgPT0gVU5LTk9XTl9DQVJEKQogICB7CiAgICAgICBwcmludGsoIiVzOiBVbmtu
b3duIGNhcmQsIHVubG9hZGluZyBtb2R1bGVcbiIsIE1PRFVMRV9OQU1FKTsKICAgICAgIHBjbWFj
ZV9jc19yZWxlYXNlKHBsaW5rKTsKICAgfQp9CgovKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiBGdW5jdGlvbjogIHBj
bWFjZV9jc19jb25maWcgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKgogKiBEZXNjcmlwdGlvbjogIENvbmZpZ3VyZXMgdGhlIGNhcmQgZm9yIHVzZSAgICAg
ICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgIFRoZSBjYXJkIHdpbGwgYmUgcmVq
ZWN0ZWQgaWYgYW55IG9mIHRoZSBmb2xsb3dpbmcgKgogKiAgICAgICAgICAgICAgIG9jY3Vyczot
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAg
ICAgIFRoZSBjYXJkIENJUyBjYW5ub3QgYmUgcmVhZCAgICAgICAgICAgICAgICAgICAgICAgKgog
KiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKgogKiAgICAgICAgICAgICAgIFRoZSBjYXJkIGlzIG5vdCBrbm93bjsgIFRoZSBj
YXJkIHdpbGwgYmUgICAgICAgICAgKgogKiAgICAgICAgICAgICAgIGNvbmZpZ3VyZWQgYW5kIGNv
bmZpZ3VyYXRpb24gd2lsbCBiZSBkaXNwbGF5ZWQuIEEgKgogKiAgICAgICAgICAgICAgIGxpc3Qg
b2Yga25vd24gY2FyZHMgd2lsbCBiZSBkaXBsYXllZC4gIFRoZSAgICAgICAgKgogKiAgICAgICAg
ICAgICAgIGNvbmZpZ3VyYXRpb24gd2lsbCBiZSByZWxlYXNlZC4gICAgICAgICAgICAgICAgICAg
KgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgIFRoZSBHZXRDb25maWd1cmF0aW9uSW5mbyBD
YXJkIFNlcnZpY2VzIGZ1bmN0aW9uICAgKgogKiAgICAgICAgICAgICAgIGNhbGwgZmFpbGVkICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAg
ICAgICAgICAgIFRoZSBSZXF1ZXN0Q29uZmlndXJhdGlvbiBDYXJkIFNlcnZpY2VzIGZ1bmN0aW9u
ICAgKgogKiAgICAgICAgICAgICAgIGNhbGwgZmFpbGVkICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBQ
YXJhbWV0ZXJzOiAgIHBsaW5rIC0gUGFzcyBhIHZhbGlkIGRldmljZSBwb2ludGVyLiAgICAgICAg
ICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKgogKiByZXR1cm46ICAgICAgIHZvaWQgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3RhdGljIHZvaWQg
cGNtYWNlX2NzX2NvbmZpZyhzdHJ1Y3QgcGNtY2lhX2RldmljZSAqcGxpbmspCnsKICAgIGNvbmZp
Z19pbmZvX3QgY29uZjsKCiAgICBERUJVRygxMCwgIiVzOiBlbnRlcmluZyBjb25maWc6ICVzICVz
XG4iLAogICAgICAgICAgTU9EVUxFX05BTUUsIGRldl9kcml2ZXJfc3RyaW5nKCZwbGluay0+ZGV2
KSwgcGxpbmstPmRldi5idXNfaWQpOwogICAgZHVtcFN0cnVjdCgpOwoKICAgIGlmKHBjbWFjZV9j
c19WYWxpZGF0ZUNJUyhwbGluaykgIT0gMCkKICAgICAgICByZXR1cm47CgogICAgZHVtcFN0cnVj
dCgpOwogICAgcGNtYWNlX2NzX0luaXRLbm93bkNhcmRMaXN0KCk7CiAgICBkdW1wU3RydWN0KCk7
CiAgICBwY21hY2VfY3NfQ2xlYXJDYXJkSU9TdHJ1Y3QocGxpbmspOwogICAgZHVtcFN0cnVjdCgp
OwogICAgcGNtYWNlX2NzX1Byb2Nlc3NWZXJzaW9uMVR1cGxlKHBsaW5rKTsKICAgIGR1bXBTdHJ1
Y3QoKTsKICAgIHBjbWFjZV9jc19HZXRUdXBsZUluZm8ocGxpbmspOwogICAgZHVtcFN0cnVjdCgp
OwogICAgaWYgKHBjbWNpYV9nZXRfY29uZmlndXJhdGlvbl9pbmZvKHBsaW5rLCAmY29uZikgIT0g
Q1NfU1VDQ0VTUykKICAgIHsKICAgICAgICBwcmludGsoIiVzOiBGYWlsZWQgdG8gZ2V0IGNvbmZp
Z3VyYXRpb24gaW5mbywgZXhpdGluZyIsIE1PRFVMRV9OQU1FKTsKICAgICAgICBwY21hY2VfY3Nf
cmVsZWFzZShwbGluayk7CiAgICAgICAgcmV0dXJuOwogICAgfQogICAgZHVtcFN0cnVjdCgpOwog
ICAgLyoKICAgIGVsc2UKICAgICAgICBwbGluay0+Y29uZi5WY2MgPSBjb25mLlZjYzsKICAgICov
CgogICAgcGNtYWNlX2NzX2NvbmZpZ0lPKHBsaW5rKTsKICAgIGR1bXBTdHJ1Y3QoKTsKICAgIHBj
bWFjZV9jc19jb25maWdJUlEocGxpbmspOwogICAgZHVtcFN0cnVjdCgpOwogICAgaWYocGNtYWNl
X2NzX1JlcXVlc3RDb25maWd1cmF0aW9uKHBsaW5rKSAhPSAwKQogICAgICAgIHJldHVybjsKICAg
IGR1bXBTdHJ1Y3QoKTsKICAgIHBjbWFjZV9jc19jb25maWdXaW5kb3dzKHBsaW5rKTsKICAgIGR1
bXBTdHJ1Y3QoKTsKICAgIHBjbWFjZV9jc19TZXRDb25maWdPcHRpb25SZWdpc3RlcihwbGluayk7
CiAgICBkdW1wU3RydWN0KCk7CgogICAgLyogQXNzdW1lIGNhcmQgMCAoVGVzdGVkIGRyaXZlciBv
biBvbmUgc29ja2V0IG1hY2hpbmUpICovCiAgICAvL21fYk51bWJlck9mQ2FyZHMgPSAwOyAgICAg
Ly9qbWYgcmVtb3ZlIHRvIGFsbG93IG11bHRpcGxlIGNhcmRzCiAgICBwY21hY2VfY3NfU3RvcmVD
YXJkSW5mbyhwbGluayk7CiAgICBkdW1wU3RydWN0KCk7CiAgICAvKiBGaW5hbGx5LCByZXBvcnQg
d2hhdCB3ZSd2ZSBkb25lICovCiAgICBwY21hY2VfY3NfRGlzcGxheUNhcmRJbmZvKHBsaW5rKTsK
ICAgIGR1bXBTdHJ1Y3QoKTsKCiAgICAvLyBVc2VkIGJ5IGlvY3RsIHRvIGNoZWNrIGZvciBjb3Jy
ZWN0bHkgY29uZmlndXJlZCBjYXJkICh0d28gY2hhbm5lbHMpCiAgICBtX2JOdW1iZXJPZkNhcmRz
ICsrOwogICAgREVCVUcoMTAsICIlczogQ2FyZCBOYjogJWRcbiIsIE1PRFVMRV9OQU1FLCBtX2JO
dW1iZXJPZkNhcmRzKTsKCn0KCi8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAqIEZ1bmN0aW9uOiAgcGNtYWNlX2NzX0Zp
bmRMaW5rQ2FyZE51bWJlciAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAq
IERlc2NyaXB0aW9uOiAgRmluZHMgdGhlIG1fYUNhcmQgc3RydWN0dXJlIGZvciBhIGxpbmsgICAg
ICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIFBhcmFtZXRl
cnM6ICAgcGxpbmsgLSBQYXNzIGEgdmFsaWQgZGV2aWNlIHBvaW50ZXIuICAgICAgICAgICAgICAq
CiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAqCiAqIHJldHVybjogICAgICAgc3RhdHVzIC0gaW50ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAqCiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwovKnN0YXRpYyBpbnQgcGNtYWNl
X2NzX0ZpbmRMaW5rQ2FyZE51bWJlcihzdHJ1Y3QgcGNtY2lhX2RldmljZSAqcGxpbmssCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBfX3U4ICpwYk51bWJlck9mQ2FyZHMp
CnsKICAgIF9fdTggdThDYXJkTnVtYmVyOwoKICAgIGludCBuU3RhdHVzID0gLTE7CgogICAgZm9y
KHU4Q2FyZE51bWJlciA9IDA7IHU4Q2FyZE51bWJlciA8IEFDRTUzX01BWF9OVU1fQ0FSRFM7IHU4
Q2FyZE51bWJlcisrKQogICAgewogICAgICAgIGlmKG1fYUNhcmRzW3U4Q2FyZE51bWJlcl0ucGxp
bmsgPT0gcGxpbmspCiAgICAgICAgewogICAgICAgICAgICAqcGJOdW1iZXJPZkNhcmRzID0gdThD
YXJkTnVtYmVyOwogICAgICAgICAgICBuU3RhdHVzID0gMDsKICAgICAgICB9CiAgICB9CiAgICBy
ZXR1cm4gblN0YXR1czsKfSovCgovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiBGdW5jdGlvbjogIHBjbWFjZV9jc19y
ZWxlYXNlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgog
KiBEZXNjcmlwdGlvbjogICBSZWxlYXNlcyB0aGUgaW5zdGFuY2Ugb2YgdGhlIGRyaXZlciBhbmQg
YW55ICAgICAgKgogKiAgICAgICAgICAgICAgICByZXNvdXJjZXMgcmVxdWVzdGVkICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KgogKiBQYXJhbWV0ZXJzOiAgICBhcmcgLSBQYXNzIGEgdmFsaWQgZGV2aWNlIHBvaW50ZXIuICAg
ICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKgogKiByZXR1cm46ICAgICAgIG5vbmUgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3RhdGlj
IHZvaWQgcGNtYWNlX2NzX3JlbGVhc2Uoc3RydWN0IHBjbWNpYV9kZXZpY2UgKnBsaW5rKQp7CiAg
ICAvL19fdTggdThDYXJkTnVtYmVyOwogICAgLy9pbnQgbkluZGV4OwoKICAgIERFQlVHKDEwLCAi
JXM6IGVudGVyaW5nIHJlbGVhc2U6ICVzICVzXG4iLAogICAgICAgICAgTU9EVUxFX05BTUUsIGRl
dl9kcml2ZXJfc3RyaW5nKCZwbGluay0+ZGV2KSwgcGxpbmstPmRldi5idXNfaWQpOwoKICAgIC8q
CiAgICAgICBJZiB0aGUgZGV2aWNlIGlzIGN1cnJlbnRseSBpbiB1c2UsIHdlIHdvbid0IHJlbGVh
c2UgdW50aWwgaXQKICAgICAgIGlzIGFjdHVhbGx5IGNsb3NlZCwgYmVjYXVzZSB1bnRpbCB0aGVu
LCB3ZSBjYW4ndCBiZSBzdXJlIHRoYXQKICAgICAgIG5vIG9uZSB3aWxsIHRyeSB0byBhY2Nlc3Mg
dGhlIGRldmljZSBvciBpdHMgZGF0YSBzdHJ1Y3R1cmVzLgogICAgICAqLwogICAgaWYgKHBsaW5r
LT5vcGVuKQogICAgewogICAgICAgIERFQlVHKDEsICIlczogcmVsZWFzZSBwb3N0cG9uZWQ6ICVz
IHN0aWxsIG9wZW5cbiIsCiAgICAgICAgICAgICAgTU9EVUxFX05BTUUsIGRldl9kcml2ZXJfc3Ry
aW5nKCZwbGluay0+ZGV2KSk7CiAgICAgICAgcmV0dXJuOwogICAgfQogICAgLyogVW5saW5rIHRo
ZSBkZXZpY2UgY2hhaW4gKi8KICAgIC8vcGxpbmstPmRldiA9IE5VTEw7CgogICAgLy9maXhpbmcg
cmVsZWFzZSB1c2luZyB1OENhcmROdW1iZXIKCiAgICAvKiBEb24ndCBib3RoZXIgY2hlY2tpbmcg
dG8gc2VlIGlmIHRoZXNlIHN1Y2NlZWQgb3Igbm90ICovCiAgICAvKiBHTFM6IGFjY29yZGluZyB0
byBkb2MsIHBjbWNpYV9yZWxlYXNlX3dpbmRvdyBzZWVtcyBub3QgYW55bW9yZSBuZWNlc3NhcnkK
ICAgICAqICAgICAgdGhlIGpvYiBiZWluZyBkb25lIGJ5IHBjbWNpYV9kaXNhYmxlX2RldmljZSAq
LwogICAgLyoKICAgIGlmKHBjbWFjZV9jc19GaW5kTGlua0NhcmROdW1iZXIocGxpbmssICZ1OENh
cmROdW1iZXIpID09IDApCiAgICB7CiAgICAgICAgZm9yKG5JbmRleCA9IDA7IG5JbmRleCA8IEFD
RTUzX01BWF9OVU1fV0lORE9XUzsgbkluZGV4KyspCiAgICAgICAgewogICAgICAgICAgICBpZiht
X0NhcmRJT1t1OENhcmROdW1iZXJdLldpbkFycltuSW5kZXhdLmNBcnJXaW5kb3dSZXF1ZXN0ID09
IF9fUkVRVUVTVEVEX18pCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAgIHBjbWNpYV9yZWxl
YXNlX3dpbmRvdyhtX0NhcmRJT1t1OENhcmROdW1iZXJdLldpbkFycltuSW5kZXhdLndpbmhhbmRs
ZSk7CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICB9CiAgICBlbHNlCiAgICB7CiAgICAgICAg
cHJpbnRrKCIlczogcGNtYWNlX2NzX3JlbGVhc2UoKTogRmFpbHVyZTogQ291bGQgbm90IGZpbmQg
Y2FyZCBsaW5rXG4iLCBNT0RVTEVfTkFNRSk7CiAgICB9CiAgICAqLwoKICAgIHBjbWNpYV9kaXNh
YmxlX2RldmljZShwbGluayk7CiAgICBwY21hY2VfY3NfZGV0YWNoKHBsaW5rKTsKCiAgICBtX2JO
dW1iZXJPZkNhcmRzLS07Cn0KCi8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAqIEZ1bmN0aW9uOiAgUHJpbnRTZXJ2aW5m
byAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAq
IERlc2NyaXB0aW9uOiAgIERpc3BsYXlzIHRoZSBjYXJkIHNlcnZpY2VzIGluZm8gICAgICAgICAg
ICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIFBhcmFtZXRlcnM6ICAgIGRldiAt
IFN0cnVjdHVyZSBjb250YWluaW5nIGNhcmQgc2VydmljZXMgaW5mbyAgICAqCiAqICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAq
CiAqIHJldHVybjogICAgICAgIHZvaWQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAqCiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqLwpzdGF0aWMgdm9pZCBQcmludFNlcnZpbmZvKHN0cnVj
dCBwY21jaWFfZGV2aWNlICpkZXYpCnsKICAgIERFQlVHKDk5LCAiJXMgaW5mbzogTWFudWZhY3R1
cmVyIElkOiAweCUwNFhcbiIsIE1PRFVMRV9OQU1FLCBkZXYtPm1hbmZfaWQpOwogICAgREVCVUco
OTksICIlcyBpbmZvOiBDYXJkIElkOiAgICAgICAgIDB4JTA0WFxuIiwgTU9EVUxFX05BTUUsIGRl
di0+Y2FyZF9pZCk7CiAgICBERUJVRyg5OSwgIiVzIGluZm86IEZ1bmN0aW9uIElkOiAgICAgMHgl
MDJYXG4iLCBNT0RVTEVfTkFNRSwgZGV2LT5mdW5jX2lkKTsKICAgIERFQlVHKDk5LCAiJXMgaW5m
bzogVmVuZG9yIFN0cmluZzogICAlc1xuIiwgTU9EVUxFX05BTUUsIGRldi0+cHJvZF9pZFswXSk7
CiAgICBERUJVRyg5OSwgIiVzIGluZm86IENhcmQgTW9kZWw6ICAgICAgJXNcbiIsIE1PRFVMRV9O
QU1FLCBkZXYtPnByb2RfaWRbMV0pOwogICAgREVCVUcoOTksICIlcyBpbmZvOiBDYXJkIFR5cGU6
ICAgICAgICVzXG4iLCBNT0RVTEVfTkFNRSwgZGV2LT5wcm9kX2lkWzJdKTsKICAgIERFQlVHKDk5
LCAiJXMgaW5mbzogUmV2aXNpb246ICAgICAgICAlc1xuIiwgTU9EVUxFX05BTUUsIGRldi0+cHJv
ZF9pZFszXSk7Cn0KCi8qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqCiAqIEZ1bmN0aW9uOiAgICAgIGR1bXBTdHJ1Y3QgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIERlc2Ny
aXB0aW9uOiAgIERpc3BsYXlzIHRoZSBzdGF0aWMgc3RydWN0dXJlcyAgICAgICAgICAgICAgICAg
ICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIFBhcmFtZXRlcnM6ICAgIHZvaWQgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqCiAqIHJl
dHVybjogICAgICAgIHZvaWQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAqCiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqLwpzdGF0aWMgdm9pZCBkdW1wU3RydWN0KHZvaWQpCnsKICAgIGlu
dCBpLCBqOwogICAgQUNFNTNfQ0FSRCAqcHRyOwogICAgQ2FyZF9JT190ICpwdDsKICAgIHJldHVy
bjsKCiAgICBmb3IgKGkgPSAwOyBpIDwgMTsgaSsrKQogICAgewogICAgICAgIHB0ciA9ICYobV9h
Q2FyZHNbaV0pOwogICAgICAgIERFQlVHKDk5LCAiJXM6IG1fYUNhcmRzWyVkXTpcbiIsIE1PRFVM
RV9OQU1FLCBpKTsKICAgICAgICBERUJVRyg5OSwgIiAgcGxpbms6ICAgICAgICAgICAgICAweCUw
MTZsbHhcbiIsIChfX3U2NClwdHItPnBsaW5rKTsKICAgICAgICBERUJVRyg5OSwgIiAgYlBjaUJ1
c051bTogICAgICAgICAlZFxuIiwgcHRyLT5iUGNpQnVzTnVtKTsKICAgICAgICBERUJVRyg5OSwg
IiAgYlBjaURldk51bTogICAgICAgICAlZFxuIiwgcHRyLT5iUGNpRGV2TnVtKTsKICAgICAgICBE
RUJVRyg5OSwgIiAgYlBjaUZjbk51bTogICAgICAgICAlZFxuIiwgcHRyLT5iUGNpRmNuTnVtKTsK
ICAgICAgICBERUJVRyg5OSwgIiAgYk1ham9yOiAgICAgICAgICAgICAlZFxuIiwgcHRyLT5iTWFq
b3IpOwogICAgICAgIERFQlVHKDk5LCAiICBiTWlub3I6ICAgICAgICAgICAgICVkXG4iLCBwdHIt
PmJNaW5vcik7CiAgICAgICAgREVCVUcoOTksICIgIHdEZXZpY2VJRDogICAgICAgICAgJWRcbiIs
IHB0ci0+d0RldmljZUlEKTsKICAgICAgICBERUJVRyg5OSwgIiAgZHdDYXJkSUQ6ICAgICAgICAg
ICAlZFxuIiwgcHRyLT5kd0NhcmRJRCk7CiAgICAgICAgREVCVUcoOTksICIgIGR3Q2hhbk1lbUxl
bjogICAgICAgJWRcbiIsIHB0ci0+ZHdDaGFuTWVtTGVuKTsKICAgICAgICBERUJVRyg5OSwgIiAg
d0lycTogICAgICAgICAgICAgICAweCUwNHhcbiIsIHB0ci0+d0lycSk7CiAgICAgICAgREVCVUco
OTksICIgIGJOdW1DaG5sczogICAgICAgICAgJWRcbiIsIHB0ci0+Yk51bUNobmxzKTsKICAgICAg
ICBERUJVRyg5OSwgIiAgZHdNZW1XbmRQY21jaWFBZGRyOiAweCUwOHhcbiIsIHB0ci0+ZHdNZW1X
bmRQY21jaWFBZGRyKTsKICAgICAgICBERUJVRyg5OSwgIiAgZHdSZWdXbmRQY21jaWFBZGRyOiAw
eCUwOHhcbiIsIHB0ci0+ZHdSZWdXbmRQY21jaWFBZGRyKTsKICAgICAgICBERUJVRyg5OSwgIiAg
ZHdSZWdXbmRLcm5BZGRyOiAgICAweCUwMTZsbHhcbiIsIHB0ci0+ZHdSZWdXbmRLcm5BZGRyKTsK
ICAgICAgICBERUJVRyg5OSwgIiAgZHdNZW1XbmRLcm5BZGRyOiAgICAweCUwMTZsbHhcbiIsIHB0
ci0+ZHdNZW1XbmRLcm5BZGRyKTsKICAgICAgICBERUJVRyg5OSwgIiAgQ2hhbm5lbC5iQ2FyZE51
bTogICAlZFxuIiwgcHRyLT5DaGFubmVsLmJDYXJkTnVtKTsKICAgICAgICBERUJVRyg5OSwgIiAg
Q2hhbm5lbC5iQ2hhbk51bTogICAlZFxuIiwgcHRyLT5DaGFubmVsLmJDaGFuTnVtKTsKICAgICAg
ICBERUJVRyg5OSwgIiAgQ2hhbm5lbC5iU29ja2V0TnVtOiAlZFxuIiwgcHRyLT5DaGFubmVsLmJT
b2NrZXROdW0pOwogICAgICAgIERFQlVHKDk5LCAiICBDaGFubmVsLmR3TWVtV25kVXNyQWRkcjow
eCUwOHhcbiIsIHB0ci0+Q2hhbm5lbC5kd01lbVduZFVzckFkZHIpOwogICAgICAgIERFQlVHKDk5
LCAiICBDaGFubmVsLmR3UmVnV25kVXNyQWRkcjoweCUwOHhcbiIsIHB0ci0+Q2hhbm5lbC5kd1Jl
Z1duZFVzckFkZHIpOwogICAgICAgIERFQlVHKDk5LCAiICBDaGFubmVsLmR3SW50U3RhdHVzOjB4
JTA4eFxuIiwgcHRyLT5DaGFubmVsLmR3SW50U3RhdHVzKTsKICAgICAgICBERUJVRyg5OSwgIiAg
Q2hhbm5lbC5iQmxvY2tlZDogICAlZFxuIiwgcHRyLT5DaGFubmVsLmJCbG9ja2VkKTsKICAgICAg
ICBERUJVRyg5OSwgIiAgQ2hhbm5lbC5iTW1hcFdpbk51bTolZFxuIiwgcHRyLT5DaGFubmVsLmJN
bWFwV2luTnVtKTsKICAgICAgICBERUJVRyg5OSwgIiAgQ2hhbm5lbC5iSXNyRW5hYmxlZDolZFxu
IiwgcHRyLT5DaGFubmVsLmJJc3JFbmFibGVkKTsKICAgICAgICBERUJVRyg5OSwgIiAgQ2hhbm5l
bC53SXJxOiAgICAgICAlZFxuIiwgcHRyLT5DaGFubmVsLndJcnEpOwogICAgICAgIERFQlVHKDk5
LCAiICBDaGFubmVsLmJPcGVuOiAgICAgICVkXG4iLCBwdHItPkNoYW5uZWwuYk9wZW4pOwogICAg
ICAgIERFQlVHKDk5LCAiICBDaGFubmVsLmJBdXRvRmxpcFN0azolZFxuIiwgcHRyLT5DaGFubmVs
LmJBdXRvRmxpcFN0ayk7CiAgICAgICAgREVCVUcoOTksICIgIENJUy51bk1lbW9yeVNpemU6ICAg
JWRcbiIsIHB0ci0+Q0lTLnVuTWVtb3J5U2l6ZSk7CiAgICAgICAgREVCVUcoOTksICIgIENJUy51
bkFjY2Vzc1NwZWVkOiAgJWRcbiIsIHB0ci0+Q0lTLnVuQWNjZXNzU3BlZWQpOwogICAgICAgIERF
QlVHKDk5LCAiICBDSVMudW5Db25maWdCYXNlOiAgICVkXG4iLCBwdHItPkNJUy51bkNvbmZpZ0Jh
c2UpOwogICAgICAgIERFQlVHKDk5LCAiICBDSVMudW5QcmVzZW50OiAgICAgICVkXG4iLCBwdHIt
PkNJUy51blByZXNlbnQpOwogICAgICAgIERFQlVHKDk5LCAiICBDSVMudWNDb25maWdJbmRleDog
ICVkXG4iLCBwdHItPkNJUy51Y0NvbmZpZ0luZGV4KTsKICAgIH0KCiAgICBmb3IgKGkgPSAwOyBp
IDwgMTsgaSsrKQogICAgewogICAgICAgIHB0ID0gJihtX0NhcmRJT1tpXSk7CiAgICAgICAgREVC
VUcoOTksICIlczogbV9DYXJkSU9bJWRdOlxuIiwgTU9EVUxFX05BTUUsIGkpOwogICAgICAgIERF
QlVHKDk5LCAiICBjSU9SZXF1ZXN0OiAgICAgICAgICVkXG4iLCBwdC0+Y0lPUmVxdWVzdCk7CiAg
ICAgICAgREVCVUcoOTksICIgIGNJUlFSZXF1ZXN0OiAgICAgICAgJWRcbiIsIHB0LT5jSVJRUmVx
dWVzdCk7CiAgICAgICAgREVCVUcoOTksICIgIG5OdW1XaW5kb3dzOiAgICAgICAgJWRcbiIsIHB0
LT5uTnVtV2luZG93cyk7CiAgICAgICAgZm9yIChqID0gMDsgaiA8IDI7IGorKykKICAgICAgICB7
CiAgICAgICAgICAgIERFQlVHKDk5LCAiICBXaW5BcnJbJWRdOlxuIiwgaik7CiAgICAgICAgICAg
IERFQlVHKDk5LCAiICAgIGNBcnJXaW5kb3dSZXF1ZXN0OiVkXG4iLCBwdC0+V2luQXJyW2pdLmNB
cnJXaW5kb3dSZXF1ZXN0KTsKICAgICAgICAgICAgREVCVUcoOTksICIgICAgcG5EaXJlY3RQaHlz
aWNhbEFkZHI6MHglMDE2bGx4XG4iLCAoX191NjQpcHQtPldpbkFycltqXS5wbkRpcmVjdFBoeXNp
Y2FsQWRkcik7CiAgICAgICAgICAgIERFQlVHKDk5LCAiICAgIGNBcnJXaW5kb3dSZXF1ZXN0OiVk
XG4iLCBwdC0+V2luQXJyW2pdLmNBcnJXaW5kb3dSZXF1ZXN0KTsKICAgICAgICAgICAgREVCVUco
OTksICIgICAgcG5EaXJlY3RLZXJuZWxBZGRyOjB4JTAxNmxseFxuIiwgKF9fdTY0KXB0LT5XaW5B
cnJbal0ucG5EaXJlY3RLZXJuZWxBZGRyKTsKICAgICAgICAgICAgREVCVUcoOTksICIgICAgcmVx
LkJhc2U6ICAgICAgICAgMHglMDhseFxuIiwgcHQtPldpbkFycltqXS5yZXEuQmFzZSk7CiAgICAg
ICAgICAgIERFQlVHKDk5LCAiICAgIHJlcS5TaXplOiAgICAgICAgICVkXG4iLCBwdC0+V2luQXJy
W2pdLnJlcS5TaXplKTsKICAgICAgICAgICAgREVCVUcoOTksICIgICAgcmVxLkFjY2Vzc1NwZWVk
OiAgJWRcbiIsIHB0LT5XaW5BcnJbal0ucmVxLkFjY2Vzc1NwZWVkKTsKICAgICAgICAgICAgREVC
VUcoOTksICIgICAgcmVxLkF0dHJpYnV0ZXM6ICAgJWRcbiIsIHB0LT5XaW5BcnJbal0ucmVxLkF0
dHJpYnV0ZXMpOwogICAgICAgICAgICBERUJVRyg5OSwgIiAgICBtYXAuQ2FyZE9mZnNldDogICAl
ZFxuIiwgcHQtPldpbkFycltqXS5tYXAuQ2FyZE9mZnNldCk7CiAgICAgICAgICAgIERFQlVHKDk5
LCAiICAgIG1hcC5QYWdlOiAgICAgICAgICVkXG4iLCBwdC0+V2luQXJyW2pdLm1hcC5QYWdlKTsK
ICAgICAgICB9CiAgICB9Cn0KCg0KDQpzdGF0aWMgc3RydWN0IHBjbWNpYV9kZXZpY2VfaWQgcGNt
YWNlX2lkc1tdID0gew0KICAgIFBDTUNJQV9ERVZJQ0VfTUFORl9DQVJEKDB4MDE0QywgMHgwMTAx
KSwNCiAgICBQQ01DSUFfREVWSUNFX1BST0RfSUQxKCJJTEMgREFUQSBERVZJQ0UgQ09SUE9SQVRJ
T04iLCAweDFlYTI5ZDY4KSwNCiAgICBQQ01DSUFfREVWSUNFX1BST0RfSUQyKCJCVS02NTU1ME0y
LTYwNSIsIDB4ZWU2ZDM2OTgpLA0KICAgIFBDTUNJQV9ERVZJQ0VfTlVMTCwNCn07DQpNT0RVTEVf
REVWSUNFX1RBQkxFKHBjbWNpYSwgcGNtYWNlX2lkcyk7DQoKc3RhdGljIHN0cnVjdCBwY21jaWFf
ZHJpdmVyIHBjbWFjZV9kcml2ZXIgPSB7DQogICAgLnByb2JlICAgID0gcGNtYWNlX2NzX2F0dGFj
aCwNCiAgICAucmVtb3ZlICAgPSBwY21hY2VfY3NfZGV0YWNoLA0KICAgIC5zdXNwZW5kICA9IHBj
bWFjZV9jc19zdXNwZW5kLA0KICAgIC5yZXN1bWUgICA9IHBjbWFjZV9jc19yZXN1bWUsDQogICAg
Lm93bmVyICAgID0gVEhJU19NT0RVTEUsDQogICAgLmlkX3RhYmxlID0gcGNtYWNlX2lkcywNCiAg
ICAuZHJ2ICAgICAgPSB7CiAgICAgICAgICAgICAgICAgLm5hbWUgPSBNT0RVTEVfTkFNRSwKICAg
ICAgICAgICAgICAgIH0sDQp9OwoKLyoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKICogRnVuY3Rpb246ICBpbml0X3BjbWFj
ZV9jcyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICoKICogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICoK
ICogRGVzY3JpcHRpb246ICAgIFJlZ2lzdGVycyB0aGUgY2FyZCBzZXJ2aWNlcyBhbmQgY2hhciBk
cml2ZXIgICAgICoKICogICAgICAgICAgICAgICAgIGZ1bmN0aW9uYWxpdHkgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICoKICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICoKICogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICoKICogUGFyYW1l
dGVyczogICAgdm9pZCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICoKICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICoKICogcmV0dXJuOiAgICAgICAgdm9pZCAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICoKICoqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKiovCnN0YXRpYyBpbnQgX19pbml0
IGluaXRfcGNtYWNlKHZvaWQpCnsKICAgIC8vIEluaXQgQ2FyZCBTZXJ2aWNlcwogICAgaW50IG5T
dGF0dXM7CgogICAgLy8gSW5pdCBDaGFyIGRyaXZlcgogICAgaW50IHJlc3VsdCA9IDA7CgogICAg
REVCVUcoMTAsICIlczogbG9hZGluZyB2ZXJzaW9uICVzXG4iLCBNT0RVTEVfTkFNRSwgQUNFNTNf
VkVSU0lPTl9TVFJJTkcpOwogICAgZHVtcFN0cnVjdCgpOwoKICAgIC8vIEluaXQgQ2hhciBkcml2
ZXIgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0K
ICAgIC8qIENoZWNrIGtlcm5lbCB0byB1c2VyIGRhdGF0eXBlIGNvbXBhdGliaWxpdHkgKi8KICAg
IGlmKHNpemVvZihjaGFyKSAgICAgICE9IHNpemVvZihfX3M4KSAgfHwKICAgICAgIHNpemVvZihz
aG9ydCBpbnQpICE9IHNpemVvZihfX3MxNikgfHwKICAgICAgIHNpemVvZihpbnQpICAgICAgICE9
IHNpemVvZihfX3MzMikKICAgICAgKQogICAgewogICAgICAgIHByaW50aygiJXM6IEtlcm5lbCB0
byB1c2VyIGRhdGF0eXBlIG1pc21hdGNoLCAiLCBNT0RVTEVfTkFNRSk7CiAgICAgICAgcHJpbnRr
KCJkcml2ZXIgbm90IGNvbXBhdGlibGUgd2l0aCBPUyFcbiAiKTsKICAgICAgICByZXR1cm4gLTE7
CiAgICB9CgogICAgLyogUmVnaXN0ZXIgdGhlIGRyaXZlciBhbmQgZ2V0IE1BSk9SIG51bWJlciBm
cm9tIGtlcm5lbCAqLwogICAgLyogJzAnIG1lYW5zIGtlcm5lbCBhc3NpZ25zIE1BSk9SIG51bWJl
ciAqLwogICAgcmVzdWx0ID0gcmVnaXN0ZXJfY2hyZGV2KDAsIE1PRFVMRV9OQU1FLCAmbV9mb0Zp
bGVPcHMpOwoKICAgIC8qIENoZWNrIGlmIHdlIHJlY2VpdmVkIGEgTUFKT1IgbnVtYmVyIGZyb20g
dGhlIGtlcm5lbCAqLwogICAgaWYocmVzdWx0IDwgMCkKICAgIHsKICAgICAgICBwcmludGsoIiVz
OiByZWdpc3Rlcl9jaHJkZXYgZmFpbGVkIVxuIiwgTU9EVUxFX05BTUUpOwogICAgICAgIHJldHVy
biByZXN1bHQ7CiAgICB9CgogICAgREVCVUcoNjAsICIlczogbWFqb3IgJWRcbiIsIE1PRFVMRV9O
QU1FLCByZXN1bHQpOwogICAgZHVtcFN0cnVjdCgpOwoKICAgIC8qIElmIE1BSk9SIG51bWJlciBp
cyB1bnNldCwgc2F2ZSBmb3IgbGF0ZXIgdXNlICovCiAgICBpZiAobV9kd01ham9yTnVtYmVyID09
IDApCiAgICAgICAgbV9kd01ham9yTnVtYmVyID0gcmVzdWx0OwoKICAgIC8vIEluaXQgQ2FyZCBT
ZXJ2aWNlcyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAg
ICBpZigoblN0YXR1cyA9IHBjbWNpYV9yZWdpc3Rlcl9kcml2ZXIoJnBjbWFjZV9kcml2ZXIpKSAh
PSAwKQogICAgewogICAgICAgIHByaW50aygiJXM6IEZhaWxlZCB0byByZWdpc3RlciBQQyBDYXJk
IHdpdGggQ2FyZCBTZXJ2aWNlczsgcmV0dXJuOiAlZFxuIiwKICAgICAgICAgICAgICAgTU9EVUxF
X05BTUUsIG5TdGF0dXMpOwogICAgICAgIHJldHVybiBuU3RhdHVzOwogICAgfQoKICAgIGR1bXBT
dHJ1Y3QoKTsKICAgIHJldHVybiAwOwp9CgovKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiBGdW5jdGlvbjogIF9fZXhp
dCBleGl0X3BjbWFjZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKgogKiBEZXNjcmlwdGlvbjogICAgdW5yZWdpc3RlcnMgdGhlIGNhcmQgc2VydmljZXMgYW5k
IGNoYXIgZHJpdmVyICAgKgogKiAgICAgICAgICAgICAgICAgZnVuY3Rpb25hbGl0eSAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKiBQ
YXJhbWV0ZXJzOiAgICB2b2lkICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKgogKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgKgogKiByZXR1cm46ICAgICAgICB2b2lkICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKgogKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8Kc3RhdGljIHZvaWQg
X19leGl0IGV4aXRfcGNtYWNlKHZvaWQpCnsKCiAgICBERUJVRygxMCwgIiVzOiB1bmxvYWRpbmcg
dmVyc2lvbiAlc1xuIiwgTU9EVUxFX05BTUUsIEFDRTUzX1ZFUlNJT05fU1RSSU5HKTsKCiAgICAv
LyBDYXJkIFNlcnZpY2VzIGV4aXQgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0KICAgIHBjbWNpYV91bnJlZ2lzdGVyX2RyaXZlcigmcGNtYWNlX2RyaXZlcik7CgogICAg
Ly8gQ2hhciBkcml2ZXIgZXhpdC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tCiAgICB1bnJlZ2lzdGVyX2NocmRldihtX2R3TWFqb3JOdW1iZXIsIE1PRFVMRV9OQU1F
KTsKfQoKbW9kdWxlX2luaXQoaW5pdF9wY21hY2UpOwptb2R1bGVfZXhpdChleGl0X3BjbWFjZSk7
Ck1PRFVMRV9MSUNFTlNFKCJEdWFsIEJTRC9HUEwiKTsNCgovKi0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLUVORCBPRiBDQVJEIFNFUlZJQ0VTIEZVTkNUSU9OUy0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0qLwoKCgo=

------_=_NextPart_001_01CBCC65.39F68399--
