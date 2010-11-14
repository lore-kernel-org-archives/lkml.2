Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0KNELV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 23:11:21 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60743 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab0KNELT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 23:11:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=L0Y1wmbVgMk22R8BxjEDDsWjy77oX2nYTfAojZ3dtAYow4hwWEU/Cji8ejDn/HFNWk
         OsIj0+FnySQ/pU7KUeKCNwlfNofHlZ0Z9qKUnaY5rTUEUDJfGa6zr0fysobQK7YOqx/3
         68E/jo5ZLHi5rR8t1GgBfyrdPrM5B5LfBQwy0=
From: Hai Shan <haishan.bai@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fixed Powerpc SPE data type conversion failure
Date: Sun, 14 Nov 2010 12:11:02 +0800
Message-Id: <1289707863-1768-1-git-send-email-shan.hai@windriver.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following test case failed on Powerpc e500 with CONFIG_SPE

static float fm;
static signed int si_min = (-2147483647 - 1);
static unsigned int ui;
int main()
{
        fm = (float) si_min; ;
        ui = (unsigned int)fm;

        printf("ui=%d, should be %d\n", ui, si_min);

        return 0;
}

Result: ui=-1, should be -2147483648

The reason is failure to emulate the minus float to unsigned conversion instruction
in the SPE driver.

---
 arch/powerpc/math-emu/math_efp.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

