Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab0EZGcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:32:20 -0400
Received: from gw1.transmode.se ([213.115.205.20]:40851 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab0EZGcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:32:19 -0400
In-Reply-To: <20100526140900.5b091c16.sfr@canb.auug.org.au>
References: <20100526110506.f2f4f22c.sfr@canb.auug.org.au>	<20100525182040.f1882d0a.akpm@linux-foundation.org> <20100526140900.5b091c16.sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning in Linus'tree
X-KeepSent: C00BDFAC:5596A841-C125772F:0022984D;
 type=4; name=$KeepSent
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Linus <torvalds@linux-foundation.org>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFC00BDFAC.5596A841-ONC125772F.0022984D-C125772F.0023AF14@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 26 May 2010 08:29:45 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-05-26 08:32:17
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote on 2010/05/26 06:09:00:
>
> Hi Andrew,
>
> On Tue, 25 May 2010 18:20:40 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > hmpf.  Does this fix?
>
> No.
>
> The problem is that __LITTLE_ENDIAN is only defined in
> linux/byteorder/little_endian.h which is only included by little endian
> architectures ...

Ah, not sure how to fix this ATM. Perhaps best to revert
   crc32: use __BYTE_ORDER macro for endian detection
for now.

I suspect fixing this entails moving all endian tests to #if __BYTE_ORDER ...
and then always define both __LITTLE_ENDIAN and __BIG_ENDIAN

 Jocke

