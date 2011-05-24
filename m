Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab1EXXe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:34:59 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:63694 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726Ab1EXXe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:34:58 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
In-Reply-To: <4DDC3A1A.6030006@zytor.com>
References: <1306269105.21443.20.camel@dan>  <4DDC31DF.5010303@zytor.com>
	 <1306278296.1921.10.camel@dan>  <4DDC3A1A.6030006@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 19:34:49 -0400
Message-ID: <1306280089.1921.18.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 16:07 -0700, H. Peter Anvin wrote:
> On 05/24/2011 04:04 PM, Dan Rosenberg wrote:
> > 
> >> 2. Not introduce a performance regression (we avoid locating in the
> >>    bottom 16 MiB for performance reasons, except on very small systems);
> > 
> > I altered the boot code so that it uses CONFIG_PHYSICAL_START, which
> > defaults to 16 MiB, as a lower bound on location.  So nothing will ever
> > get loaded below there, and I still can take advantage of higher
> > alignment granularity.  Are there other problems I'm not anticipating?
> > 
> 
> Please look at the discussion as to what led us to do things this way.
> 

Would you be able to point me to said discussion?  The only thing I can
find is this:

http://marc.info/?l=linux-kernel&m=124173552516435&w=2

This set PHYSICAL_START at 16 MB and alignment at 2/4 MB.  Then, three
days later, this was committed:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ceefccc93932b920a8ec6f35f596db05202a12fe

This sets the alignment to 16 MB, with the only justification being that
relocatable kernels also need to start above 16 MB.

Thanks,
Dan

