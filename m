Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0HSQfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 12:35:47 -0400
Received: from mx3.sophos.com ([74.202.89.160]:35196 "EHLO mx3.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab0HSQfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 12:35:45 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: struct fanotify_event_metadata
Date: Thu, 19 Aug 2010 17:35:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Andreas Schwab <schwab@linux-m68k.org>, Eric Paris <eparis@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <m21va1ozqx.fsf@igel.home> <201008191644.29299.tvrtko.ursulin@sophos.com> <201008191807.02031.agruen@suse.de>
In-Reply-To: <201008191807.02031.agruen@suse.de>
MIME-Version: 1.0
Message-ID: <201008191735.41985.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 19/08/2010 17:35:42,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 19/08/2010 17:35:42,
	Serialize complete at 19/08/2010 17:35:42
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 Aug 2010 17:07:01 Andreas Gruenbacher wrote:
> On Thursday 19 August 2010 17:44:29 Tvrtko Ursulin wrote:
> > On Saturday 14 Aug 2010 18:44:38 Andreas Schwab wrote:
> > > The pid field of struct fanotify_event_metadata has 64 bits which looks
> > > excessive.  Wouldn't it make sense to make it 32 bits and swap it with
> > > the mask field?  That would avoid the unaligned mask field, and remove
> > > the need for the packed attribute.
> >
> > No one seems to have picked up on this what I thought was an obvious good
> > idea.
>
> Yes, the pid field should be shrunk; it is a 32-bit value in user-space
> even on 64-bit platforms.  I also don't see that we'll ever need a 64-bit
> mask actually.

You could be probably right since even though at the moment there are 23 bits
already allocated (purely mechanical count), protocol is future proof to
expand it later if needed.

On the other hand since it the same mask as in the syscall (where we really
want to have enough width top begin with) it is nice that both user interfaces
agree on the field width and it is probably a negligible overhead anyway.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
