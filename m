Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1KBWUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 18:20:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15536 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1KBWT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 18:19:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:date:message-id:user-agent:mime-version:
	content-type:content-transfer-encoding;
	b=W28QLSPdnf+Eb1M/emmLgvdmIJ/dak1RfcWVLYUsAC2yotl3G+AXc3cm1CFybUx9F
	AnNGghZmHIQcMQOGP8scg==
Subject: [PATCH RFC 0/3] Support multiple VirtioConsoles.
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Miche Baker-Harvey <miche@google.com>, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>, xen-devel@lists.xensource.com,
        Anton Blanchard <anton@samba.org>, Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
From: Miche Baker-Harvey <miche@google.com>
Date: Wed, 02 Nov 2011 15:19:06 -0700
Message-ID: <20111102221905.9722.62090.stgit@miche.sea.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset applies to linux-next/next-20111102.

This series implements support for multiple virtio_consoles using KVM.

This patchset addresses several issues associated with trying to
establish multiple virtio consoles. 

I'm trying to start a guest via KVM that supports multiple virtual
consoles, with getty's on each, and with some being console devices.

These patches let me establish more than one VirtioConsole (I'm
running eight at the moment), and enable console output appearing on
one of them.  It still doesn't successfully generate console output on
multiple VirtioConsoles.

Let me apologise for my last patch having gotten into Linus' tree, and
leaving other people to deal with crashes.  I had meant to be asking
for guidance, but I didn't mark it as "RFC".

This series reflects the input from Konrad Rzeszutek, Amit Shah, Stephen
Boyd, and Rusty Russell.  I think we do have to limit hvc_alloc() to one
thread.

I would appreciate any comments or feedback, or accept if appropriate.

Thanks,
Miche Baker-Harvey

---

Miche Baker-Harvey (3):
      virtio_console:  Fix locking of vtermno.
      hvc_init():  Enforce one-time initialization.
      Use separate struct console structure for each hvc_console.


 drivers/char/virtio_console.c |    9 ++++++---
 drivers/tty/hvc/hvc_console.c |   33 +++++++++++++++++++++++++++++++--
 drivers/tty/hvc/hvc_console.h |    1 +
 3 files changed, 38 insertions(+), 5 deletions(-)

-- 
