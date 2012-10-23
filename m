Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab2JWTmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:42:45 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:12742 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab2JWTmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:42:44 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr0M7jF20=
X-RZG-CLASS-ID: mo00
Date: Tue, 23 Oct 2012 21:42:33 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Subject: when to switch from early_ioremap to ioremap
Message-ID: <20121023194233.GA23588@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21.rev5555 (2012-07-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To obtain an address to a PFN in init_hypervisor_platform (called from
arch/x86/kernel/setup.c:setup_arch) I use early_ioremap. Later the
address to that PFN needs to be obtained with ioremap, and early_iounmap
needs to be called on the first address.

When is the time to obtain and use the new pointer, and to release to
old pointer? Right now I do that in the pci-device setup code, which
happens to work. Unfortunately early_ioremap is not mentioned in
Documentation/, hence the question.

Olaf
