Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610Ab0FPUio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:38:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39168
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab0FPUin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:38:43 -0400
Date: Wed, 16 Jun 2010 13:38:54 -0700 (PDT)
Message-Id: <20100616.133854.183053376.davem@davemloft.net>
To: kyle@mcmartin.ca
Cc: vst@vlnb.net, sparclinux@vger.kernel.org, simone.ricci@gmail.com,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Nick.Couchman@seakr.com
Subject: Re: Error "Unknown relocation: 36" on module load on Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100616192257.GW20317@bombadil.infradead.org>
References: <AANLkTimuv7nOlcGFxqPZlwcAjLmFMiLAvbA5O7F32Wbg@mail.gmail.com>
	<4C192085.2090404@vlnb.net>
	<20100616192257.GW20317@bombadil.infradead.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@mcmartin.ca>
Date: Wed, 16 Jun 2010 15:22:57 -0400

> arch/sparc/kernel/module.c needs to be patched to support the new
> relocation type... Based on binutils/gas/config/tc-sparc.c and gold's
> sparc config this looks to be the same as the hi22 reloc...
> 
> Can you test the following patch?

This change is incorrect.

LM22 relocations do not get emitted for the "medlow" code model, which
is what is explicitly specified on the kernel compiler command line
for sparc64 via "-mcmodel=medlow".

Someone this person is using incorrect CFLAGS when building their
module, and that's why they have this problem, because the compiler's
default code model on sparc64 can generate those relocations.
