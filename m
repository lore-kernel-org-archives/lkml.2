Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab0LLDe6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 22:34:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319Ab0LLDe4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 22:34:56 -0500
MIME-Version: 1.0
In-Reply-To: <20101210173749.7ec3cc28@jbarnes-desktop>
References: <20101208213606.13026.47657.stgit@bob.kio> <20101210123008.7fed582d@jbarnes-desktop>
 <20101210123609.73c12a23@jbarnes-desktop> <201012101407.24419.bjorn.helgaas@hp.com>
 <20101210173749.7ec3cc28@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 11 Dec 2010 19:34:05 -0800
Message-ID: <AANLkTi=b5pq+RhA1DpyyRaLEQxQFOrf4aEXHrG-Qjqbt@mail.gmail.com>
Subject: Re: [PATCH 1/5] resources: add arch hook for preventing allocation in
 reserved areas
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Adam Belay <abelay@mit.edu>, Matthew Garrett <mjg@redhat.com>,
        Dan Williams <dcbw@redhat.com>, rjw@sisk.pl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 5:37 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Thanks, I'll add Dan and Rafael's tested-bys to the patches (they're
> already in my for-linus tree).  Unless Linus has a problem with them
> I'll send them over to him this weekend or Monday.

See my other email I just sent out.

I really am not going to take some totally new experimental and hacky
major PCI resource management thing this late in the -rc game. No way,
no how.

If the top-down allocator is causing regressions that cannot be fixed
by _simple_ patches, we're simply going to have to undo it. What's the
advantage of top-down? None. Not if we then need all this crap, which
we could as easily do on top of the bottom-up one WITHOUT any
regressions.

Why isn't anybody else questioning the whole basic premise here?

                    Linus
