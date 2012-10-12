Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2JLXRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 19:17:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60726 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab2JLXRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 19:17:23 -0400
Date: Sat, 13 Oct 2012 01:17:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org, Ma Ling <ling.ma@intel.com>, x86@kernel.org
Subject: Re: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Message-ID: <20121012231719.GA21198@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
	Ma Ling <ling.ma@intel.com>, x86@kernel.org
References: <20121012210257.11451.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121012210257.11451.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 05:02:57PM -0400, George Spelvin wrote:
> Here are some Phenom results for that benchmark.  The average time
> increases from 700 to 760 cycles (+8.6%).

I was afraid something like that would show up.

Btw, in looking at this more and IINM, we use the REP MOVSQ version on
AMD anyway because of X86_FEATURE_REP_GOOD being set on some K8 and
everything from F10h on.

So, actually this µbenchmark should be comparing the REP MOVSQ case too
and the changes to the unrolled copy_page shouldn't concern AMD boxes
actually...

Hmm.

-- 
Regards/Gruss,
    Boris.
