Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2BUWTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:19:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:39312 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab2BUWTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:19:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="110548125"
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 21 Feb 2012 14:19:35 -0800
In-Reply-To: <CA+55aFzSKR76rVAXQWjKmjmSPVu8XeULh5g864hbOgq6WA4foQ@mail.gmail.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
	 <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org>
	 <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org>
	 <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
	 <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org>
	 <1329861273.29790.261.camel@sbsiddha-desk.sc.intel.com>
	 <CA+55aFzSKR76rVAXQWjKmjmSPVu8XeULh5g864hbOgq6WA4foQ@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1329862775.29790.268.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 13:57 -0800, Linus Torvalds wrote:
> On Tue, Feb 21, 2012 at 1:54 PM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> >
> > Reviewing this code, I think we need to set the 'last_cpu' to an invalid
> > number in the fpu_alloc too. Appended is the patch.
> 
> I cleared fpu_counter in copy_thread() instead.

Hmm, didn't pay attention to that patch. Too many patches ;(

> Doing this in fpu_alloc() isn't necessarily a bad idea, though.

yes, I think we should do this in fpu_alloc() or bit more explicitly by
updating 'last_cpu' in copy_thread().

Someone experimenting with removing fpu pre-load may not realize this
subtle issue.

thanks,
suresh




