Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab1BIQlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:41:22 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26033 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab1BIQlV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:41:21 -0500
MIME-Version: 1.0
Message-ID: <5c529b08-cf36-43c7-b368-f3f602faf358@default>
Date: Wed, 9 Feb 2011 08:39:37 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: gregkh@suse.de, Chris Mason <chris.mason@oracle.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ngupta@vflare.org, jeremy@goop.org,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        riel@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        kosaki.motohiro@jp.fujitsu.com, sfr@canb.auug.org.au,
        wfg@mail.ustc.edu.cn, tytso@mit.edu, viro@zeniv.linux.org.uk,
        hughd@google.com, hannes@cmpxchg.org
Subject: RE: [PATCH V2 2/3] drivers/staging: zcache: host services and PAM
 services
References: <AANLkTi=CEXiOdqPZgQZmQwatHqZ_nsnmnVhwpdt=7q3f@mail.gmail.com>
 <0d1aa13e-be1f-4e21-adf2-f0162c67ede3@default
 AANLkTimm8o6FnDon=eMTepDaoViU9tjteAYE9kmJhMsx@mail.gmail.com>
In-Reply-To: <AANLkTimm8o6FnDon=eMTepDaoViU9tjteAYE9kmJhMsx@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D52C36B.017F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> From: Minchan Kim [mailto:minchan.kim@gmail.com]

> As I read your comment, I can't find the benefit of zram compared to
> frontswap.

Well, I am biased, but I agree that frontswap is a better technical
solution than zram. ;-)  But "dynamic-ity" is very important to
me and may be less important to others.

I thought of these other differences, both technical and
non-technical:

- Zram is minimally invasive to the swap subsystem, requiring only
  one hook which is already upstream (though see below) and is
  apparently already used by some Linux users.  Frontswap is somewhat
  more invasive and, UNTIL zcache-was-kztmem was posted a few weeks
  ago, had no non-Xen users (though some distros are already shipping
  the hooks in their kernels because Xen supports it); as a result,
  frontswap has gotten almost no review by kernel swap subsystem
  experts who I'm guessing weren't interested in anything that
  required Xen to use... hopefully that barrier is now resolved
  (but bottom line is frontswap is not yet upstream).

- Zram has one-byte of overhead per page in every explicitly configured
  zram swap, the same as any real swap device.  Frontswap has one-BIT
  of overhead per page for every configured (real) swap device.

- Frontswap requires several hooks scattered through the swap subsystem:
  a) init, put, get, flush, and destroy
  b) a bit-per-page map to record whether a swapped page is in
     frontswap or on the real device
  c) a "partial swapoff" to suck stale pages out of frontswap
  Zram's one flush hook is upstream, though IMHO to be fully functional
  in the real world, it needs some form of (c) also.

Thanks,
Dan
