Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1CDU63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:58:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60029 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760065Ab1CDU61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:58:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=X1DfamVyuT/yBQ8OWW5YYVtbfVKbG/yv0HwhSAfB2411m5HGjNa1gFU9Kl+Dsi1m7I
         jiP2K5aYRYiB+Zlx018W5+vYmjouQxwdUyeGi6pzpCMW0oDPsEpN7yC/+miv04O3Ivhi
         3b33ylVS961dZj3ZqCREvJlP+8VUb4sCqccLU=
MIME-Version: 1.0
In-Reply-To: <1299271041.2071.1398.camel@dan>
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
	<1299271041.2071.1398.camel@dan>
Date: Fri, 4 Mar 2011 22:58:27 +0200
X-Google-Sender-Auth: iqJtuhachXeWOPvyV7vEjEgzeek
Message-ID: <AANLkTimvhHxsMCf2FX0O8VqksOa2EAMz=S_C3LQKvE60@mail.gmail.com>
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

On Fri, Mar 4, 2011 at 10:37 PM, Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> This patch makes these techniques more difficult by making it hard to
> know whether the last attacker-allocated object resides before a free or
> allocated object.  Especially with vulnerabilities that only allow one
> attempt at exploitation before recovery is needed to avoid trashing too
> much heap state and causing a crash, this could go a long way.  I'd
> still argue in favor of removing the ability to know how many objects
> are used in a given slab, since randomizing objects doesn't help if you
> know every object is allocated.

So if the attacker knows every object is allocated, how does that help
if we're randomizing the initial freelist?
