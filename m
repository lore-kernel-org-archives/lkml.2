Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1HBQgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:36:43 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:38022 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754612Ab1HBQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:36:33 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6zjj1yoVM1kNhNkLKxkI.Yx_PSwb2daNCCFTe8jkmrhx6qz
 MbGZbkc6aJqqLcTiHahpU4F4Djw8PQD2n0.P12EY1sUlGMoNa6i0Ytfc.XBA
 V1HiyBFL14T7diQQwDLs9elRVJiPQ9P8DL9xuySa31dWgWRnTr.S6s6bbI8X
 XXNUx40j0YMFmLuZO_TwNJjmNww_nrfioms3iQMSgZ.ubbk6UB8orowS3EkV
 _G71f_HborE3HFhBrqZJARBdlgtgE3Dwn8TtGF2BtpcYNQEIOeJgQPckH5sB
 PMAfRP8KtTNneFYn4MXcU3rbBRipJK7bH5WMGtBSD85H3idXZ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 2 Aug 2011 11:36:29 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
In-Reply-To: <alpine.DEB.2.00.1108020915370.1114@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1108021131250.21126@router.home>
References: <alpine.DEB.2.00.1107290145080.3279@tiger> <alpine.DEB.2.00.1107291002570.16178@router.home> <alpine.DEB.2.00.1107311136150.12538@chino.kir.corp.google.com> <alpine.DEB.2.00.1107311253560.12538@chino.kir.corp.google.com> <1312145146.24862.97.camel@jaguar>
 <alpine.DEB.2.00.1107311426001.944@chino.kir.corp.google.com> <CAOJsxLHB9jPNyU2qztbEHG4AZWjauCLkwUVYr--8PuBBg1=MCA@mail.gmail.com> <alpine.DEB.2.00.1108012101310.6871@chino.kir.corp.google.com> <alpine.DEB.2.00.1108020913180.18965@router.home>
 <alpine.DEB.2.00.1108020915370.1114@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011, David Rientjes wrote:

> allocator, in this case.  And the per-cpu partial list will add even
> additional slab usage for slub, so this is where my "throwing more memory
> at slub to get better performance" came from.  I understand that this is a
> large NUMA machine, though, and the cost of slub may be substantially
> lower on smaller machines.

The per cpu partial lists only add the need for more memory if other
processors have to allocate new pages because they do not have enough
partial slab pages to satisfy their needs. That can be tuned by a cap on
objects.


