Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0FCPoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:44:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63712 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab0FCPoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:44:07 -0400
MIME-Version: 1.0
Message-ID: <6e97a82a-c754-493e-bbf5-58f0bb6a18b5@default>
Date: Thu, 3 Jun 2010 08:43:05 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: ngupta@vflare.org, andreas.dilger@oracle.com
Cc: Minchan Kim <minchan.kim@gmail.com>, chris.mason@oracle.com,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@sun.com,
       tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
       konrad.wilk@oracle.com
Subject: RE: [PATCH V2 0/7] Cleancache (was Transcendent Memory): overview
References: <20100528173510.GA12166%ca-server1.us.oracle.comAANLkTilV-4_QaNq5O0WSplDx1Oq7JvkgVrEiR1rgf1up@mail.gmail.com>
 <489aa002-6d42-4dd5-bb66-81c665f8cdd1@default> <4C07179F.5080106@vflare.org>
 <3721BEE2-DF2D-452A-8F01-E690E32C6B33@oracle.com 4C074ACE.9020704@vflare.org>
In-Reply-To: <4C074ACE.9020704@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4C07CDAA.017F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/03/2010 10:23 AM, Andreas Dilger wrote:
> > On 2010-06-02, at 20:46, Nitin Gupta wrote:
> 
> > I was thinking it would be quite clever to do compression in, say,
> > 64kB or 128kB chunks in a mapping (to get decent compression) and
> > then write these compressed chunks directly from the page cache
> > to disk in btrfs and/or a revived compressed ext4.
> 
> Batching of pages to get good compression ratio seems doable.

Is there evidence that batching a set of random individual 4K
pages will have a significantly better compression ratio than
compressing the pages separately?  I certainly understand that
if the pages are from the same file, compression is likely to
be better, but pages evicted from the page cache (which is
the source for all cleancache_puts) are likely to be quite a
bit more random than that, aren't they?
