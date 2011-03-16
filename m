Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1CPWgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 18:36:38 -0400
Received: from science.horizon.com ([71.41.210.146]:26737 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751446Ab1CPWgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 18:36:33 -0400
Date: 16 Mar 2011 18:36:31 -0400
Message-ID: <20110316223631.20091.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, rientjes@google.com
Subject: Re: [PATCH 5/8] mm/slub: Factor out some common code.
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mpm@selenic.com, penberg@cs.helsinki.fi
In-Reply-To: <alpine.DEB.2.00.1103161352150.11002@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Patches that you would like to propose but don't think are ready for merge 
> should have s/PATCH/RFC/ done on the subject line.

You're right; I should have.  I blame git-format-patch's defaults, but mea culpa.
(Now I know about the --subject-prefix=RFC option!)

> You deliberately created a helper function to take an unsigned int when 
> the actuals being passed in are all unsigned long to trigger a discussion 
> on why they are unsigned long?

Er, no, I'm not that Machiavellian.
I deliberately did it because it was obvious that the flags would always
fit into an "unsigned", so I didn't need "unsigned long".

(Actually, I owe you an apology; when writing that e-mail, I remember
thinking "I should go back and clarify that statement", but forgot before
hitting send.)

> unsigned long uses the native word size of the architecture which can 
> generate more efficient code; we typically imply that flags have a limited 
> size by including leading zeros in their definition for 32-bit 
> compatibility:

Um, can you name a (64-bit) architecture on which 32-bit is more
expensive than 64-bit?  On x86-64, it's potentially cheaper, and even
the infamous Alpha 21064 has no penalty for 32-bit accesses.  SPARC,
MIPS, PPC, Itanium, what else?  I don't know about z/ARchitecture,
but given the emphasis on backward compatibility in IBM's mainframes,
it seems hard to imagine.
