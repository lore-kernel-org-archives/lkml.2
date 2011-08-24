Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab1HXV5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:57:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab1HXV5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:57:23 -0400
MIME-Version: 1.0
In-Reply-To: <3d7aea62fac48dd6e2da236d86234113fcd78178.1314221624.git.jeremy.fitzhardinge@citrix.com>
References: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
 <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <3d7aea62fac48dd6e2da236d86234113fcd78178.1314221624.git.jeremy.fitzhardinge@citrix.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Aug 2011 14:56:59 -0700
Message-ID: <CA+55aFwEH16JAynxQzNTff0ikGnON9jq1mJOx1doDASV2a2fpg@mail.gmail.com>
Subject: Re: [PATCH 07/12] x86: use cmpxchg_flag() where applicable
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I see nothing horrible in this series.

The one reaction I have is that the cmpxchg_flag() thing returns an
8-bit value, but then a lot of the users end up having to extend it to
a full "int" purely for calling convention reasons (eg I think
'down_write_trylock()' will have 'sete + movzl' - not a new problem,
but since the whole point was to remove extraneous instructions and we
no longer have the silly 'testl', it now annoys me more).

So it seems a bit sad. But I guess it doesn't really matter.

                          Linus
