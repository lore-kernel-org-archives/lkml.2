Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0IEJiI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 05:38:08 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:57545 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab0IEJiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 05:38:06 -0400
Date: Sun, 5 Sep 2010 10:37:59 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Sven Joachim <svenjoac@gmx.de>, Hugh Dickins <hughd@google.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
Message-ID: <20100905093758.GB23589@sucs.org>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org> <89k83a$9hv9li@azsmga001.ch.intel.com> <AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com> <alpine.LSU.2.00.1009041244440.3044@sister.anvils> <87vd6ls0jd.fsf@turtle.gmx.de> <20100904224453.GA31664@sucs.org> <4C834DB5.3070702@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C834DB5.3070702@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 10:58:45AM +0300, Pekka Enberg wrote:
>
> I haven't heard of this problem. Is it reported on LKML? Is it a  
> regression from 2.6.35?

Yes I did report it on the LKML (the initial report is
http://lkml.org/lkml/2010/8/23/432 ) but I've being trying to track
other reports mentioning similar symptoms too (e.g. I mentioned the
previous link to you in http://lkml.org/lkml/2010/8/29/52 ) but it seems
like they might different. The Intel guys spent a good while doing
investigations and having me try patches which is what led to a half fix
( http://marc.info/?l=linux-kernel&m=128267471015593&w=2 ) but there are
still situations which show problems (e.g. after suspend to ram).  I've
also created a bug on the xorg bugzilla (
http://bugs.freedesktop.org/show_bug.cgi?id=29857 ) which has more
debugging information. The problem is there are so many symptoms but
worse, the triggers are weird/marginal so it's hard to tell if it has
been fixed.

Yes it is a regression from 2.6.35 see
http://lkml.org/lkml/2010/8/24/132 where I bisected it down to commit
9d0498a2bf7455159b317f19531a3e5db2ecc9c4 .

-- 
Sitsofe | http://sucs.org/~sits/
