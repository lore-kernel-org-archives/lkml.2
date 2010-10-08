Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab0JHKU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:20:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55265 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab0JHKU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eiwbPV1NKPS8vjrkbcSSkKr7nd/HJSVwz+kb1mAT3JeEPAWvCn2gt4xR606GZFcm3J
         c05jrXoFH3nLyifg23wXOddRIOvy5tcjOyi4u/brnDcCOxKDWHc4m/JWA44k1xlyN5Ky
         Oc2PW/H5WtVbHVa5oCEKRHn0YVYKUGKXG52rA=
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101008101921.GD19804@ZenIV.linux.org.uk>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
	 <1286515292-15882-16-git-send-email-david@fromorbit.com>
	 <87d3rl5c1h.fsf@basil.nowhere.org>
	 <20101008095824.GB19804@ZenIV.linux.org.uk>
	 <20101008100944.GE13352@basil.fritz.box>
	 <20101008101921.GD19804@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 12:20:47 +0200
Message-ID: <1286533247.2959.129.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 08 octobre 2010 à 11:19 +0100, Al Viro a écrit :
> On Fri, Oct 08, 2010 at 12:09:44PM +0200, Andi Kleen wrote:
> 
> > > Can be done if you bother to add ->getattr() for those, but you'll need
> > > to do some kind of lazy allocation of inumbers for those; fstat() _will_
> > > want st_ino.
> > 
> > Why not just put 0 in st_ino for sockets/pipes/etc. ? 
> 
> Because it's a userland-visible change; right now you can compare
> i_ino for sockets...

lsof for example uses i_ino



