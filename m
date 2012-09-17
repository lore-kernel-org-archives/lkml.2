Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab2IQK65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:58:57 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:35712 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab2IQK64 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 17 Sep 2012 06:58:56 -0400
Message-Id: <50571E8B020000780009BBB2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 17 Sep 2012 11:58:51 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@kernel.org>
Cc: <tglx@linutronix.de>, <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [tip:x86/asm] x86: Prefer TZCNT over BFS
References: <504DEA1B020000780009A277@nat28.tlf.novell.com>
 <tip-5870661c091e827973674cc3469b50c959008c2b@git.kernel.org>
 <CA+55aFxs3FUETs830p-ow29RDibu9=d77gxqaueX-wZyr8-40A@mail.gmail.com>
 <5056F04B020000780009BAF9@nat28.tlf.novell.com>
 <20120917100046.GA32463@gmail.com>
In-Reply-To: <20120917100046.GA32463@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.09.12 at 12:00, Ingo Molnar <mingo@kernel.org> wrote:
> Linus's suggestion is to introduce CONFIG_X86_TZCNT as an add-on 
> patch that cleans up and documents what this is all about.

It wasn't just this he complained about. Plus I don't think the
suggested name fits the current scheme - it would imply the
instruction to be available when set, yet that's explicitly _not_
a requirement. So X86_USE_TZCNT would seem a better fit
to me.

> Would you be willing to do such a patch?

If that was the only change needed, yes (hesitantly, as I
personally don't think introducing Kconfig options that have
only a single usage point is really useful). But the complaint
regarding this also getting enabled for old CPUs (which in
my understanding is the purpose of the GENERIC options)
is something that I wouldn't be willing to address (unless I'm
told these two options have another purpose), and thus I
would expect the resulting patch to still get vetoed by Linus
(which in essence means it would be wasted time to try to
address the other complaint).

Jan

