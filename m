Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2JFHpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:45:01 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47076 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab2JFHo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:44:59 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/3] x86: pre mapping page table to make xen happy.
Date: Sat,  6 Oct 2012 00:44:26 -0700
Message-Id: <1349509469-11475-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <CAE9FiQV_xVsHN_+6ui_Vgnn6tk8UBOEKL+0XnoEN9VLw3gcOXA@mail.gmail.com>
References: <CAE9FiQV_xVsHN_+6ui_Vgnn6tk8UBOEKL+0XnoEN9VLw3gcOXA@mail.gmail.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on top of tip/x86/mm2

also remove early_ioremap in page table accessing.


Yinghai Lu (3):
  x86: get early page table from BRK
  x86, mm: Don't clear page table if next range is ram
  x86, mm: Remove early_memremap workaround for page table accessing

 arch/x86/include/asm/init.h    |    4 ++
 arch/x86/include/asm/pgtable.h |    1 +
 arch/x86/kernel/setup.c        |    2 +
 arch/x86/mm/init.c             |   25 ++++++++++++
 arch/x86/mm/init_32.c          |    8 +++-
 arch/x86/mm/init_64.c          |   85 ++++++++++++++--------------------------
 6 files changed, 67 insertions(+), 58 deletions(-)

-- 
1.7.7

