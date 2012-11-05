Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab2KENlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:41:31 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55540 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab2KENl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:41:28 -0500
MIME-Version: 1.0
In-Reply-To: <CANN689HfmX8uBa17t38PYv2Ap5d3LPjShq81tbcgET5ZqzjzeQ@mail.gmail.com>
References: <508086DA.3010600@oracle.com>
	<5089A05E.7040000@gmail.com>
	<CA+1xoqf2v_jEapwU68BzXyi4abSRmi_=AiaJVHM3dBbHtsBnqQ@mail.gmail.com>
	<CAA_GA1d-rw_vkDF98fcf9E0=h86dsp+83-0_RE5b482juxaGVw@mail.gmail.com>
	<CANN689HXoCMTP4ZRMUNOGAdOBmizKyo6jMqbqAFx8wwPXp+AzQ@mail.gmail.com>
	<CAA_GA1eYHi4zWZwKp5KGi4gP7V8bfnSF=aLKMiN-Wi5JyLaCdw@mail.gmail.com>
	<CANN689HfmX8uBa17t38PYv2Ap5d3LPjShq81tbcgET5ZqzjzeQ@mail.gmail.com>
Date: Mon, 5 Nov 2012 05:41:27 -0800
Message-ID: <CANN689HM=h2k33sJcoDYys9LHVadv+NaGz00kG7O-OEH=qadvA@mail.gmail.com>
Subject: Re: mm: NULL ptr deref in anon_vma_interval_tree_verify
From: Michel Lespinasse <walken@google.com>
To: Bob Liu <lliubbo@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, hughd@google.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 4, 2012 at 8:44 PM, Michel Lespinasse <walken@google.com> wrote:
> On Sun, Nov 4, 2012 at 8:14 PM, Bob Liu <lliubbo@gmail.com> wrote:
>> Hmm, I attached a simple fix patch.
>
> Reviewed-by: Michel Lespinasse <walken@google.com>
> (also ran some tests with it, but I could never reproduce the original
> issue anyway).

Wait a minute, this is actually wrong. You need to call
vma_lock_anon_vma() / vma_unlock_anon_vma() to avoid the issue with
vma->anon_vma == NULL.

I'll fix it and integrate it into my next patch series, which I intend
to send later today. (I am adding new code into validate_mm(), so that
it's easier to have it in the same patch series to avoid merge
conflicts)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
