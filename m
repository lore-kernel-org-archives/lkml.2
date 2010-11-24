Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0KXWDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 17:03:09 -0500
Received: from build.ihdev.net ([178.63.197.118]:59095 "EHLO build.ossfans.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab0KXWDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 17:03:06 -0500
Date: Wed, 24 Nov 2010 17:03:02 -0500
From: Sergey Lapin <slapin@ossfans.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ldisc problems with 2.6.32-2.6.37-rc2 (at least)
Message-ID: <20101124220302.GB8691@build.ihdev.net>
References: <20101124135249.GA7282@build.ihdev.net>
 <4CED2251.3020708@suse.cz>
 <20101124170326.GB7282@build.ihdev.net>
 <4CED6ACF.9000402@suse.cz>
 <4CED6B53.50408@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CED6B53.50408@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 08:45:23PM +0100, Jiri Slaby wrote:
> On 11/24/2010 08:43 PM, Jiri Slaby wrote:
> > Could you provide disassembly of tty_set_ldisc? E.g. by extracting it from:
> > objdump -d drivers/tty/tty_ldisc.o
> 
> Or maybe better after linking:
> objdump -d vmlinux
> 
> thanks,
> -- 
> js
> suse labs
Disassembly of tty_set_ldisc

c01bbde8 <tty_set_ldisc>:
c01bbde8:       e92d4ff0        push    {r4, r5, r6, r7, r8, r9, sl, fp, lr}
c01bbdec:       e1a04000        mov     r4, r0
c01bbdf0:       e1a00001        mov     r0, r1
c01bbdf4:       e1a0b001        mov     fp, r1
c01bbdf8:       e24dd054        sub     sp, sp, #84     ; 0x54
c01bbdfc:       ebfffe31        bl      c01bb6c8 <tty_ldisc_get>
c01bbe00:       e3700a01        cmn     r0, #4096       ; 0x1000
c01bbe04:       e1a06000        mov     r6, r0
c01bbe08:       81a05000        movhi   r5, r0
c01bbe0c:       8a000100        bhi     c01bc214 <tty_set_ldisc+0x42c>
c01bbe10:       eb06eb04        bl      c0376a28 <tty_lock>
c01bbe14:       e5943024        ldr     r3, [r4, #36]   ; 0x24
c01bbe18:       e59480a0        ldr     r8, [r4, #160]  ; 0xa0
c01bbe1c:       e5933000        ldr     r3, [r3]
c01bbe20:       e5933008        ldr     r3, [r3, #8]
c01bbe24:       e153000b        cmp     r3, fp
c01bbe28:       1a000004        bne     c01bbe40 <tty_set_ldisc+0x58>
c01bbe2c:       eb06eae8        bl      c03769d4 <tty_unlock>
c01bbe30:       e1a00006        mov     r0, r6
c01bbe34:       ebfffeac        bl      c01bb8ec <put_ldisc>
c01bbe38:       e3a05000        mov     r5, #0
c01bbe3c:       ea0000f4        b       c01bc214 <tty_set_ldisc+0x42c>
c01bbe40:       eb06eae3        bl      c03769d4 <tty_unlock>
c01bbe44:       e2847018        add     r7, r4, #24
c01bbe48:       e1a00004        mov     r0, r4
c01bbe4c:       e3a01000        mov     r1, #0
c01bbe50:       ebfffa07        bl      c01ba674 <tty_wait_until_sent>
c01bbe54:       eb06eaf3        bl      c0376a28 <tty_lock>
c01bbe58:       e1a00007        mov     r0, r7
c01bbe5c:       e284a088        add     sl, r4, #136    ; 0x88
c01bbe60:       eb06e62e        bl      c0375720 <mutex_lock>
c01bbe64:       e1a0300d        mov     r3, sp
c01bbe68:       e3c35d7f        bic     r5, r3, #8128   ; 0x1fc0
c01bbe6c:       e3c5503f        bic     r5, r5, #63     ; 0x3f
c01bbe70:       ea000023        b       c01bbf04 <tty_set_ldisc+0x11c>
c01bbe74:       e1a00007        mov     r0, r7
c01bbe78:       eb06e5d5        bl      c03755d4 <mutex_unlock>
c01bbe7c:       eb06ead4        bl      c03769d4 <tty_unlock>
c01bbe80:       e59a3000        ldr     r3, [sl]
c01bbe84:       e3130b01        tst     r3, #1024       ; 0x400
c01bbe88:       0a00001a        beq     c01bbef8 <tty_set_ldisc+0x110>
c01bbe8c:       e595300c        ldr     r3, [r5, #12]
c01bbe90:       e28d9010        add     r9, sp, #16
c01bbe94:       e1a00009        mov     r0, r9
c01bbe98:       e3a01000        mov     r1, #0
c01bbe9c:       e3a02014        mov     r2, #20
c01bbea0:       e289900c        add     r9, r9, #12
c01bbea4:       e58d3004        str     r3, [sp, #4]
c01bbea8:       ebff5fb4        bl      c0193d80 <memset>
c01bbeac:       e59d3004        ldr     r3, [sp, #4]
c01bbeb0:       e58d901c        str     r9, [sp, #28]
c01bbeb4:       e58d9020        str     r9, [sp, #32]
c01bbeb8:       e58d3014        str     r3, [sp, #20]
c01bbebc:       e59f335c        ldr     r3, [pc, #860]  ; c01bc220 <tty_set_ldisc+0x438>
c01bbec0:       e58d3018        str     r3, [sp, #24]
c01bbec4:       e28d9010        add     r9, sp, #16
c01bbec8:       e3a02002        mov     r2, #2
c01bbecc:       e59f0350        ldr     r0, [pc, #848]  ; c01bc224 <tty_set_ldisc+0x43c>
c01bbed0:       e1a01009        mov     r1, r9
c01bbed4:       ebfa50f5        bl      c00502b0 <prepare_to_wait>
c01bbed8:       e59a3000        ldr     r3, [sl]
c01bbedc:       e3130b01        tst     r3, #1024       ; 0x400
c01bbee0:       0a000001        beq     c01bbeec <tty_set_ldisc+0x104>
c01bbee4:       eb06e1e4        bl      c037467c <schedule>
c01bbee8:       eafffff5        b       c01bbec4 <tty_set_ldisc+0xdc>
c01bbeec:       e59f0330        ldr     r0, [pc, #816]  ; c01bc224 <tty_set_ldisc+0x43c>
c01bbef0:       e1a01009        mov     r1, r9
c01bbef4:       ebfa509e        bl      c0050174 <finish_wait>
c01bbef8:       eb06eaca        bl      c0376a28 <tty_lock>
c01bbefc:       e1a00007        mov     r0, r7
c01bbf00:       eb06e606        bl      c0375720 <mutex_lock>
c01bbf04:       e59a3000        ldr     r3, [sl]
c01bbf08:       e2133b01        ands    r3, r3, #1024   ; 0x400
c01bbf0c:       1affffd8        bne     c01bbe74 <tty_set_ldisc+0x8c>
c01bbf10:       e10f2000        mrs     r2, CPSR
c01bbf14:       e3821080        orr     r1, r2, #128    ; 0x80
c01bbf18:       e121f001        msr     CPSR_c, r1
c01bbf1c:       e5941088        ldr     r1, [r4, #136]  ; 0x88
c01bbf20:       e3811b01        orr     r1, r1, #1024   ; 0x400
c01bbf24:       e5841088        str     r1, [r4, #136]  ; 0x88
c01bbf28:       e121f002        msr     CPSR_c, r2
c01bbf2c:       e584309c        str     r3, [r4, #156]  ; 0x9c
c01bbf30:       e594a024        ldr     sl, [r4, #36]   ; 0x24
c01bbf34:       eb06eaa6        bl      c03769d4 <tty_unlock>
c01bbf38:       e1a00004        mov     r0, r4
c01bbf3c:       ebfffe1f        bl      c01bb7c0 <tty_ldisc_halt>
c01bbf40:       e3580000        cmp     r8, #0
c01bbf44:       058d8008        streq   r8, [sp, #8]
c01bbf48:       e58d000c        str     r0, [sp, #12]
c01bbf4c:       0a000002        beq     c01bbf5c <tty_set_ldisc+0x174>
c01bbf50:       e1a00008        mov     r0, r8
c01bbf54:       ebfffe19        bl      c01bb7c0 <tty_ldisc_halt>
c01bbf58:       e58d0008        str     r0, [sp, #8]
c01bbf5c:       e1a00007        mov     r0, r7
c01bbf60:       eb06e59b        bl      c03755d4 <mutex_unlock>
c01bbf64:       ebfa402c        bl      c004c01c <flush_scheduled_work>
c01bbf68:       e5943024        ldr     r3, [r4, #36]   ; 0x24
c01bbf6c:       e5933004        ldr     r3, [r3, #4]
c01bbf70:       e3530001        cmp     r3, #1
c01bbf74:       0a00002a        beq     c01bc024 <tty_set_ldisc+0x23c>
c01bbf78:       e1a0300d        mov     r3, sp
c01bbf7c:       e28d5010        add     r5, sp, #16
c01bbf80:       e3c39d7f        bic     r9, r3, #8128   ; 0x1fc0
c01bbf84:       e1a00005        mov     r0, r5
c01bbf88:       e3c9903f        bic     r9, r9, #63     ; 0x3f
c01bbf8c:       e3a01000        mov     r1, #0
c01bbf90:       e599300c        ldr     r3, [r9, #12]
c01bbf94:       e3a02014        mov     r2, #20
c01bbf98:       e285500c        add     r5, r5, #12
c01bbf9c:       e58d3004        str     r3, [sp, #4]
c01bbfa0:       ebff5f76        bl      c0193d80 <memset>
c01bbfa4:       e59d3004        ldr     r3, [sp, #4]
c01bbfa8:       e58d501c        str     r5, [sp, #28]
c01bbfac:       e58d5020        str     r5, [sp, #32]
c01bbfb0:       e3a05f7d        mov     r5, #500        ; 0x1f4
c01bbfb4:       e58d3014        str     r3, [sp, #20]
c01bbfb8:       e59f3260        ldr     r3, [pc, #608]  ; c01bc220 <tty_set_ldisc+0x438>
c01bbfbc:       e58d3018        str     r3, [sp, #24]
c01bbfc0:       e59f0260        ldr     r0, [pc, #608]  ; c01bc228 <tty_set_ldisc+0x440>
c01bbfc4:       e28d1010        add     r1, sp, #16
c01bbfc8:       e3a02001        mov     r2, #1
c01bbfcc:       ebfa50b7        bl      c00502b0 <prepare_to_wait>
c01bbfd0:       e5943024        ldr     r3, [r4, #36]   ; 0x24
c01bbfd4:       e5933004        ldr     r3, [r3, #4]
c01bbfd8:       e3530001        cmp     r3, #1
c01bbfdc:       0a000009        beq     c01bc008 <tty_set_ldisc+0x220>
c01bbfe0:       e599300c        ldr     r3, [r9, #12]
c01bbfe4:       e5933004        ldr     r3, [r3, #4]
c01bbfe8:       e5933000        ldr     r3, [r3]
c01bbfec:       e3130001        tst     r3, #1
c01bbff0:       159f5234        ldrne   r5, [pc, #564]  ; c01bc22c <tty_set_ldisc+0x444>
c01bbff4:       1a000003        bne     c01bc008 <tty_set_ldisc+0x220>
c01bbff8:       e1a00005        mov     r0, r5
c01bbffc:       eb06e42f        bl      c03750c0 <schedule_timeout>
c01bc000:       e2505000        subs    r5, r0, #0
c01bc004:       1affffed        bne     c01bbfc0 <tty_set_ldisc+0x1d8>
c01bc008:       e59f0218        ldr     r0, [pc, #536]  ; c01bc228 <tty_set_ldisc+0x440>
c01bc00c:       e28d1010        add     r1, sp, #16
c01bc010:       ebfa5057        bl      c0050174 <finish_wait>
c01bc014:       e3550000        cmp     r5, #0
c01bc018:       ba000002        blt     c01bc028 <tty_set_ldisc+0x240>
c01bc01c:       03e0500f        mvneq   r5, #15
c01bc020:       0a000000        beq     c01bc028 <tty_set_ldisc+0x240>
c01bc024:       e3a05000        mov     r5, #0
c01bc028:       eb06ea7e        bl      c0376a28 <tty_lock>
c01bc02c:       e1a00007        mov     r0, r7
c01bc030:       eb06e5ba        bl      c0375720 <mutex_lock>
c01bc034:       e3550000        cmp     r5, #0
c01bc038:       11a00006        movne   r0, r6
c01bc03c:       1a00005e        bne     c01bc1bc <tty_set_ldisc+0x3d4>
c01bc040:       e5943088        ldr     r3, [r4, #136]  ; 0x88
c01bc044:       e3130701        tst     r3, #262144     ; 0x40000
c01bc048:       0a00000d        beq     c01bc084 <tty_set_ldisc+0x29c>
c01bc04c:       e10f3000        mrs     r3, CPSR
c01bc050:       e3832080        orr     r2, r3, #128    ; 0x80
c01bc054:       e121f002        msr     CPSR_c, r2
c01bc058:       e5942088        ldr     r2, [r4, #136]  ; 0x88
c01bc05c:       e3c22b01        bic     r2, r2, #1024   ; 0x400
c01bc060:       e5842088        str     r2, [r4, #136]  ; 0x88
c01bc064:       e121f003        msr     CPSR_c, r3
c01bc068:       e1a00007        mov     r0, r7
c01bc06c:       eb06e558        bl      c03755d4 <mutex_unlock>
c01bc070:       e1a00006        mov     r0, r6
c01bc074:       ebfffe1c        bl      c01bb8ec <put_ldisc>
c01bc078:       e3e05004        mvn     r5, #4
c01bc07c:       eb06ea54        bl      c03769d4 <tty_unlock>
c01bc080:       ea000063        b       c01bc214 <tty_set_ldisc+0x42c>
c01bc084:       e1a00004        mov     r0, r4
c01bc088:       e1a0100a        mov     r1, sl
c01bc08c:       ebfffdd6        bl      c01bb7ec <tty_ldisc_close>
c01bc090:       e1a00004        mov     r0, r4
c01bc094:       e1a01006        mov     r1, r6
c01bc098:       ebfffcae        bl      c01bb358 <tty_ldisc_assign>
c01bc09c:       e1a00004        mov     r0, r4
c01bc0a0:       e1a0100b        mov     r1, fp
c01bc0a4:       ebfffdba        bl      c01bb794 <tty_set_termios_ldisc>
c01bc0a8:       e1a00004        mov     r0, r4
c01bc0ac:       e1a01006        mov     r1, r6
c01bc0b0:       ebfffde6        bl      c01bb850 <tty_ldisc_open>
c01bc0b4:       e2505000        subs    r5, r0, #0
c01bc0b8:       aa000031        bge     c01bc184 <tty_set_ldisc+0x39c>
c01bc0bc:       e1a00006        mov     r0, r6
c01bc0c0:       ebfffe09        bl      c01bb8ec <put_ldisc>
c01bc0c4:       e59a3000        ldr     r3, [sl]
c01bc0c8:       e5930008        ldr     r0, [r3, #8]
c01bc0cc:       ebfffd7d        bl      c01bb6c8 <tty_ldisc_get>
c01bc0d0:       e3700a01        cmn     r0, #4096       ; 0x1000
c01bc0d4:       e1a06000        mov     r6, r0
c01bc0d8:       9a000002        bls     c01bc0e8 <tty_set_ldisc+0x300>
c01bc0dc:       e59f014c        ldr     r0, [pc, #332]  ; c01bc230 <tty_set_ldisc+0x448>
c01bc0e0:       e3a01e1f        mov     r1, #496        ; 0x1f0
c01bc0e4:       ebf9ee80        bl      c0037aec <warn_slowpath_null>
c01bc0e8:       e1a00004        mov     r0, r4
c01bc0ec:       e1a01006        mov     r1, r6
c01bc0f0:       ebfffc98        bl      c01bb358 <tty_ldisc_assign>
c01bc0f4:       e5963000        ldr     r3, [r6]
c01bc0f8:       e1a00004        mov     r0, r4
c01bc0fc:       e5931008        ldr     r1, [r3, #8]
c01bc100:       ebfffda3        bl      c01bb794 <tty_set_termios_ldisc>
c01bc104:       e1a00004        mov     r0, r4
c01bc108:       e1a01006        mov     r1, r6
c01bc10c:       ebfffdcf        bl      c01bb850 <tty_ldisc_open>
c01bc110:       e3500000        cmp     r0, #0
c01bc114:       aa00001a        bge     c01bc184 <tty_set_ldisc+0x39c>
c01bc118:       e1a00006        mov     r0, r6
c01bc11c:       ebfffdf2        bl      c01bb8ec <put_ldisc>
c01bc120:       e3a00000        mov     r0, #0
c01bc124:       ebfffd67        bl      c01bb6c8 <tty_ldisc_get>
c01bc128:       e3700a01        cmn     r0, #4096       ; 0x1000
c01bc12c:       e1a06000        mov     r6, r0
c01bc130:       9a000001        bls     c01bc13c <tty_set_ldisc+0x354>
c01bc134:       e59f00f8        ldr     r0, [pc, #248]  ; c01bc234 <tty_set_ldisc+0x44c>
c01bc138:       eb06e09c        bl      c03743b0 <panic>
c01bc13c:       e1a01006        mov     r1, r6
c01bc140:       e1a00004        mov     r0, r4
c01bc144:       ebfffc83        bl      c01bb358 <tty_ldisc_assign>
c01bc148:       e1a00004        mov     r0, r4
c01bc14c:       e3a01000        mov     r1, #0
c01bc150:       ebfffd8f        bl      c01bb794 <tty_set_termios_ldisc>
c01bc154:       e1a01006        mov     r1, r6
c01bc158:       e1a00004        mov     r0, r4
c01bc15c:       ebfffdbb        bl      c01bb850 <tty_ldisc_open>
c01bc160:       e2506000        subs    r6, r0, #0
c01bc164:       aa000006        bge     c01bc184 <tty_set_ldisc+0x39c>
c01bc168:       e28d1010        add     r1, sp, #16
c01bc16c:       e1a00004        mov     r0, r4
c01bc16c:       e1a00004        mov     r0, r4
c01bc170:       ebffe9cd        bl      c01b68ac <tty_name>
c01bc174:       e1a02006        mov     r2, r6
c01bc178:       e1a01000        mov     r1, r0
c01bc17c:       e59f00b4        ldr     r0, [pc, #180]  ; c01bc238 <tty_set_ldisc+0x450>
c01bc180:       eb06e08a        bl      c03743b0 <panic>
c01bc184:       e5943024        ldr     r3, [r4, #36]   ; 0x24
c01bc188:       e5932000        ldr     r2, [r3]
c01bc18c:       e59a3000        ldr     r3, [sl]
c01bc190:       e5922008        ldr     r2, [r2, #8]
c01bc194:       e5933008        ldr     r3, [r3, #8]
c01bc198:       e1520003        cmp     r2, r3
c01bc19c:       0a000005        beq     c01bc1b8 <tty_set_ldisc+0x3d0>
c01bc1a0:       e5943010        ldr     r3, [r4, #16]
c01bc1a4:       e5933058        ldr     r3, [r3, #88]   ; 0x58
c01bc1a8:       e3530000        cmp     r3, #0
c01bc1ac:       0a000001        beq     c01bc1b8 <tty_set_ldisc+0x3d0>
c01bc1b0:       e1a00004        mov     r0, r4
c01bc1b4:       e12fff33        blx     r3
c01bc1b8:       e1a0000a        mov     r0, sl
c01bc1bc:       ebfffdca        bl      c01bb8ec <put_ldisc>
c01bc1c0:       e1a00004        mov     r0, r4
c01bc1c4:       ebfffe31        bl      c01bba90 <tty_ldisc_enable>
c01bc1c8:       e3580000        cmp     r8, #0
c01bc1cc:       0a000001        beq     c01bc1d8 <tty_set_ldisc+0x3f0>
c01bc1d0:       e1a00008        mov     r0, r8
c01bc1d4:       ebfffe2d        bl      c01bba90 <tty_ldisc_enable>
c01bc1d8:       e59d300c        ldr     r3, [sp, #12]
c01bc1dc:       e3530000        cmp     r3, #0
c01bc1e0:       0a000002        beq     c01bc1f0 <tty_set_ldisc+0x408>
c01bc1e4:       e28400a8        add     r0, r4, #168    ; 0xa8
c01bc1e8:       e3a01001        mov     r1, #1
c01bc1ec:       ebfa3fe5        bl      c004c188 <schedule_delayed_work>
c01bc1f0:       e59d3008        ldr     r3, [sp, #8]
c01bc1f4:       e3530000        cmp     r3, #0
c01bc1f8:       0a000002        beq     c01bc208 <tty_set_ldisc+0x420>
c01bc1fc:       e28800a8        add     r0, r8, #168    ; 0xa8
c01bc200:       e3a01001        mov     r1, #1
c01bc204:       ebfa3fdf        bl      c004c188 <schedule_delayed_work>
c01bc208:       e1a00007        mov     r0, r7
c01bc20c:       eb06e4f0        bl      c03755d4 <mutex_unlock>
c01bc210:       eb06e9ef        bl      c03769d4 <tty_unlock>
c01bc214:       e1a00005        mov     r0, r5
c01bc218:       e28dd054        add     sp, sp, #84     ; 0x54
c01bc21c:       e8bd8ff0        pop     {r4, r5, r6, r7, r8, r9, sl, fp, pc}
c01bc220:       c0050040        .word   0xc0050040
c01bc224:       c04a3e08        .word   0xc04a3e08
c01bc228:       c04a3e00        .word   0xc04a3e00
c01bc22c:       fffffe00        .word   0xfffffe00
c01bc230:       c0431d29        .word   0xc0431d29
c01bc234:       c0431d41        .word   0xc0431d41
c01bc238:       c0431d4c        .word   0xc0431d4c

Hope, that helps,
S.

