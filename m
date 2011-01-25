Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab1AYQCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:02:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab1AYQCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:02:43 -0500
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk
 upon panic
From: James Bottomley <James.Bottomley@suse.de>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86-ML <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20110125153649.GA11386@laptop>
References: <20110125134748.GA10051@laptop> <20110125140948.GA26762@elte.hu>
	 <20110125153649.GA11386@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 11:02:35 -0500
Message-ID: <1295971355.4955.104.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 17:36 +0200, Ahmed S. Darwish wrote:
> The complete __roadblock__ I'm currently facing though is restoring the disk
> controllers to the state originally setup by the BIOS Power-on self-test (POST).
> I hope such re-initialization is even technically feasible.
> 
> Without such re-initialization, we'll just be risking the BIOS code exploding.
> That was the case in the 5-minute hang described in the cover sheet (PATCH #0).

So this is the bit that's not really technically feasible.  BIOS tends
to run storage devices in a very primitive way (so it takes basic
settings, for example and sets the device up for one particular channel
of access).  When preparing the device for an operating system, we have
to blow away all the bios stuff and put it into a more generally
performant mode (this isn't just the storage per se, it's also the
interrupt and routing).  Unfortunately, currently, we don't bother to
save the settings the BIOS was using, so there's no way to reinitialise
the device back to bios without an effective reboot.  Most BIOS doesn't
seem to contain storage re-POST code that's usable (it's all embedded in
the boot sequence).

James


