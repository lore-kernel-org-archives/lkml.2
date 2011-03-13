Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab1CMRGh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 13:06:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58115 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1CMRGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 13:06:36 -0400
Date: Sun, 13 Mar 2011 18:06:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Bogus setting of CONSTANT TSC ?
Message-ID: <20110313170632.GK2499@one.firstfloor.org>
References: <20110311212418.GA14784@redhat.com> <alpine.LFD.2.00.1103121851390.2787@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103121851390.2787@localhost6.localdomain6>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This was initially introduced with commit 39b3a7 ([PATCH] i386/x86-64:
> Generalize X86_FEATURE_CONSTANT_TSC flag), though the changelog is
> utterly useless. Andi ??

Only Nehalem and beyond set the 8000_0007 flag, but Intel has had a constant
TSC since Yonah. That is what this logic implements.

However on Nehalem and beyond if the 8000_0007 is clear the BIOS wants
to tell us that it knows the system doesn't have a synchronized TSC.
This is currently still broken, but the timer watchdog usually catches
it later. It only affects a few relatively obscure systems.

-Andi
