Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab1FFT0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:26:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab1FFT0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:26:09 -0400
Date: Mon, 6 Jun 2011 21:25:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to
 feature-removal-schedule
Message-ID: <20110606192544.GA28947@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>
 <20110606144414.GA30348@elte.hu>
 <4DED239B.8177.13CDBA86@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DED239B.8177.13CDBA86@pageexec.freemail.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> [...] it goes like 'I am not willing to do A because it would help 
> script kiddies but I'd rather do B that would help script kiddies'. 
> with A = 'disclose security bugs' and B = 'keep the last roadblock 
> that prevents full ASLR'.

No, that's wrong, the logic goes like this:

  if i do A then it has X1 advantages and Y1 disadvantages.
  if i do B then it has X2 advantages and Y2 disadvantages.

The Y1 and Y2 set of disadvantages can both include "making it easier 
for script kiddies" but the sets of advantages and disadvantages can 
also include MANY OTHER considerations, making the decision unique in 
each case.

To translate it to this specific case (extremely simplifed, so please 
don't nit-pick that my descriptions of advantages and disadvantages 
are not precise nor complete):

 A) "i put a zero day exploit and a CVE code into a changelog"

     Advantages: - it describes the problem more fully

  Disadvantages: - it makes it easier for people (including script kiddies) do harm faster
                 - creates a false, misleading category for "security bugs"

 B) "i obfuscate the vsyscall page"

     Advantages: - it makes it statistically harder for people (including script kiddies) to do harm

  Disadvantages: - it reduces the incentive to fix *real* security bugs
                 - complicates the code

Do you see how A) and B) are not equivalent at all? Different cases, 
different attributes, different probabilities and different 
considerations.

> but it's very simple logic Ingo.

Please drop the condescending tone, i think it should be clear to you 
by now that i have a good basis to disagree with you.

Thanks,

	Ingo
