Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1LDMGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 07:06:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab1LDMGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 07:06:43 -0500
Message-ID: <4EDB624A.3030403@redhat.com>
Date: Sun, 04 Dec 2011 14:06:34 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect
 descriptors
References: <20111129145451.GD30966@redhat.com> <4ED4F30F.8000603@redhat.com> <1322669511.3985.8.camel@lappy> <87wrahrp0u.fsf@rustcorp.com.au> <20111201075847.GA5479@redhat.com> <1322726977.3259.3.camel@lappy> <20111201102640.GB8822@redhat.com> <87zkfbre9x.fsf@rustcorp.com.au> <1322913028.3782.4.camel@lappy> <4EDB5EF0.2010909@redhat.com> <20111204120132.GB18758@redhat.com>
In-Reply-To: <20111204120132.GB18758@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2011 02:01 PM, Michael S. Tsirkin wrote:
> > 
> > How much better?
> > 
> > I think that if indirects benefit networking, then we're doing something
> > wrong.  What's going on?  Does the ring get filled too early?  If so we
> > should expand it.
>
> The ring is physically contigious.
> With 256 entries and 64 bytes each, that's already 16K.

A descriptor is just 16 bytes.  There's also the used ring, but that's a
mistake if you have out of order completion.  We should have used copying.

16kB worth of descriptors is 1024 entries.  With 4kB buffers, that's 4MB
worth of data, or 4 ms at 10GbE line speed.  With 1500 byte buffers it's
just 1.5 ms.  In any case I think it's sufficient.

-- 
error compiling committee.c: too many arguments to function

