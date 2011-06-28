Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1F1Ctt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 22:49:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36104 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab1F1CsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 22:48:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=a3EhdtxpIZKw7ltDokd0+4+9TUELTDu9FX8SsIhycWwsX1XfA8c/QQwJUPpq/tg0X
	O0ptyQtvQ8EQpEe7rdHcw==
From: Todd Poynor <toddpoynor@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Todd Poynor <toddpoynor@google.com>
Subject: [PATCH 0/3] Add generic idle notifiers
Date: Mon, 27 Jun 2011 19:46:27 -0700
Message-Id: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add notifiers for idle entry and exit, called with IDLE_START when a
CPU goes idle and IDLE_END when it goes out of idle, based on the
existing idle notifiers for the x86_64 arch.

Convert x86_64 to use these notifiers, and call the notifiers on ARM.

Convert the ARM LEDs events for idle start/end to these notifiers.

 arch/arm/kernel/leds.c       |   27 ++++++++++++++++++++++++++-
 arch/arm/kernel/process.c    |    5 ++---
 arch/x86/include/asm/idle.h  |    7 -------
 arch/x86/kernel/process_64.c |   18 ++----------------
 include/linux/cpu.h          |    7 +++++++
 kernel/cpu.c                 |   20 ++++++++++++++++++++
 6 files changed, 57 insertions(+), 27 deletions(-)

-- 
1.7.3.1
