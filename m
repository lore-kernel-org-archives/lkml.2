Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab1AIUcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 15:32:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58061 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1AIUco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 15:32:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/2] kbuild: asm-generic support
Date: Sun, 9 Jan 2011 21:31:27 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-kbuild" <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
References: <20110108130302.GA21698@merkur.ravnborg.org> <20110109192707.GA12387@merkur.ravnborg.org> <20110109192907.GA12403@merkur.ravnborg.org>
In-Reply-To: <20110109192907.GA12403@merkur.ravnborg.org>
MIME-Version: 1.0
Message-Id: <201101092131.27694.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:EEVznMAZmUM5rAnnFEtDoE7I1R5VY853Sb77rbqp/j9
 r+VIMBCnzh4uGYd6w/wrQrVXa280J6kGOTZJN5/ytfGjM7djYh
 o1tcMZ5MIbddVsSLbJjZoNbqmJnd2F3w/WUsjFk4iyutPoTzKf
 XFOAgrKR97bQytmnLG40n3JcjZR7GqugEkkSdlm/Td/sNNTbNv
 D72PIOaiw2UX37VVqMw0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is an increasing amount of header files
> shared between individual architectures in asm-generic.
> To avoid a lot of dummy wrapper files that just
> include the corresponding file in asm-generic provide
> some basic support in kbuild for this.

Looks almost perfect to me now.

I was about to reply with Reviewed-by, but then it occurred to me
that scripts/asm-generic.sh is really much more complicated
than doing the same in Makefile syntax.

You already create the wrapper files during headers-install, so why
not also create them from make, where we already have access to the
file lists in a convenient format.

Or is there a problem getting at stuff defined in the Kbuild files
from the prepare stage?

	Arnd
