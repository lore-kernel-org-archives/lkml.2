Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2IRGzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:55:46 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33827 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863Ab2IRGzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:55:44 -0400
MIME-Version: 1.0
In-Reply-To: <5057654A.803@tlinx.org>
References: <5057654A.803@tlinx.org>
Date: Tue, 18 Sep 2012 14:55:43 +0800
Message-ID: <CANE52Khbw0-iA=nAebySc=Fw-6CtY-wuOC9Kw_UE3mbkOAKJmA@mail.gmail.com>
Subject: Re: 2 physical-cpu (like 2x6core) config and NUMA?
From: Jike Song <albcamus@gmail.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 2:00 AM, Linda Walsh <lkml@tlinx.org> wrote:
> Does the kernel support scheduling based on the different speed of
> memory between "on die" vs. "off die"?   I was surprised to see
> that it viewed my system as 1 NUMA node with all 12 on 1 node -- when
> I know that it is physically organized as 2x6.
> Do I have to configure that manually or did I maybe turn off something
> in my kernel config I should have turned on?

Do you have anything printed with:

 # acpidump -a --table SRAT

?

I have a Dell box with 2 physical CPUs, each of them has 6 cores.  If
I enable "Node Interleaving" in BIOS' Memory Setting, and boot the
kernel, the SRAT table will be invisible to Linux - results the same
topology as you got.  If I disable "Node Interleaving" and boot the
kernel, SRAT is present, and the topology is correct.

Hope that helps.

-- 
Thanks,
Jike
