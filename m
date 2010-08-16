Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab0HPMMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:12:55 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:46256 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab0HPMMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:12:54 -0400
Message-ID: <4C692B42.9050407@neli.hopto.org>
Date: Mon, 16 Aug 2010 14:12:50 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Alexandre Bounine <alexandre.bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/9] RapidIO,  powerpc/85xx: modify RIO port-write interrupt
 handler
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-3-git-send-email-alexandre.bounine@idt.com>
In-Reply-To: <1281712686-31308-3-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
> - Rearranged RIO port-write interrupt handling to perform message buffering
> as soon as possible.

I don't understand this comment: you still schedule work to read the 
port-write queue; so how is this message buffering performed as soon as 
possible?

> - Modified to disable port-write controller when clearing Transaction Error (TE)
> bit.
>  	/* Schedule deferred processing if PW was received */
> -	if (ipwsr & RIO_IPWSR_QFI) {
> +	if ((ipwmr & RIO_IPWMR_QFIE) && (ipwsr & RIO_IPWSR_QFI)) {

Why check the QFIE bit also?

> +pw_done:
> +	if (epwisr & 0x80000000) {

Magic value.

Micha
