Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2GaDfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 23:35:37 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41541 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab2GaDfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 23:35:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120730181542.GA987@jonmason-lab>
References: <1343607994-32415-1-git-send-email-jon.mason@intel.com>
	<1343607994-32415-2-git-send-email-jon.mason@intel.com>
	<CAErSpo4p_hxvCeVGqiTXVq3itXepheQZerpqRHwLvG6A7R2Lcg@mail.gmail.com>
	<20120730181542.GA987@jonmason-lab>
Date: Tue, 31 Jul 2012 11:35:33 +0800
Message-ID: <CAF8raN6M0_TWyCCzjyXZcFYP=vgFaqQg4hNmNpBxSM+D0C_Bpg@mail.gmail.com>
Subject: Re: [RFC v2 1/2] PCI-Express Non-Transparent Bridge Support
From: Jianbin Kang <kjbmail@gmail.com>
To: Jon Mason <jon.mason@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've tried to make it all generic enough that non-Intel NTBs should plug in with
> minimal changes to ntb_hw.c.  If their design is too divergent, then a slight
> redesign of ntb_hw.c might be necessary.  But from what I've seen of other
> designs on the internet, they appear to be extremely similar.  The transport and
> client drivers were written with the hardware abstracted away as much as
> possible to prevent the need to modify it for different hardware.  If there is
> anything which is Intel hardware specific, I'd be happy to change it to make it
> more generic.
  In ntb_process_tx(), ntb uses hard-coding 'memcpy_toio' to copy data
to remote.
  Is it better to provide a function pointer like 'tx()' and call qp->tx().
  memcpy_toio is a slow operation. Some hardware can setup a dma
transfer and wait.

  IMHO, the best way is to handle tx in async mode. But it requires
lots of modification.
