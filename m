Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab2JXGT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:19:59 -0400
Received: from so.liwest.at ([212.33.55.24]:8459 "EHLO so.liwest.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757507Ab2JXGT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:19:58 -0400
X-Greylist: delayed 997 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2012 02:19:58 EDT
Message-ID: <5087848D.7060400@viscovery.net>
Date: Wed, 24 Oct 2012 08:02:53 +0200
From: Johannes Sixt <j.sixt@viscovery.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jeff King <peff@peff.net>
CC: Marc Gauthier <marc@tensilica.com>, Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@ZenIV.linux.org.uk>, Chris Metcalf <cmetcalf@tilera.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "git@vger.kernel.org" <git@vger.kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Subject: Re: [PATCH] tile: support GENERIC_KERNEL_THREAD and GENERIC_KERNEL_EXECVE
References: <5082A1F1.3080303@tilera.com> <20121020153401.GT2616@ZenIV.linux.org.uk> <20121020171643.GU2616@ZenIV.linux.org.uk> <5086D432.4070008@tilera.com> <20121023184122.GZ2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210232232070.2756@ionos> <20121023205119.GA27729@sigill.intra.peff.net> <alpine.LFD.2.02.1210232307480.2756@ionos> <20121023214717.GA29306@sigill.intra.peff.net> <522C1DF17AF50042AD8AE87F7887BD3D0B60880C30@exch.hq.tensilica.com> <20121023222318.GA3055@sigill.intra.peff.net>
In-Reply-To: <20121023222318.GA3055@sigill.intra.peff.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10/24/2012 0:23, schrieb Jeff King:
> For the fold-on-rebase idea, I'd think you would want something similar,
> like setting rebase.foldNotes to "foo" to say "refs/notes/foo contains
> pseudo-headers that should be folded in like a signed-off-by".

If you are rebasing anyway, you can already use interactive rebase's
--autosquash option:

# a late ACK came in:
git commit --allow-empty -m'squash! tile: support GENERIC_

Acked-by: A U Thor <author@example.com>'

git rebase -i --keep-empty --autosquash $forkpoint

Requires git 1.7.11 for --keep-empty and requires to edit out the
'squash!...' headers when the editor appears during the rebase.

-- Hannes
