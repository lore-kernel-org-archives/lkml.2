Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab2FZXpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:45:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40480 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab2FZXpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:45:38 -0400
MIME-Version: 1.0
In-Reply-To: <4FEA2D85.60002@redhat.com>
References: <1340742778-11282-1-git-send-email-fes@google.com>
	<4FEA1E2E.4020806@redhat.com>
	<CAK+C7kWKtoYC=1fBQ45RTFfNc3p2PwZbLMOefMTtzOfsqe_k8w@mail.gmail.com>
	<4FEA2D85.60002@redhat.com>
Date: Tue, 26 Jun 2012 16:45:36 -0700
Message-ID: <CAK+C7kVHeUz7nUV1vtSHrK6vXorLsZoos82NFm0P0Ux0rEOZGQ@mail.gmail.com>
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
From: Frank Swiderski <fes@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mikew@google.com,
        Ying Han <yinghan@google.com>, Rafael Aquini <aquini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 2:45 PM, Rik van Riel <riel@redhat.com> wrote:
> On 06/26/2012 05:31 PM, Frank Swiderski wrote:
>>
>> On Tue, Jun 26, 2012 at 1:40 PM, Rik van Riel<riel@redhat.com>  wrote:
>
>
>>> The code looks good to me, my only worry is the
>>> code duplication. We now have 5 balloon drivers,
>>> for 4 hypervisors, all implementing everything
>>> from scratch...
>>
>>
>> Do you have any recommendations on this?  I could (I think reasonably
>> so) modify the existing virtio_balloon.c and have it change behavior
>> based on a feature bit or other configuration.  I'm not sure that
>> really addresses the root of what you're pointing out--it's still
>> adding a different implementation, but doing so as an extension of an
>> existing one.
>
>
> Ideally, I believe we would have two balloon
> top parts in a guest (one classical balloon,
> one on the LRU), and four bottom parts (kvm,
> xen, vmware & s390).
>
> That way the virt specific bits of a balloon
> driver would be essentially a ->balloon_page
> and ->release_page callback for pages, as well
> as methods to communicate with the host.
>
> All the management of pages, including stuff
> like putting them on the LRU, or isolating
> them for migration, would be done with the
> same common code, regardless of what virt
> software we are running on.
>
> Of course, that is a substantial amount of
> work and I feel it would be unreasonable to
> block anyone's code on that kind of thing
> (especially considering that your code is good),
> but I do believe the explosion of balloon
> code is a little worrying.
>

Hm, that makes a lot of sense.  That would be a few patches definitely
worth doing, IMHO.  I'm not entirely sure how I feel about inflating
the balloon drivers in the meantime.  Sigh, and I didn't even mean
that as a pun.

fes
