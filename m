Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab1JQS2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:28:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55684 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818Ab1JQS2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:28:20 -0400
Subject: Re: [PATCH v5 10/10] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <4E9C5A4D.7090802@gmail.com>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
	 <1318848017-12301-11-git-send-email-matt@console-pimps.org>
	 <4E9C5A4D.7090802@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 19:28:17 +0100
Message-ID: <1318876097.23581.125.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 18:39 +0200, Maarten Lankhorst wrote:
> > +		if (options_size) {
> > +			if (options_size > hdr->cmdline_size)
> > +				options_size = hdr->cmdline_size;
> > +
> > +			options_size++;	/* NUL termination */
> > +
> > +			status = low_alloc(options_size, 1, &cmdline);
> > +			if (status != EFI_SUCCESS)
> > +				goto fail;
> Shouldn't this be options_size + 1?

Nope. Notice the options_size++ above the allocation.

> > +
> > +			s1 = (u8 *)(unsigned long)cmdline;
> > +			s2 = (u16 *)options;
> > +
> > +			for (i = 0; i < options_size - 1; i++)
> > +				*s1++ = *s2++;

And the options_size - 1 here.

> > +
> > +			*s1 = '\0';
> For this null character..

So this should all work OK.

-- 
Matt Fleming, Intel Open Source Technology Center

