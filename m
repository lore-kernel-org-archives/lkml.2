Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0CRSV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:21:29 -0400
Received: from mail-px0-f198.google.com ([209.85.216.198]:58881 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab0CRSV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JltJ6Ivv15b3MCicVGijvJM1v237YuNltUC7eE+ZNhAGSnVfXdn96Ovd8AvpXDuu2A
         +D/mcDM1qlVEPxU1NaI0cIFwzBtXJPC/zTmK+izokDFwtntZGdAu/qy6NzwLT+UOqqND
         XJU//nVuhnRHmN2fMy0V1P6uUEEephl8l4xhY=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] x86: Merge fpu and simd exception handlers
Date: Thu, 18 Mar 2010 14:20:48 -0400
Message-Id: <1268936453-3727-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series merges the fpu and simd exception handlers into one
function.  The only difference is where the status bits are read from.
This also applies a fix for multiple simd exceptions that was already 
done for fpu.

[PATCH 1/5] x86-32: Split cache flush handler from simd handler
[PATCH 2/5] x86-32: Remove die_if_kernel()
[PATCH 3/5] x86: Merge simd_math_error() into math_error()
[PATCH 4/5] x86: Merge kernel_math_error() into math_error()
[PATCH 5/5] x86-32: Don't set ignore_fpu_irq in simd exception

 arch/x86/include/asm/traps.h |    2 +-
 arch/x86/kernel/entry_32.S   |   16 +++-
 arch/x86/kernel/irqinit.c    |    2 +-
 arch/x86/kernel/traps.c      |  195 +++++++++++++++---------------------------
 4 files changed, 87 insertions(+), 128 deletions(-)
