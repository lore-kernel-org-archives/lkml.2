Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942Ab0EZHop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:44:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47946 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933844Ab0EZHon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:44:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EIPZ5di3UUVMcLmgZHXjPl42Wkfhm/fh3Nkl+ylPxl3vhQpKiWzWxsJOiMq6+lA4gz
         OP+czW3dHnWoaFU3lLe/DYZtHRRrP9FV/uIqpZ5fxI+6haTCH5ncWmzUgGhlgVk4EQ3D
         XRaNeS4cb15BJ++NU/DB0azlmwQz+fniXsUIA=
MIME-Version: 1.0
In-Reply-To: <4BFC8617.9010501@codesourcery.com>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org> 
	<20100525210755.GA8920@linux-sh.org> <AANLkTinTbJ3yu9ElO32rnavnGwCrsItdDCl58KoeEW3j@mail.gmail.com> 
	<4BFC8617.9010501@codesourcery.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 26 May 2010 03:36:30 -0400
Message-ID: <AANLkTimMEKZ-GEVpWIhcxsgRnDkr6vOHEOyFOSEEJen9@mail.gmail.com>
Subject: Re: [PATCH] FLAT: allow arches to declare a larger alignment than the 
	slab
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jie Zhang <jie@codesourcery.com>, uclinux-dev@uclinux.org,
       David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
       linux-m32r@ml.linux-m32r.org, Hirokazu Takata <takata@linux-m32r.org>,
       linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 22:23, Jie Zhang wrote:
> On 05/26/2010 07:17 AM, Mike Frysinger wrote:
>> i do not believe that is the reason for this, but unfortunately Jie is
>> about the only one atm who knows the inner details as for why shared
>> FLAT libraries requires 0x20 rather than just 0x4 alignment.  i do
>> know that there are some gcc fortran tests that fail otherwise.
>> hopefully he can remember details ;).
>
> I encountered this issue when investigating some GCC test failures when
> using FLAT. I don't remember if they were in GCC Fortran testsuite. Some
> variables in those test cases were required to be aligned at a large
> boundary, for example 16-byte. I found 0x20 was a reasonably large alignment
> to fix all such failures in GCC testsuite.

ok, i found the reports Jie worked on originally.  the 0x20 value isnt
a hardware restriction or anything.  some gcc tests use the alignment
directive and then double check that it was respected.  the way the
FLAT loader crams things into the start of the data page before
appending the data breaks this.  so 0x20 was selected because, as Jie
said, it seemed to satisfy all of the gcc tests.

presumably this issue could be resolved by changing the FLAT loader to
append this internal state data instead of prepending.  that would fix
FLAT behavior wrt alignment directives (up to a page).
-mike
