Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587Ab0FPUfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:35:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36532
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab0FPUf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:35:29 -0400
Date: Wed, 16 Jun 2010 13:35:40 -0700 (PDT)
Message-Id: <20100616.133540.189696272.davem@davemloft.net>
To: vst@vlnb.net
Cc: sparclinux@vger.kernel.org, simone.ricci@gmail.com,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Nick.Couchman@seakr.com
Subject: Re: Error "Unknown relocation: 36" on module load on Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C192085.2090404@vlnb.net>
References: <AANLkTimuv7nOlcGFxqPZlwcAjLmFMiLAvbA5O7F32Wbg@mail.gmail.com>
	<4C192085.2090404@vlnb.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladislav Bolkhovitin <vst@vlnb.net>
Date: Wed, 16 Jun 2010 23:05:41 +0400

> We in SCST project have a very strange problem on Sparc. Our main
> module scst.ko, if built as a module out of the kernel tree, can't be
> loaded and "modprobe scst" returns:
> 
> FATAL: Error inserting scst
> (/lib/modules/2.6.26-2-sparc64/extra/scst.ko): Invalid module format
> 
> The following message is immediately spit out by the kernel:
> [ 1686.676534] module scst: Unknown relocation: 36

You're building the module with incorrect compiler flags, in
particular somehow the "-mcmodel=medlow" option is not getting passed
into the module build and thus the wrong code model is being used to
build the module.

There are a host of other sparc64 specific compiler options that must
be present for a correct build as well.  The only way to get it done
correctly is to properly inherit the option settings made by
arch/sparc/Makefile and friends in the kernel tree.
