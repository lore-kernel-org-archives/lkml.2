Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab2C1VQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:16:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab2C1VQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:16:07 -0400
Date: Wed, 28 Mar 2012 16:15:59 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, stable@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>, janek <jan0x6c@gmail.com>
Subject: Re: [PATCH] ASPM: Fix pcie devices with non-pcie children
Message-ID: <20120328211559.GA10511@burratino>
References: <1332857861-11562-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332857861-11562-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

Matthew Garrett wrote:

> Commit 4949be16822e92a18ea0cc1616319926628092ee changed the behaviour of
> pcie_aspm_sanity_check() to always return 0 if aspm is disabled, in order
> to avoid cases where we changed ASPM state on pre-PCIe 1.1 devices. This
> skipped the secondary function of pcie_aspm_sanity_check which was to avoid
> us enabling ASPM on devices that had non-PCIe children, causing us to hit
> a BUG_ON later on. Move the aspm_disabled check so we continue to honour
> that scenario.

janek (cc-ed) never experienced the BUG_ON.  Instead, starting with
v3.3 and v3.2.12 his hard disk using the pata_jmicron driver was not
detected during boot-up, resulting in the message "gave up waiting for
root device" and a failed boot.

Found in

  Debian kernel 3.2.12-1
  Debian kernel 3.3-1~experimental.1
  Upstream 3.3
  Linus's "master" as of 2012-03-28

Based on the thread [1] we blamed 4949be16822.  janek tried the patch
above on top of linus's "master".  The result:

> Thanks. This patch fixes the problem.

In other words, this gets the pata_jmicron driver to enumerate its
drives again, a positive effect that wasn't even advertised in the
commit message. ;-)  Thanks for writing it.

Sincerely,
Jonathan

[1] http://thread.gmane.org/gmane.linux.kernel/1271264/focus=1271785
