Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab0HZKOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 06:14:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64532 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0HZKOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 06:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HaWquwJ/gaCAhdskwH5oKmKYY/g0AQREI2hO2wH3nCjy/k6D84sCfCY7qyMWFej/cJ
         0E5D8IkLsDa5Z+Q7BgC7hjAlZDE2+aijHlW/Bsntili2/iiGN7Fqz9vIqOtJsogmPEMZ
         yt1MoLtG29c33vMDH3zttWa7SKQGehxIR8rYA=
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Andy Grover <andy.grover@oracle.com>
In-Reply-To: <20100820025749.GB4879@redhat.com>
References: <20100817025954.GA12366@nowhere>
	 <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
	 <20100817083945.GA12022@swordfish.minsk.epam.com>
	 <AANLkTik-4S_=L5FLhMfommf5Umd0xO+h4QP9uoxwrgFE@mail.gmail.com>
	 <20100817092407.GB12022@swordfish.minsk.epam.com>
	 <AANLkTikjR1nC3DYdvSw=FEmAVZ98=ju2RNq-MF1L7U3u@mail.gmail.com>
	 <20100817103948.GA5352@swordfish.minsk.epam.com>
	 <20100817131320.GX4879@redhat.com> <20100818024802.GA24748@nowhere>
	 <20100818130156.43a183d9.akpm@linux-foundation.org>
	 <20100820025749.GB4879@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 13:14:31 +0300
Message-ID: <1282817671.4338.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 22:57 -0400, Don Zickus wrote: 
> On Wed, Aug 18, 2010 at 01:01:56PM -0700, Andrew Morton wrote:
> > The surprise new requirement that touch_nmi_watchdog() be called from
> > non-preemptible code does seem to make sense IMO.  It's hard to see why
> > anyone would be touching the watchdog unless he's spinning in irqs-off
> > code.  Except, of course, when we have a utility function which can be
> > called from wither irqs-on or irqs-off: acpi_os_stall().
> > 
> > That being said, it's not good to introduce new API requirements by
> > accident!  An audit of all callers should first be performed, at least.
> > 
> > 
> > The surprise new requirement that touch_softlockup_watchdog() be called
> > from non-preemptible code doesn't make sense IMO.  If I have a piece of
> > code in the kernel which I expect to sit in TASK_UNINTERRUPTIBLE state
> > for three minutes waiting for my egg to boil, I should be able to do
> > that and I should be able to touch the softlockup detector without
> > needing to go non-preemptible.
> 
> Ok, so here is my patch that syncs the touch_*_watchdog back in line with
> the old semantics.  Hopefully this will undo any harm I caused.

Was this patch forgotten?

Best regards,
Maxim Levitsky

