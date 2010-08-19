Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0HSQMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 12:12:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab0HSQMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 12:12:34 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Subject: Re: struct fanotify_event_metadata
Date: Thu, 19 Aug 2010 18:07:01 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; i686; ; )
Cc: Andreas Schwab <schwab@linux-m68k.org>, Eric Paris <eparis@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <m21va1ozqx.fsf@igel.home> <201008191644.29299.tvrtko.ursulin@sophos.com>
In-Reply-To: <201008191644.29299.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191807.02031.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 August 2010 17:44:29 Tvrtko Ursulin wrote:
> On Saturday 14 Aug 2010 18:44:38 Andreas Schwab wrote:
> > The pid field of struct fanotify_event_metadata has 64 bits which looks
> > excessive.  Wouldn't it make sense to make it 32 bits and swap it with
> > the mask field?  That would avoid the unaligned mask field, and remove
> > the need for the packed attribute.
> 
> No one seems to have picked up on this what I thought was an obvious good
> idea.

Yes, the pid field should be shrunk; it is a 32-bit value in user-space even 
on 64-bit platforms.  I also don't see that we'll ever need a 64-bit mask 
actually.

Andreas
