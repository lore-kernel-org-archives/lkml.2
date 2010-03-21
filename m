Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0CUNBG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 09:01:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45848 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab0CUNBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 09:01:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cDxa2lRROrrUzSAPXAbSm5+Bn97L3p8TxKVZ2ryNqC5ZmgUA1IM1V1sR306fsopeKp
         55xeWKXB7kSK0fxZcuRPhRC1KeOX0nh5NqjNwj04ADumKJkjue3DlV6E2Yn7rEdN+ttF
         ip3B8r5SGY+b6381Qp167yq+u8pauo7j1639g=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] x86: Merge fpu and simd exception handlers (v2)
Date: Sun, 21 Mar 2010 09:00:42 -0400
Message-Id: <1269176446-2489-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series merges the fpu and simd exception handlers into one
function.  The only difference is where the status bits are read from.
This also applies a fix for multiple simd exceptions that was already
done for fpu.

v2:
Changed the cache flush denied handler to simply redirect to general
protection fault.
Squashed patch to remove die_if_kernel() into patch #1.

[PATCH 1/4] x86-32: Rework cache flush denied handler
[PATCH 2/4] x86: Merge simd_math_error() into math_error()
[PATCH 3/4] x86: Merge kernel_math_error() into math_error()
[PATCH 4/4] x86-32: Don't set ignore_fpu_irq in simd exception

 arch/x86/Kconfig.cpu         |    4 +
 arch/x86/include/asm/traps.h |    2 +-
 arch/x86/kernel/entry_32.S   |   19 +++++
 arch/x86/kernel/irqinit.c    |    2 +-
 arch/x86/kernel/traps.c      |  173 ++++++++++++------------------------------
 5 files changed, 73 insertions(+), 127 deletions(-)
