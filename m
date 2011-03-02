Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab1CBKmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:42:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57679 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab1CBKmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:42:07 -0500
Date: Wed, 2 Mar 2011 11:41:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: shaohua.li@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [tip:x86/mm] x86: Work around old gas bug
Message-ID: <20110302104144.GB25608@elte.hu>
References: <201103012352.p21NqRN1006974@imap1.linux-foundation.org>
 <tip-253d89d3dd6b65595f317e5f1ecef43aa207a3a0@git.kernel.org>
 <4D6E2B8B02000078000347C0@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E2B8B02000078000347C0@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 02.03.11 at 09:42, tip-bot for Shaohua Li <shaohua.li@intel.com> wrote:
> > Commit-ID:  253d89d3dd6b65595f317e5f1ecef43aa207a3a0
> > Gitweb:     
> > http://git.kernel.org/tip/253d89d3dd6b65595f317e5f1ecef43aa207a3a0 
> > Author:     Shaohua Li <shaohua.li@intel.com>
> > AuthorDate: Tue, 1 Mar 2011 15:52:26 -0800
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 2 Mar 2011 08:16:23 +0100
> > 
> > x86: Work around old gas bug
> > 
> > pre-2.16 binutils works fine, post-2.16 binutils works fine, but 2.16 broke 
> > again:
> > 
> >  > arch/x86/kernel/entry_64.S: Assembler messages:
> >  > arch/x86/kernel/entry_64.S:984: Error: junk at end of line, first 
> > unrecognized character is `1'
> >  > [...]
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Jan Beulich <jbeulich@novell.com>
> > LKML-Reference: <201103012352.p21NqRN1006974@imap1.linux-foundation.org>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Ingo, didn't you write yesterday that this looks unacceptable to you?

Yes, and we can push this to Linus only once that's been resolved. I trust you to 
queue up the real solution or come up with good reasons why that is not possible for 
GAS 2.16. (at which point we'll just have to live with the ugliness, up to the point 
we decide to deprecate binutils 2.16.)

Meanwhile, what i hate more than ugly code repetition is code that does not build at 
all on akpm's test environment ;-)

Thanks,

	Ingo
