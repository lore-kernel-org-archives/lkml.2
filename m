Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab0D0Ibd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 04:31:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36528 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0D0Ibb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 04:31:31 -0400
MIME-Version: 1.0
Message-ID: <a0c1615e-c64a-4d4a-bd49-9e3e614d031b@default>
Date: Tue, 27 Apr 2010 01:29:35 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       jeremy@goop.org, hugh.dickins@tiscali.co.uk, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: RE: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <20100422134249.GA2963@ca-server1.us.oracle.com>
 <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default>
 <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default>
 <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default>
 <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default>
 <4BD1B427.9010905@redhat.com> <4BD24E37.30204@vflare.org>
 <4BD33822.2000604@redhat.com> <4BD3B2D1.8080203@vflare.org>
 <4BD4329A.9010509@redhat.com> <4BD4684E.9040802@vflare.org>
 <4BD52D55.3070803@redhat.com> <2634f2cb-3e7e-4c86-b7ef-cf4a3f1e0d8a@default
 4BD5987F.7080505@redhat.com>
In-Reply-To: <4BD5987F.7080505@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BD6A0A5.0185:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well if you are saying that your primary objection to the
> > frontswap synchronous API is that it is exposed to modules via
> > some EXPORT_SYMBOLs, we can certainly fix that, at least
> > unless/until there are other pseudo-RAM devices that can use it.
> >
> > Would that resolve your concerns?
> >
> 
> By external interfaces I mean the guest/hypervisor interface.
> EXPORT_SYMBOL is an internal interface as far as I'm concerned.
> 
> Now, the frontswap interface is also an internal interface, but it's
> close to the external one.  I'd feel much better if it was
> asynchronous.

OK, so on the one hand, you think that the proposed synchronous
interface for frontswap is insufficiently extensible for other
uses (presumably including KVM).  On the other hand, you agree
that using the existing I/O subsystem is unnecessarily heavyweight.
On the third hand, Nitin has answered your questions and spent
a good part of three years finding that extending the existing swap
interface to efficiently support swap-to-pseudo-RAM requires
some kind of in-kernel notification mechanism to which Linus
has already objected.

So you are instead proposing some new guest-to-host asynchronous
notification mechanism that doesn't use the existing bio
mechanism (and so presumably not irqs), imitates or can
utilize a dma engine, and uses less cpu cycles than copying
pages.  AND, for long-term maintainability, you'd like to avoid
creating a new guest-host API that does all this, even one that
is as simple and lightweight as the proposed frontswap hooks.

Does that summarize your objection well?
