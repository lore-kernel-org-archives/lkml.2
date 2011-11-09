Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab1KIKen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:34:43 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:38448 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754695Ab1KIKem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:34:42 -0500
Date: Wed, 9 Nov 2011 10:34:33 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: "Gleb O. Raiko" <raiko@niisi.msk.ru>
Cc: Al Cooper <alcooperx@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Kernel hangs occasionally during boot.
Message-ID: <20111109103432.GA27378@linux-mips.org>
References: <y>
 <1320764341-4275-1-git-send-email-alcooperx@gmail.com>
 <20111108175532.GA15493@linux-mips.org>
 <4EBA2E65.3010009@niisi.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBA2E65.3010009@niisi.msk.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 11:40:21AM +0400, Gleb O. Raiko wrote:

> On 08.11.2011 21:55, Ralf Baechle wrote:
> >but we may need another hazard barrier to
> >replace back_to_back_c0_hazard().
> Urgently. We need some ticks to wait until counter state machine has
> been updated. The amount of ticks may occasionally be the same as in
> case of back_to_back_hazard for some cpus. It's completely different
> for others, I sure. Original compare_change_hazard waits up to 12
> ticks for r4k. While I don't think this amount should depend on
> irq_disable_hazard as old code assumes, we may still need 12 or so
> ticks for old cpus.

Hmm...  Looking at the R4000 manual which generall has the longest
pipeline hazards, mtc0 gets executed at stage 7, interrupts get sampled
at stage 3 meaning there is a (7 - 3 - 1) = 3 cycles hazard.  Does
that one statisfy your constraints?  Or are additional cycles needed
for a hazard that's generated outside of the CPU's pipeline?

  Ralf
