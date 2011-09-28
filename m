Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1I1Oc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab1I1Oc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:32:57 -0400
Subject: Re: [PATCH v3 05/24] C6X: build infrastructure
From: Mark Salter <msalter@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 28 Sep 2011 10:32:51 -0400
In-Reply-To: <201109281523.15680.arnd@arndb.de>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
	 <1317155405-26235-6-git-send-email-msalter@redhat.com>
	 <201109281523.15680.arnd@arndb.de>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1317220372.2580.68.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 15:23 +0200, Arnd Bergmann wrote:
> On Tuesday 27 September 2011, Mark Salter wrote:
> > +comment "Board Selection"
> > +choice
> > +       prompt "Board"
> > +       help
> > +         This option specifies the specific board for which the kernel will be
> > +         compiled.
> > +
> > +config BOARD_DSK6455
> > +       bool "DSK6455"
> > +       select SOC_TMS320C6455
> > +
> > +config BOARD_EVM6457
> > +       bool "EVM6472"
> > +       select SOC_TMS320C6457
> > +
> > +config BOARD_EVM6472
> > +       bool "EVM6472"
> > +       select SOC_TMS320C6472
> > +
> > +config BOARD_EVM6474
> > +       bool "EVM6474"
> > +       select SOC_TMS320C6474
> > +
> > +endchoice
> 
> This really wants to be a flat list instead of a "choice" statement,
> so you can build a kernel for multiple boards at once. Is there a
> reason why this is not possible right now?

This is just left over from the time before device trees. I'll take
the BOARD_foo configs out completely. Its just a matter of selecting
the SOC in the defconfig rather than the board.

> 
> Also, how different are these boards and socs still? Since you are
> based on device trees for hardware configuration, do you actually
> need the options at all?

The BOARD configs can go. The SOC configs will go out when clkdev
stuff gets reworked when generic clock bindings are available.

--Mark



