Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab2C1KYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:24:32 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36090 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2C1KYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:24:31 -0400
Message-ID: <4F72E6DB.1090207@gmail.com>
Date: Wed, 28 Mar 2012 13:24:27 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Subject: Re: [PATCH 0/1] vsprintf: optimize decimal conversion (again)
References: <201203262047.17865.vda.linux@googlemail.com> <CAK1hOcOCG19U3sZAPDSH=BYsjgDMJ0VXjcoXV4EaoL30-dTO+A@mail.gmail.com> <4F72A80F.7000801@gmail.com> <201203281213.07856.vda.linux@googlemail.com>
In-Reply-To: <201203281213.07856.vda.linux@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------090908020703070109000707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090908020703070109000707
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 2012.03.28 13:13, Denys Vlasenko wrote:
> Second: run
> arm-linux-gnueabi-gcc -O2 -Wall test_{org,new}.c -S
> and email me resulting test_{org,new}.s files.

test_{org,new}.s attached.


--------------090908020703070109000707
Content-Type: text/plain;
 name="test_new.s"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test_new.s"

	.cpu arm9tdmi
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 18, 4
	.file	"test_new.c"
	.text
	.align	2
	.type	put_dec_trunc8, %function
put_dec_trunc8:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L5
	stmfd	sp!, {r4, r5, fp}
	umull	fp, ip, r1, r3
	mov	r2, ip
	add	r1, r1, #48
	mov	ip, r0
	add	r0, r2, r2, asl #2
	sub	r1, r1, r0, asl #1
	cmp	r2, #0
	mov	r0, ip
	strb	r1, [r0], #1
	beq	.L2
	umull	r4, r5, r2, r3
	add	r2, r2, #48
	add	fp, r5, r5, asl #2
	sub	r2, r2, fp, asl #1
	cmp	r5, #0
	mov	r1, r5
	strb	r2, [ip, #1]
	add	r0, r0, #1
	beq	.L2
	umull	r4, r5, r1, r3
	add	r1, r1, #48
	add	ip, r5, r5, asl #2
	sub	r1, r1, ip, asl #1
	cmp	r5, #0
	mov	r2, r5
	strb	r1, [r0], #1
	beq	.L2
	umull	r4, r5, r2, r3
	add	r2, r2, #48
	add	r1, r5, r5, asl #2
	sub	r2, r2, r1, asl #1
	cmp	r5, #0
	strb	r2, [r0], #1
	beq	.L2
	add	r2, r5, r5, asl #1
	add	r2, r5, r2, asl #2
	rsb	r2, r2, r2, asl #6
	add	r2, r5, r2, asl #2
	mov	r2, r2, asl #1
	mov	r2, r2, lsr #16
	add	r3, r5, #48
	add	r1, r2, r2, asl #2
	sub	r3, r3, r1, asl #1
	cmp	r2, #0
	strb	r3, [r0], #1
	beq	.L2
	add	r1, r2, r1, asl #3
	add	r1, r1, r1, asl #2
	mov	r3, r1, lsr #11
	add	r2, r2, #48
	add	r1, r3, r3, asl #2
	sub	r2, r2, r1, asl #1
	cmp	r3, #0
	strb	r2, [r0], #1
	beq	.L2
	add	r1, r3, r1, asl #3
	add	r1, r1, r1, asl #2
	mov	r2, r1, lsr #11
	add	r1, r2, r2, asl #2
	add	r3, r3, #48
	cmp	r2, #0
	sub	r3, r3, r1, asl #1
	strb	r3, [r0], #1
	addne	r2, r2, #48
	strneb	r2, [r0], #1
.L2:
	ldmfd	sp!, {r4, r5, fp}
	bx	lr
.L6:
	.align	2
.L5:
	.word	429496730
	.size	put_dec_trunc8, .-put_dec_trunc8
	.align	2
	.type	put_dec_full4, %function
put_dec_full4:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	add	r3, r1, r1, asl #1
	add	r3, r3, r3, asl #4
	add	r3, r3, r3, asl #8
	add	r3, r1, r3, asl #2
	mov	r3, r3, lsr #19
	add	r2, r3, r3, asl #1
	add	r2, r3, r2, asl #2
	rsb	r2, r2, r2, asl #6
	add	r2, r3, r2, asl #2
	mov	r2, r2, asl #1
	mov	r2, r2, lsr #16
	add	ip, r2, r2, asl #2
	stmfd	sp!, {r4, r5}
	add	r4, r2, ip, asl #3
	add	r5, r3, r3, asl #2
	add	r1, r1, #48
	add	r4, r4, r4, asl #2
	sub	r1, r1, r5, asl #1
	mov	r4, r4, lsr #11
	mov	r5, r0
	strb	r1, [r5], #1
	add	r3, r3, #48
	add	r1, r4, r4, asl #2
	add	r2, r2, #48
	sub	r2, r2, r1, asl #1
	sub	ip, r3, ip, asl #1
	add	r1, r5, #1
	add	r4, r4, #48
	strb	ip, [r0, #1]
	strb	r2, [r5, #1]
	add	r0, r1, #2
	strb	r4, [r1, #1]
	ldmfd	sp!, {r4, r5}
	bx	lr
	.size	put_dec_full4, .-put_dec_full4
	.global	__aeabi_uidivmod
	.global	__aeabi_uidiv
	.align	2
	.type	number, %function
number:
	@ Function supports interworking.
	@ args = 8, pretend = 0, frame = 120
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
	sub	sp, sp, #124
	ldrb	ip, [sp, #161]	@ zero_extendqisi2
	mov	r4, r1
	ldrh	r5, [sp, #166]
	ldrb	r1, [sp, #162]	@ zero_extendqisi2
	str	r0, [sp, #8]
	ands	r0, ip, #64
	str	r1, [sp, #16]
	str	r5, [sp, #32]
	ldrh	r1, [sp, #164]
	str	ip, [sp, #12]
	beq	.L69
	ldr	r0, [sp, #16]
	subs	r0, r0, #10
	movne	r0, #1
.L69:
	ands	r5, ip, #16
	str	r0, [sp, #24]
	and	r0, ip, #32
	andne	ip, ip, #254
	strne	ip, [sp, #12]
	str	r5, [sp, #36]
	ldr	r5, [sp, #12]
	str	r0, [sp, #4]
	tst	r5, #2
	beq	.L14
	cmp	r3, #0
	blt	.L58
	tst	r5, #4
	bne	.L71
	ldr	r5, [sp, #12]
	tst	r5, #8
	beq	.L14
	sub	r1, r1, #1
	mov	r1, r1, asl #16
	mov	r1, r1, lsr #16
	mov	r0, #32
	str	r1, [sp, #20]
	str	r0, [sp, #28]
	b	.L17
.L14:
	str	r1, [sp, #20]
	mov	r1, #0
	str	r1, [sp, #28]
.L17:
	ldr	r5, [sp, #24]
	cmp	r5, #0
	beq	.L19
	ldr	r0, [sp, #20]
	ldr	r5, [sp, #16]
	sub	r1, r0, #1
	mov	r1, r1, asl #16
	mov	r1, r1, lsr #16
	cmp	r5, #16
	str	r1, [sp, #20]
	subeq	r1, r1, #1
	moveq	r1, r1, asl #16
	moveq	r1, r1, lsr #16
	streq	r1, [sp, #20]
.L19:
	cmp	r3, #0
	bne	.L20
	cmp	r2, #7
	bls	.L72
.L20:
	ldr	r0, [sp, #16]
	cmp	r0, #10
	beq	.L23
	cmp	r0, #16
	movne	r6, #3
	moveq	r6, #4
	add	r1, sp, #52
	ldr	r9, .L76
	sub	sl, r0, #1
	mov	r5, #0
	str	r1, [sp, #40]
	sub	r7, r6, #32
	rsb	fp, r6, #32
	str	r4, [sp, #44]
	mov	r8, r1
.L26:
	mov	ip, r2, lsr r6
	cmp	r7, #0
	orr	ip, ip, r3, asl fp
	movge	ip, r3, lsr r7
	mov	r4, r3, lsr r6
	and	r2, r2, #255
	mov	r0, ip
	and	r2, r2, sl
	ldrb	ip, [r9, r2]	@ zero_extendqisi2
	mov	r2, r0
	ldr	r0, [sp, #4]
	orrs	r1, r2, r4
	orr	ip, r0, ip
	strb	ip, [r8, r5]
	mov	r3, r4
	add	r5, r5, #1
	bne	.L26
	ldr	r4, [sp, #44]
	sub	ip, r5, #1
.L22:
	ldr	r2, [sp, #32]
	ldr	r3, [sp, #20]
	mov	r0, r2, asl #16
	cmp	r5, r0, asr #16
	movgt	r0, r5, asl #16
	mov	r0, r0, lsr #16
	ldr	r1, [sp, #12]
	rsb	r7, r0, r3
	mov	r7, r7, asl #16
	mov	r7, r7, lsr #16
	tst	r1, #17
	mov	r1, r7
	bne	.L34
	sub	r1, r7, #1
	mov	r1, r1, asl #16
	cmp	r1, #0
	mov	r1, r1, lsr #16
	blt	.L34
	ldr	r3, [sp, #8]
	mov	r8, r1
	add	r2, r3, #1
	add	r2, r2, r1
	mov	r6, #32
.L36:
	cmp	r4, r3
	strhib	r6, [r3, #0]
	add	r3, r3, #1
	cmp	r3, r2
	bne	.L36
	rsb	r7, r7, #1
	ldr	r2, [sp, #8]
	add	r1, r1, r7
	mov	r1, r1, asl #16
	add	r8, r8, #1
	sub	r1, r1, #65536
	add	r2, r2, r8
	str	r2, [sp, #8]
	mov	r1, r1, lsr #16
.L34:
	ldr	r3, [sp, #28]
	cmp	r3, #0
	beq	.L37
	ldr	r2, [sp, #8]
	cmp	r2, r4
	strccb	r3, [r2, #0]
	ldr	r3, [sp, #8]
	add	r3, r3, #1
	str	r3, [sp, #8]
.L37:
	ldr	r2, [sp, #24]
	cmp	r2, #0
	beq	.L39
	ldr	r3, [sp, #8]
	cmp	r3, r4
	ldrcc	r2, [sp, #8]
	movcc	r3, #48
	strccb	r3, [r2, #0]
	ldr	r2, [sp, #8]
	ldr	r3, [sp, #16]
	add	r2, r2, #1
	cmp	r3, #16
	str	r2, [sp, #8]
	beq	.L73
.L39:
	ldr	r2, [sp, #36]
	cmp	r2, #0
	movne	r6, r1
	movne	r7, r6, asl #16
	bne	.L43
	sub	r6, r1, #1
	ldr	r3, [sp, #12]
	mov	r6, r6, asl #16
	tst	r3, #1
	mov	r6, r6, lsr #16
	movne	r8, #48
	moveq	r8, #32
	movs	r7, r6, asl #16
	bmi	.L43
	sub	r2, r1, #1
	ldr	r3, [sp, #8]
	mov	r2, r2, asl #16
	add	r2, r3, r2, lsr #16
	add	r2, r2, #1
.L47:
	cmp	r4, r3
	strhib	r8, [r3, #0]
	add	r3, r3, #1
	cmp	r3, r2
	bne	.L47
	rsb	r6, r1, r6
	mov	r6, r6, asl #16
	mov	r6, r6, lsr #16
	str	r3, [sp, #8]
	mov	r7, r6, asl #16
.L43:
	sub	r3, r0, #1
	mov	r3, r3, asl #16
	cmp	r5, r3, asr #16
	bgt	.L48
	sub	r1, r0, #2
	ldr	r3, [sp, #8]
	mov	r1, r1, asl #16
	add	r1, r3, r1, asr #16
	add	r1, r1, #1
	mov	r0, #48
.L50:
	cmp	r4, r3
	strhib	r0, [r3, #0]
	add	r3, r3, #1
	rsb	r2, r3, r1
	cmp	r5, r2
	ble	.L50
	str	r3, [sp, #8]
.L48:
	cmp	ip, #0
	blt	.L51
	add	r2, sp, #52
	ldr	r3, [sp, #8]
	sub	r1, r2, #1
	add	r2, r2, ip
.L53:
	cmp	r4, r3
	ldrhib	r0, [r2, #0]	@ zero_extendqisi2
	sub	r2, r2, #1
	strhib	r0, [r3, #0]
	cmp	r2, r1
	add	r3, r3, #1
	bne	.L53
	ldr	r5, [sp, #8]
	add	ip, ip, #1
	add	r5, r5, ip
	str	r5, [sp, #8]
.L51:
	cmp	r7, #0
	ble	.L54
	ldr	r0, [sp, #8]
	sub	r2, r6, #1
	mov	r2, r2, asl #16
	add	r2, r0, r2, lsr #16
	add	r2, r2, #1
	mov	r3, r0
	mov	r1, #32
.L56:
	cmp	r4, r3
	strhib	r1, [r3, #0]
	add	r3, r3, #1
	cmp	r3, r2
	bne	.L56
	str	r3, [sp, #8]
.L54:
	ldr	r0, [sp, #8]
	add	sp, sp, #124
	ldmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
	bx	lr
.L71:
	sub	r1, r1, #1
	mov	r1, r1, asl #16
	mov	r1, r1, lsr #16
	str	r1, [sp, #20]
	mov	r1, #43
	str	r1, [sp, #28]
	b	.L17
.L58:
	sub	r1, r1, #1
	mov	r1, r1, asl #16
	mov	r1, r1, lsr #16
	mov	r0, #45
	rsbs	r2, r2, #0
	rsc	r3, r3, #0
	str	r1, [sp, #20]
	str	r0, [sp, #28]
	b	.L17
.L72:
	add	r1, r2, #48
	strb	r1, [sp, #52]
	mov	ip, r3
	mov	r5, #1
	b	.L22
.L23:
	cmp	r3, #0
	beq	.L74
.L27:
	mov	r1, r2, asl #16
	ldr	r0, .L76+4
	mov	r8, r2, lsr #16
	mov	r1, r1, lsr #16
	mla	ip, r0, r8, r1
	mov	r7, r3, lsr #16
	mov	r6, r3
	mov	r3, #656
	mla	r2, r3, r7, ip
	mov	r6, r6, asl #16
	mov	r6, r6, lsr #16
	mov	r3, #7296
	mla	r5, r3, r6, r2
	add	r0, sp, #52
	str	r0, [sp, #40]
	ldr	r1, .L76+8
	mov	r0, r5
	bl	__aeabi_uidivmod
	ldr	r0, [sp, #40]
	bl	put_dec_full4
	ldr	r3, .L76+12
	mov	sl, r0
	mul	r2, r3, r6
	sub	r3, r3, #1824
	sub	r3, r3, #1
	mla	ip, r3, r7, r2
	mov	r0, r5
	mov	r3, #6
	ldr	r1, .L76+8
	mla	r5, r3, r8, ip
	bl	__aeabi_uidiv
	add	r5, r5, r0
	mov	r0, r5
	ldr	r1, .L76+8
	bl	__aeabi_uidivmod
	mov	r0, sl
	bl	put_dec_full4
	ldr	r3, .L76+16
	mov	r8, r0
	mul	r2, r3, r7
	mov	r0, r5
	mov	r3, #42
	ldr	r1, .L76+8
	mla	r5, r3, r6, r2
	bl	__aeabi_uidiv
	add	r5, r5, r0
	mov	r0, r5
	ldr	r1, .L76+8
	bl	__aeabi_uidivmod
	mov	r0, r8
	bl	put_dec_full4
	ldr	r3, .L76+20
	mov	r6, r0
	ldr	r1, .L76+8
	mov	r0, r5
	mul	r5, r3, r7
	bl	__aeabi_uidiv
	adds	r5, r0, r5
	bne	.L75
.L30:
	mov	r3, r6
.L31:
	mov	r0, r3
	ldrb	r2, [r3, #-1]!	@ zero_extendqisi2
	cmp	r2, #48
	beq	.L31
.L29:
	ldr	r1, [sp, #40]
	rsb	r5, r1, r0
	sub	ip, r5, #1
	b	.L22
.L73:
	cmp	r4, r2
	ldrhi	r2, [sp, #4]
	orrhi	r3, r2, #88
	ldrhi	r2, [sp, #8]
	strhib	r3, [r2, #0]
	ldr	r3, [sp, #8]
	add	r3, r3, #1
	str	r3, [sp, #8]
	b	.L39
.L74:
	ldr	r1, .L76+24
	cmp	r2, r1
	bhi	.L27
	add	r5, sp, #52
	mov	r1, r2
	mov	r0, r5
	str	r5, [sp, #40]
	bl	put_dec_trunc8
	b	.L29
.L75:
	mov	r0, r5
	ldr	r1, .L76+8
	bl	__aeabi_uidivmod
	mov	r0, r6
	bl	put_dec_full4
	ldr	r1, .L76+8
	mov	r6, r0
	mov	r0, r5
	bl	__aeabi_uidiv
	subs	r1, r0, #0
	beq	.L30
	mov	r0, r6
	bl	put_dec_full4
	mov	r6, r0
	b	.L30
.L77:
	.align	2
.L76:
	.word	.LANCHOR0
	.word	5536
	.word	10000
	.word	9496
	.word	4749
	.word	281
	.word	99999999
	.size	number, .-number
	.align	2
	.type	measure_number, %function
measure_number:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 72
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
	mov	fp, r3
	sub	sp, sp, #84
	ldr	r3, [r0, #0]
	str	r0, [sp, #12]
	mov	r0, #0
	str	r3, [sp, #8]
	mov	sl, r2
	bl	time
	ldr	r3, [sp, #8]
	mov	r9, #0
	add	r6, sp, #16
	cmp	r3, r0
	mov	r7, r9
	ldr	r5, .L85
	add	r8, r6, #63
	bne	.L84
.L81:
	ldr	r4, .L85+4
.L80:
	mov	ip, sp
	ldmia	r5, {r0, r1}
	mov	r2, sl
	stmia	ip, {r0, r1}
	mov	r3, fp
	mov	r0, r6
	mov	r1, r8
	bl	number
	sub	r4, r4, #1
	cmn	r4, #1
	strb	r7, [r0, #0]
	bne	.L80
	mov	r0, #0
	bl	time
	ldr	r3, [sp, #8]
	add	r9, r9, #4000
	cmp	r3, r0
	beq	.L81
.L84:
	ldr	ip, [sp, #12]
	str	r0, [ip, #0]
	mov	r0, r9
	add	sp, sp, #84
	ldmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
	bx	lr
.L86:
	.align	2
.L85:
	.word	.LANCHOR0+16
	.word	3999
	.size	measure_number, .-measure_number
	.align	2
	.type	measure, %function
measure:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
	mov	r0, #0
	sub	sp, sp, #24
	bl	time
	str	r0, [sp, #20]
.L88:
	mov	r0, #0
	bl	time
	ldr	r3, [sp, #20]
	cmp	r0, r3
	beq	.L88
	add	r8, sp, #24
	str	r0, [r8, #-4]!
	mov	r2, #8
	mov	r3, #0
	mov	r0, r8
	bl	measure_number
	mov	r2, #123
	mov	sl, r0
	mov	r3, #0
	mov	r0, r8
	bl	measure_number
	ldr	r2, .L91
	mov	r7, r0
	mov	r3, #0
	mov	r0, r8
	bl	measure_number
	ldr	r2, .L91+4
	mov	r6, r0
	mov	r3, #0
	mov	r0, r8
	bl	measure_number
	ldr	r2, .L91+8
	mov	r5, r0
	mov	r3, #0
	mov	r0, r8
	bl	measure_number
	mvn	r2, #0
	mov	r4, r0
	mov	r3, #0
	mov	r0, r8
	bl	measure_number
	mvn	r2, #0
	mov	r9, r0
	mvn	r3, #0
	mov	r0, r8
	bl	measure_number
	mov	r1, sl
	str	r0, [sp, #12]
	mov	r2, r7
	mov	r3, r6
	ldr	r0, .L91+12
	str	r5, [sp, #0]
	stmib	sp, {r4, r9}	@ phole stm
	bl	printf
	add	sp, sp, #24
	ldmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
	bx	lr
.L92:
	.align	2
.L91:
	.word	123456
	.word	12345678
	.word	123456789
	.word	.LC0
	.size	measure, .-measure
	.align	2
	.type	check, %function
check:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 128
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, r5, r6, r7, lr}
	ldr	r3, .L97
	sub	sp, sp, #140
	mov	r5, r0
	mov	r6, r1
	add	r4, sp, #72
	ldmia	r3, {r0, r1}
	mov	r3, sp
	stmia	r3, {r0, r1}
	mov	r2, r5
	mov	r3, r6
	add	r1, r4, #63
	mov	r0, r4
	bl	number
	add	r7, sp, #8
	mov	r3, #0
	strb	r3, [r0, #0]
	mov	r2, r5
	mov	r3, r6
	ldr	r1, .L97+4
	mov	r0, r7
	bl	sprintf
	mov	r0, r4
	mov	r1, r7
	bl	strcmp
	cmp	r0, #0
	bne	.L96
	add	sp, sp, #140
	ldmfd	sp!, {r4, r5, r6, r7, lr}
	bx	lr
.L96:
	mov	r2, r5
	mov	r3, r6
	ldr	r0, .L97+8
	str	r4, [sp, #0]
	bl	printf
	mov	r0, #1
	bl	exit
.L98:
	.align	2
.L97:
	.word	.LANCHOR0+16
	.word	.LC1
	.word	.LC2
	.size	check, .-check
	.align	2
	.global	main
	.type	main, %function
main:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r3, r4, r5, r6, r7, r8, r9, sl, fp, lr}
	bl	measure
	mov	r4, #0
	bl	measure
	mov	r5, #0
	bl	measure
	ldr	r6, .L103
	bl	measure
	mov	r7, #0
	mov	sl, #1
	mov	fp, #0
	b	.L101
.L100:
	adds	r4, r4, sl
	adc	r5, r5, fp
.L101:
	mov	r0, r4
	mov	r1, r5
	bl	check
	and	r8, r4, r6
	rsbs	r0, r4, #0
	rsc	r1, r5, #0
	and	r9, r5, r7
	bl	check
	orrs	r8, r8, r9
	bne	.L100
	mov	r2, r4
	mov	r3, r5
	ldr	r0, .L103+4
	bl	printf
	mov	r0, r8
	bl	fflush
	b	.L100
.L104:
	.align	2
.L103:
	.word	262143
	.word	.LC3
	.size	main, .-main
	.section	.rodata
	.align	2
.LANCHOR0 = . + 0
	.type	digits.3938, %object
	.size	digits.3938, 16
digits.3938:
	.ascii	"0123456789ABCDEF"
	.type	dummy_spec, %object
	.size	dummy_spec, 8
dummy_spec:
	.byte	8
	.byte	0
	.byte	10
	.byte	0
	.short	0
	.short	0
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC0:
	.ascii	"Conversions per second: 8:%d 123:%d 123456:%d 12345"
	.ascii	"678:%d 123456789:%d 2^32:%d 2^64:%d\012\000"
.LC1:
	.ascii	"%llu\000"
	.space	3
.LC2:
	.ascii	"Error in formatting %llu:'%s'\012\000"
	.space	1
.LC3:
	.ascii	"\015Tested %llu                               \000"
	.ident	"GCC: (Debian 4.4.5-8) 4.4.5"
	.section	.note.GNU-stack,"",%progbits

--------------090908020703070109000707
Content-Type: text/plain;
 name="test_org.s"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test_org.s"

	.cpu arm9tdmi
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 18, 4
	.file	"test_org.c"
	.text
	.align	2
	.type	put_dec_trunc, %function
put_dec_trunc:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	stmfd	sp!, {r4, r5, r6}
	mov	ip, r1, lsr #8
	mov	r4, r1, lsr #4
	and	r4, r4, #15
	and	ip, ip, #15
	mov	r3, r1, lsr #12
	add	r2, r4, ip
	add	r2, r2, r3
	add	r2, r2, r2, asl #1
	and	r1, r1, #15
	add	r1, r1, r2, asl #1
	add	r2, r1, r1, asl #2
	add	r2, r1, r2, asl #3
	add	r2, r2, r2, asl #2
	mov	r2, r2, lsr #11
	add	r5, r3, r3, asl #3
	add	r4, r5, r4
	add	r6, r2, r2, asl #2
	add	r5, ip, ip, asl #2
	add	r4, r4, r5
	sub	r1, r1, r6, asl #1
	add	r1, r1, #48
	adds	r2, r4, r2
	mov	r5, r0
	strb	r1, [r0], #1
	beq	.L2
	add	r1, r2, r2, asl #2
	add	r1, r2, r1, asl #3
	add	r1, r1, r1, asl #2
	mov	r1, r1, lsr #11
	add	r4, r1, r1, asl #2
	sub	r2, r2, r4, asl #1
	add	ip, r1, ip, asl #1
	add	r2, r2, #48
	orrs	r1, ip, r3
	strb	r2, [r5, #1]
	add	r0, r0, #1
	beq	.L2
	add	r2, ip, ip, asl #1
	add	r2, ip, r2, asl #2
	mov	r2, r2, lsr #7
	add	r1, r2, r2, asl #2
	sub	ip, ip, r1, asl #1
	add	ip, ip, #48
	adds	r3, r2, r3, asl #2
	strb	ip, [r0], #1
	beq	.L2
	add	r1, r3, r3, asl #2
	add	r1, r3, r1, asl #3
	add	r1, r1, r1, asl #2
	mov	r1, r1, lsr #11
	add	r2, r1, r1, asl #2
	sub	r3, r3, r2, asl #1
	cmp	r1, #0
	add	r3, r3, #48
	strb	r3, [r0], #1
	addne	r1, r1, #48
	strneb	r1, [r0], #1
.L2:
	ldmfd	sp!, {r4, r5, r6}
	bx	lr
	.size	put_dec_trunc, .-put_dec_trunc
	.align	2
	.type	put_dec_full, %function
put_dec_full:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	ip, r1, lsr #4
	mov	r2, r1, lsr #8
	and	r2, r2, #15
	and	ip, ip, #15
	stmfd	sp!, {r4, r5, r6, r7, r8}
	mov	r3, r1, lsr #12
	add	r4, ip, r2
	add	r4, r4, r3
	add	r4, r4, r4, asl #1
	and	r1, r1, #15
	add	r1, r1, r4, asl #1
	add	r6, r1, r1, asl #2
	add	r4, r3, r3, asl #3
	add	r6, r1, r6, asl #3
	add	ip, r4, ip
	add	r6, r6, r6, asl #2
	add	r4, r2, r2, asl #2
	add	ip, ip, r4
	mov	r6, r6, lsr #11
	add	ip, ip, r6
	add	r5, ip, ip, asl #2
	add	r5, ip, r5, asl #3
	add	r5, r5, r5, asl #2
	mov	r5, r5, lsr #11
	add	r2, r5, r2, asl #1
	add	r4, r2, r2, asl #1
	add	r4, r2, r4, asl #2
	mov	r4, r4, lsr #7
	add	r3, r4, r3, asl #2
	add	r7, r3, r3, asl #2
	add	r7, r3, r7, asl #3
	add	r6, r6, r6, asl #2
	sub	r1, r1, r6, asl #1
	add	r7, r7, r7, asl #2
	mov	r6, r0
	mov	r7, r7, lsr #11
	add	r1, r1, #48
	strb	r1, [r6], #1
	add	r5, r5, r5, asl #2
	add	r1, r7, r7, asl #2
	add	r4, r4, r4, asl #2
	add	r8, r6, #1
	sub	ip, ip, r5, asl #1
	sub	r2, r2, r4, asl #1
	sub	r3, r3, r1, asl #1
	add	ip, ip, #48
	add	r1, r8, #1
	add	r2, r2, #48
	add	r3, r3, #48
	add	r7, r7, #48
	strb	ip, [r0, #1]
	strb	r2, [r6, #1]
	add	r0, r1, #2
	strb	r3, [r8, #1]
	strb	r7, [r1, #1]
	ldmfd	sp!, {r4, r5, r6, r7, r8}
	bx	lr
	.size	put_dec_full, .-put_dec_full
	.align	2
	.type	put_dec, %function
put_dec:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r3, #0
	stmfd	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
	beq	.L18
.L15:
	ldr	sl, .L19
	ldr	r5, .L19+4
	ldr	r6, .L19+8
	mov	r8, #0
.L17:
#APP
@ 101 "test_org.c" 1
	umull	fp, ip, r5, r2
	cmn	fp, r5
	adcs	ip, ip, r6
	adc	fp, r8, #0
@ 0 "" 2
	mov	r1, r8
#APP
@ 101 "test_org.c" 1
	umlal	ip, fp, r6, r2
	umlal	ip, r1, r5, r3
	mov	ip, #0
	adds	fp, r1, fp
	adc	ip, ip, #0
	umlal	fp, ip, r6, r3
@ 0 "" 2
	mov	r4, fp, lsr #16
	orr	r4, r4, ip, asl #16
	add	r1, r4, r4, asl #1
	add	r1, r1, r1, asl #6
	add	r1, r4, r1, asl #2
	add	r1, r4, r1, asl #2
	mov	r7, ip, lsr #16
	sub	r1, r2, r1, asl #5
	bl	put_dec_full
	cmp	r7, #0
	mov	r2, r4
	mov	r3, r7
	bne	.L17
	cmp	r4, sl
	bhi	.L17
.L10:
	mov	r1, r4
	ldmfd	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
	b	put_dec_trunc
.L18:
	ldr	r1, .L19
	cmp	r2, r1
	bhi	.L15
	mov	r4, r2
	b	.L10
.L20:
	.align	2
.L19:
	.word	99999
	.word	457671715
	.word	-1480217529
	.size	put_dec, .-put_dec
	.align	2
	.type	number, %function
number:
	@ Function supports interworking.
	@ args = 8, pretend = 0, frame = 120
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
	sub	sp, sp, #124
	ldrb	ip, [sp, #161]	@ zero_extendqisi2
	ldrb	r4, [sp, #162]	@ zero_extendqisi2
	ldrh	r5, [sp, #166]
	str	r0, [sp, #12]
	ands	r0, ip, #64
	str	r4, [sp, #20]
	str	r5, [sp, #36]
	ldrh	r4, [sp, #164]
	str	ip, [sp, #16]
	beq	.L72
	ldr	r0, [sp, #20]
	subs	r0, r0, #10
	movne	r0, #1
.L72:
	ands	r5, ip, #16
	str	r0, [sp, #28]
	and	r0, ip, #32
	andne	ip, ip, #254
	strne	ip, [sp, #16]
	str	r5, [sp, #40]
	ldr	r5, [sp, #16]
	str	r0, [sp, #8]
	tst	r5, #2
	beq	.L26
	cmp	r3, #0
	blt	.L64
	tst	r5, #4
	bne	.L74
	ldr	r5, [sp, #16]
	tst	r5, #8
	beq	.L26
	sub	r0, r4, #1
	mov	r0, r0, asl #16
	mov	r0, r0, lsr #16
	mov	ip, #32
	str	r0, [sp, #24]
	str	ip, [sp, #32]
	b	.L29
.L26:
	mov	r0, #0
	str	r4, [sp, #24]
	str	r0, [sp, #32]
.L29:
	ldr	r4, [sp, #28]
	cmp	r4, #0
	beq	.L31
	ldr	r5, [sp, #24]
	ldr	ip, [sp, #20]
	sub	r0, r5, #1
	mov	r0, r0, asl #16
	mov	r0, r0, lsr #16
	cmp	ip, #16
	str	r0, [sp, #24]
	subeq	r0, r0, #1
	moveq	r0, r0, asl #16
	moveq	r0, r0, lsr #16
	streq	r0, [sp, #24]
.L31:
	orrs	ip, r2, r3
	moveq	r3, #48
	streqb	r3, [sp, #52]
	moveq	r4, #1
	beq	.L33
	ldr	r0, [sp, #20]
	cmp	r0, #10
	beq	.L34
	cmp	r0, #16
	movne	r5, #3
	moveq	r5, #4
	sub	r8, r0, #1
	ldr	sl, .L76
	rsb	r0, r5, #32
	mov	r4, #0
	add	r9, sp, #52
	sub	r6, r5, #32
	str	r1, [sp, #44]
	mov	fp, r0
.L37:
	mov	ip, r2, lsr r5
	cmp	r6, #0
	orr	ip, ip, r3, asl fp
	movge	ip, r3, lsr r6
	mov	r7, r3, lsr r5
	and	r2, r2, #255
	and	r2, r2, r8
	mov	r0, ip
	ldr	r1, [sp, #8]
	ldrb	ip, [sl, r2]	@ zero_extendqisi2
	mov	r2, r0
	orr	ip, r1, ip
	orrs	r0, r2, r7
	strb	ip, [r9, r4]
	mov	r3, r7
	add	r4, r4, #1
	bne	.L37
	ldr	r1, [sp, #44]
	sub	ip, r4, #1
.L33:
	ldr	r2, [sp, #36]
	ldr	r3, [sp, #24]
	mov	r5, r2, asl #16
	cmp	r4, r5, asr #16
	movgt	r5, r4, asl #16
	mov	r5, r5, lsr #16
	ldr	r0, [sp, #16]
	rsb	r7, r5, r3
	mov	r7, r7, asl #16
	mov	r7, r7, lsr #16
	tst	r0, #17
	mov	r0, r7
	bne	.L40
	sub	r0, r7, #1
	mov	r0, r0, asl #16
	cmp	r0, #0
	mov	r0, r0, lsr #16
	blt	.L40
	ldr	r3, [sp, #12]
	mov	r8, r0
	add	r2, r3, #1
	add	r2, r2, r0
	mov	r6, #32
.L42:
	cmp	r1, r3
	strhib	r6, [r3, #0]
	add	r3, r3, #1
	cmp	r3, r2
	bne	.L42
	rsb	r7, r7, #1
	ldr	r2, [sp, #12]
	add	r0, r0, r7
	mov	r0, r0, asl #16
	add	r3, r8, #1
	sub	r0, r0, #65536
	add	r2, r2, r3
	str	r2, [sp, #12]
	mov	r0, r0, lsr #16
.L40:
	ldr	r3, [sp, #32]
	cmp	r3, #0
	beq	.L43
	ldr	r2, [sp, #12]
	cmp	r2, r1
	strccb	r3, [r2, #0]
	ldr	r3, [sp, #12]
	add	r3, r3, #1
	str	r3, [sp, #12]
.L43:
	ldr	r2, [sp, #28]
	cmp	r2, #0
	beq	.L45
	ldr	r3, [sp, #12]
	cmp	r3, r1
	ldrcc	r2, [sp, #12]
	movcc	r3, #48
	strccb	r3, [r2, #0]
	ldr	r2, [sp, #12]
	ldr	r3, [sp, #20]
	add	r2, r2, #1
	cmp	r3, #16
	str	r2, [sp, #12]
	beq	.L75
.L45:
	ldr	r2, [sp, #40]
	cmp	r2, #0
	movne	r6, r0
	movne	r7, r6, asl #16
	bne	.L49
	sub	r6, r0, #1
	ldr	r3, [sp, #16]
	mov	r6, r6, asl #16
	tst	r3, #1
	mov	r6, r6, lsr #16
	movne	r8, #48
	moveq	r8, #32
	movs	r7, r6, asl #16
	bmi	.L49
	sub	r2, r0, #1
	ldr	r3, [sp, #12]
	mov	r2, r2, asl #16
	add	r2, r3, r2, lsr #16
	add	r2, r2, #1
.L53:
	cmp	r1, r3
	strhib	r8, [r3, #0]
	add	r3, r3, #1
	cmp	r3, r2
	bne	.L53
	rsb	r6, r0, r6
	mov	r6, r6, asl #16
	mov	r6, r6, lsr #16
	str	r3, [sp, #12]
	mov	r7, r6, asl #16
.L49:
	sub	r3, r5, #1
	mov	r3, r3, asl #16
	cmp	r4, r3, asr #16
	bgt	.L54
	sub	r0, r5, #2
	ldr	r3, [sp, #12]
	mov	r0, r0, asl #16
	add	r0, r3, r0, asr #16
	add	r0, r0, #1
	mov	r5, #48
.L56:
	cmp	r1, r3
	strhib	r5, [r3, #0]
	add	r3, r3, #1
	rsb	r2, r3, r0
	cmp	r4, r2
	ble	.L56
	str	r3, [sp, #12]
.L54:
	cmp	ip, #0
	blt	.L57
	add	r2, sp, #52
	ldr	r3, [sp, #12]
	sub	r0, r2, #1
	add	r2, r2, ip
.L59:
	cmp	r1, r3
	ldrhib	r4, [r2, #0]	@ zero_extendqisi2
	sub	r2, r2, #1
	strhib	r4, [r3, #0]
	cmp	r2, r0
	add	r3, r3, #1
	bne	.L59
	ldr	r4, [sp, #12]
	add	ip, ip, #1
	add	r4, r4, ip
	str	r4, [sp, #12]
.L57:
	cmp	r7, #0
	ble	.L60
	ldr	r5, [sp, #12]
	sub	r2, r6, #1
	mov	r2, r2, asl #16
	add	r2, r5, r2, lsr #16
	add	r2, r2, #1
	mov	r3, r5
	mov	r0, #32
.L62:
	cmp	r1, r3
	strhib	r0, [r3, #0]
	add	r3, r3, #1
	cmp	r3, r2
	bne	.L62
	str	r3, [sp, #12]
.L60:
	ldr	r0, [sp, #12]
	add	sp, sp, #124
	ldmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
	bx	lr
.L74:
	sub	r0, r4, #1
	mov	r0, r0, asl #16
	mov	r0, r0, lsr #16
	str	r0, [sp, #24]
	mov	r0, #43
	str	r0, [sp, #32]
	b	.L29
.L75:
	cmp	r1, r2
	ldrhi	r2, [sp, #8]
	orrhi	r3, r2, #88
	ldrhi	r2, [sp, #12]
	strhib	r3, [r2, #0]
	ldr	r3, [sp, #12]
	add	r3, r3, #1
	str	r3, [sp, #12]
	b	.L45
.L64:
	sub	r0, r4, #1
	mov	r0, r0, asl #16
	mov	r0, r0, lsr #16
	mov	ip, #45
	rsbs	r2, r2, #0
	rsc	r3, r3, #0
	str	r0, [sp, #24]
	str	ip, [sp, #32]
	b	.L29
.L34:
	add	r4, sp, #52
	mov	r0, r4
	str	r1, [sp, #4]
	bl	put_dec
	rsb	r4, r4, r0
	sub	ip, r4, #1
	ldr	r1, [sp, #4]
	b	.L33
.L77:
	.align	2
.L76:
	.word	.LANCHOR0
	.size	number, .-number
	.align	2
	.type	measure_number, %function
measure_number:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 72
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
	mov	fp, r3
	sub	sp, sp, #84
	ldr	r3, [r0, #0]
	str	r0, [sp, #12]
	mov	r0, #0
	str	r3, [sp, #8]
	mov	sl, r2
	bl	time
	ldr	r3, [sp, #8]
	mov	r9, #0
	add	r6, sp, #16
	cmp	r3, r0
	mov	r7, r9
	ldr	r5, .L85
	add	r8, r6, #63
	bne	.L84
.L81:
	ldr	r4, .L85+4
.L80:
	mov	ip, sp
	ldmia	r5, {r0, r1}
	mov	r2, sl
	stmia	ip, {r0, r1}
	mov	r3, fp
	mov	r0, r6
	mov	r1, r8
	bl	number
	sub	r4, r4, #1
	cmn	r4, #1
	strb	r7, [r0, #0]
	bne	.L80
	mov	r0, #0
	bl	time
	ldr	r3, [sp, #8]
	add	r9, r9, #4000
	cmp	r3, r0
	beq	.L81
.L84:
	ldr	ip, [sp, #12]
	str	r0, [ip, #0]
	mov	r0, r9
	add	sp, sp, #84
	ldmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
	bx	lr
.L86:
	.align	2
.L85:
	.word	.LANCHOR0+16
	.word	3999
	.size	measure_number, .-measure_number
	.align	2
	.type	measure, %function
measure:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
	mov	r0, #0
	sub	sp, sp, #24
	bl	time
	str	r0, [sp, #20]
.L88:
	mov	r0, #0
	bl	time
	ldr	r3, [sp, #20]
	cmp	r0, r3
	beq	.L88
	add	r8, sp, #24
	str	r0, [r8, #-4]!
	mov	r2, #8
	mov	r3, #0
	mov	r0, r8
	bl	measure_number
	mov	r2, #123
	mov	sl, r0
	mov	r3, #0
	mov	r0, r8
	bl	measure_number
	ldr	r2, .L91
	mov	r7, r0
	mov	r3, #0
	mov	r0, r8
	bl	measure_number
	ldr	r2, .L91+4
	mov	r6, r0
	mov	r3, #0
	mov	r0, r8
	bl	measure_number
	ldr	r2, .L91+8
	mov	r5, r0
	mov	r3, #0
	mov	r0, r8
	bl	measure_number
	mvn	r2, #0
	mov	r4, r0
	mov	r3, #0
	mov	r0, r8
	bl	measure_number
	mvn	r2, #0
	mov	r9, r0
	mvn	r3, #0
	mov	r0, r8
	bl	measure_number
	mov	r1, sl
	str	r0, [sp, #12]
	mov	r2, r7
	mov	r3, r6
	ldr	r0, .L91+12
	str	r5, [sp, #0]
	stmib	sp, {r4, r9}	@ phole stm
	bl	printf
	add	sp, sp, #24
	ldmfd	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
	bx	lr
.L92:
	.align	2
.L91:
	.word	123456
	.word	12345678
	.word	123456789
	.word	.LC0
	.size	measure, .-measure
	.align	2
	.type	check, %function
check:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 128
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r4, r5, r6, r7, lr}
	ldr	r3, .L97
	sub	sp, sp, #140
	mov	r5, r0
	mov	r6, r1
	add	r4, sp, #72
	ldmia	r3, {r0, r1}
	mov	r3, sp
	stmia	r3, {r0, r1}
	mov	r2, r5
	mov	r3, r6
	add	r1, r4, #63
	mov	r0, r4
	bl	number
	add	r7, sp, #8
	mov	r3, #0
	strb	r3, [r0, #0]
	mov	r2, r5
	mov	r3, r6
	ldr	r1, .L97+4
	mov	r0, r7
	bl	sprintf
	mov	r0, r4
	mov	r1, r7
	bl	strcmp
	cmp	r0, #0
	bne	.L96
	add	sp, sp, #140
	ldmfd	sp!, {r4, r5, r6, r7, lr}
	bx	lr
.L96:
	mov	r2, r5
	mov	r3, r6
	ldr	r0, .L97+8
	str	r4, [sp, #0]
	bl	printf
	mov	r0, #1
	bl	exit
.L98:
	.align	2
.L97:
	.word	.LANCHOR0+16
	.word	.LC1
	.word	.LC2
	.size	check, .-check
	.align	2
	.global	main
	.type	main, %function
main:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	stmfd	sp!, {r3, r4, r5, r6, r7, r8, r9, sl, fp, lr}
	bl	measure
	mov	r4, #0
	bl	measure
	mov	r5, #0
	bl	measure
	ldr	r6, .L103
	bl	measure
	mov	r7, #0
	mov	sl, #1
	mov	fp, #0
	b	.L101
.L100:
	adds	r4, r4, sl
	adc	r5, r5, fp
.L101:
	mov	r0, r4
	mov	r1, r5
	bl	check
	and	r8, r4, r6
	rsbs	r0, r4, #0
	rsc	r1, r5, #0
	and	r9, r5, r7
	bl	check
	orrs	r8, r8, r9
	bne	.L100
	mov	r2, r4
	mov	r3, r5
	ldr	r0, .L103+4
	bl	printf
	mov	r0, r8
	bl	fflush
	b	.L100
.L104:
	.align	2
.L103:
	.word	262143
	.word	.LC3
	.size	main, .-main
	.section	.rodata
	.align	2
.LANCHOR0 = . + 0
	.type	digits.4070, %object
	.size	digits.4070, 16
digits.4070:
	.ascii	"0123456789ABCDEF"
	.type	dummy_spec, %object
	.size	dummy_spec, 8
dummy_spec:
	.byte	8
	.byte	0
	.byte	10
	.byte	0
	.short	0
	.short	0
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC0:
	.ascii	"Conversions per second: 8:%d 123:%d 123456:%d 12345"
	.ascii	"678:%d 123456789:%d 2^32:%d 2^64:%d\012\000"
.LC1:
	.ascii	"%llu\000"
	.space	3
.LC2:
	.ascii	"Error in formatting %llu:'%s'\012\000"
	.space	1
.LC3:
	.ascii	"\015Tested %llu                               \000"
	.ident	"GCC: (Debian 4.4.5-8) 4.4.5"
	.section	.note.GNU-stack,"",%progbits

--------------090908020703070109000707--
