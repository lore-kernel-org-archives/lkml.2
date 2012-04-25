Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab2DYAKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 20:10:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38915 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab2DYAJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 20:09:59 -0400
Message-ID: <4F9740C5.6050306@zytor.com>
Date: Tue, 24 Apr 2012 17:09:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/3] math128: Introduce {mult,add,cmp}_u128
References: <20120424161039.293018424@chello.nl>  <20120424162224.526249106@chello.nl>  <CA+55aFyvBTDh_DkXs6Z6zFmjyYxvWaAEm9-rJDXhvPx8CpDiKA@mail.gmail.com> <1335304497.28150.243.camel@twins>
In-Reply-To: <1335304497.28150.243.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 02:54 PM, Peter Zijlstra wrote:
> -       andl    $4294967295, %edx
>         shrq    $32, %rcx
> -       andl    $4294967295, %esi
> +       mov     %esi, %esi

If you can *ever* get gcc to generate those andl instructions on x86,
then please file a gcc bug report: the constant is 0xffffffff and those
are plain zero-extension instructions which is much better done with mov.

	-hpa

