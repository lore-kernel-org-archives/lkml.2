Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643Ab0J2TJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:09:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758932Ab0J2TJB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:09:01 -0400
MIME-Version: 1.0
In-Reply-To: <4CCB1906.4000608@goop.org>
References: <4CCB1906.4000608@goop.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Oct 2010 12:08:09 -0700
Message-ID: <AANLkTi=g5sdiWSaLUHAATQn-1=jPqtc=RL6SpYSMYn98@mail.gmail.com>
Subject: Re: [GIT PULL] Small Xen bugfixes
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Vasiliy G Tolstov <v.tolstov@selfip.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 11:57 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>    * fix dom0 boot on systems whose E820 doesn't completely cover the
>      ISA address space.  This fixes a crash on a Dell R310.

Hmm. This clashes with my current tree.

And that conflict is trivial to fix up, but the thing is, I think the
patch that comes from your tree is worse than what is already there.

Why is that simple unconditional

    e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
           E820_RESERVED);

not just always the right thing? Why do you have a separate hack for
dom0 in xen_release_chunk() instead? That just looks bogus.

The normal logic we use on PC's is to just always reserve the low 64kB
of memory, and the whole ISA space. Why doesn't Xen just do the same?

                          Linus
