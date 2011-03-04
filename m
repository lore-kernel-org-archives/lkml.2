Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab1CDWKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:10:41 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62733 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932606Ab1CDWKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:10:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EJOjzUAw50Gk1FRc6JSAM81jlj4dWvLayi/MJzWp8ROiMjwAaR5EYH78LfAfX/LYxQ
         2sFzASznOzpFozxnnjqNrhusHCtretGdvTgFBBVnU+TioA/mmHJuJyt9iPYZCxdmmpc0
         YOO1elWYutA34l7/M2S1IKzf5BWVCnMHOsxF0=
MIME-Version: 1.0
In-Reply-To: <1299275042.2071.1422.camel@dan>
References: <1299174652.2071.12.camel@dan>
	<1299185882.3062.233.camel@calx>
	<1299186986.2071.90.camel@dan>
	<1299188667.3062.259.camel@calx>
	<1299191400.2071.203.camel@dan>
	<2DD7330B-2FED-4E58-A76D-93794A877A00@mit.edu>
	<AANLkTimpfk8EHjVKYsJv0p_G7tS2yB-n=PPbD2v7xefV@mail.gmail.com>
	<1299260164.8493.4071.camel@nimitz>
	<AANLkTim+XcYiiM9u8nT659FHaZO1RPDEtyAgFtiA8VOk@mail.gmail.com>
	<1299262495.3062.298.camel@calx>
	<AANLkTimRN_=APe_PWMFe_6CHHC7psUbCYE-O0qc=mmYY@mail.gmail.com>
	<1299270709.3062.313.camel@calx>
	<1299271377.2071.1406.camel@dan>
	<AANLkTik6tAfaSr3wxdQ1u_Hd326TmNZe0-FQc3NuYMKN@mail.gmail.com>
	<1299272907.2071.1415.camel@dan>
	<AANLkTina+O77BFV+7mO9fX2aJimpO0ov_MKwxGtMwqG+@mail.gmail.com>
	<1299275042.2071.1422.camel@dan>
Date: Sat, 5 Mar 2011 00:10:39 +0200
X-Google-Sender-Auth: nzBvSwX9Uh_1DJY03-k7IdLi0Ps
Message-ID: <AANLkTikA=88EMs8RRm0RPQ+Q9nKj=2G+G86h5nCnV7Se@mail.gmail.com>
Subject: Re: [PATCH] Make /proc/slabinfo 0400
From: Pekka Enberg <penberg@kernel.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Matt Mackall <mpm@selenic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Theodore Tso <tytso@mit.edu>,
        cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Fri, Mar 4, 2011 at 11:44 PM, Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> This is a good point, and one that I've come to accept as a result of
> having this conversation.  Consider the patch dropped, unless there are
> other reasons I've missed.  I still think it's worth brainstorming
> techniques for hardening the kernel heap in ways that don't create
> performance impact, but I admit that the presence or absence of this
> debugging information isn't a crucial factor in successful exploitation.

I can think of four things that will make things harder for the
attacker (in the order of least theoretical performance impact):

  (1) disable slub merging

  (2) pin down random objects in the slab during setup (i.e. don't
allow them to be allocated)

  (3) randomize the initial freelist

  (4) randomize padding between objects in a slab

AFAICT, all of them will make brute force attacks using the kernel
heap as an attack vector harder but won't prevent them.

                        Pekka
