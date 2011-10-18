Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab1JRBdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:33:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12125 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab1JRBdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:33:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=ZNvV3aOHFTduPPoMObite3uoPvtmJDKGuEUG5ecjaHixbiEPEDFCtY2PD11okJGaQ
	HPkrFikBtaRy1rEiamPUQ==
Date: Mon, 17 Oct 2011 18:33:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Henrik Grindal Bakken <henribak@cisco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Avoid using hardcoded values in kernel/sys.c
In-Reply-To: <CA+55aFxj+heCCoQx0ecVyCE0b5e3fGpAUPSUH8K7E=TyRzNSUg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1110171832060.13515@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1110171752300.19024@chino.kir.corp.google.com> <CA+55aFxj+heCCoQx0ecVyCE0b5e3fGpAUPSUH8K7E=TyRzNSUg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-464578838-1318901591=:13515"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-464578838-1318901591=:13515
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 17 Oct 2011, Linus Torvalds wrote:

> > The release field of struct new_utsname may always change, so avoid
> > hardcoded values when setting up a buffer to copy to it.
> 
> This patch is totally bogus.
> 
> > +static int override_release(char __user *release)
> >  {
> > +       const int len = sizeof(release);
> 

Right, I meant to pass the struct in and use sizeof(release->name), but I 
was under the impression that wouldn't count as a variable length array or 
be compiled as such by ISO99 standards because it's a constant expression 
(as the standard says is not variable length).
--397155492-464578838-1318901591=:13515--
