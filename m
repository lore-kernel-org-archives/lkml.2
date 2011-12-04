Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1LDQeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 11:34:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592Ab1LDQeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 11:34:00 -0500
Message-ID: <4EDBA0F0.4000907@redhat.com>
Date: Sun, 04 Dec 2011 18:33:52 +0200
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
References: <20111201075847.GA5479@redhat.com> <1322726977.3259.3.camel@lappy> <20111201102640.GB8822@redhat.com> <87zkfbre9x.fsf@rustcorp.com.au> <1322913028.3782.4.camel@lappy> <4EDB5EF0.2010909@redhat.com> <20111204120132.GB18758@redhat.com> <4EDB624A.3030403@redhat.com> <20111204151148.GA21851@redhat.com> <4EDB8EEB.4070309@redhat.com> <20111204160053.GA22501@redhat.com>
In-Reply-To: <20111204160053.GA22501@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2011 06:00 PM, Michael S. Tsirkin wrote:
> >  If you
> > copy descriptors, then it goes away.
>
> The avail ring could go away. used could if we make descriptors
> writeable. IIUC it was made RO in the hope that will make it
> easier for xen to adopt. Still relevant?

You mean RO from the consumer side?  Why can't Xen do that?

> > That does suck.  Are there issues in increasing the ring size?  Or
> > making it discontiguous?
>
> discontiguous ring is what indirect is, basically.

No, discontiguous is more cache and prefetch friendly.  With vmap(), the
code doesn't even change.


-- 
error compiling committee.c: too many arguments to function

