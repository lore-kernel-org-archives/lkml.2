Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab1KORdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 12:33:44 -0500
Received: from claw.goop.org ([74.207.240.146]:42776 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab1KORdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 12:33:43 -0500
Message-ID: <4EC2A274.8080801@goop.org>
Date: Tue, 15 Nov 2011 09:33:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, Cyclonus J <cyclonusj@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default> <75efb251-7a5e-4aca-91e2-f85627090363@default> <20111027215243.GA31644@infradead.org> <1319785956.3235.7.camel@lappy> <CAOzbF4fnD=CGR-nizZoBxmFSuAjFC3uAHf3wDj5RLneJvJhrOQ@mail.gmail.comCAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com> <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default20111031181651.GF3466@redhat.com> <60592afd-97aa-4eaf-b86b-f6695d31c7f1@default> <20111031223717.GI3466@redhat.com> <1b2e4f74-7058-4712-85a7-84198723e3ee@default 4EB1AD53.2000600@redhat.com> <cb397723-5297-493d-9bbd-522a6400a5a6@default> <4EC29367.9040106@redhat.com>
In-Reply-To: <4EC29367.9040106@redhat.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 08:29 AM, Rik van Riel wrote:
> On 11/02/2011 05:14 PM, Dan Magenheimer wrote:
>
>> It occurs to me that batching could be done locally without
>> changing the in-kernel "API" (i.e. frontswap_ops)... the
>> guest-side KVM tmem-backend-driver could do the compression
>> into guest-side memory and make a single
>> hypercall=vmexit/vmenter whenever it has collected enough for
>> a batch.
>
> That seems like the best way to do it, indeed.
>
> Do the current hooks allow that mode of operation,
> or do the hooks only return after the entire operation
> has completed?

The APIs are synchronous, but need only return once the memory has been
dealt with in some way.  If you were batching before making a hypercall,
then the implementation would just have to make a copy into its private
memory and you'd have to make sure that lookups on batched but
unsubmitted pages work.

(It's been a while since I've looked at these patches, but I'm assuming
nothing fundamental has changed about them lately.)

    J
