Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab0JWSA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 14:00:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43095 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab0JWSAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 14:00:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AAro/awQ1fc/IbYX0JMOY1xRSaL7cDaBtCcrUM4TUlxsXU7+CquAVmjgaf/h9SIAVr
         Z2V3yNyWavDfobN2N0rdXSg21HqBGa5+ia087ZH3DZs/nVD0YGNUfqSMycwWXuACSwi0
         BZOcVJttX277yWJrWluUV1d1cX8rddjv6gjeA=
Subject: Re: A question on block_prepare_write()
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101023104036.2bec05a0.akpm@linux-foundation.org>
References: <1287841482.1681.36.camel@leonhard>
	 <20101023104036.2bec05a0.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Oct 2010 03:00:46 +0900
Message-ID: <1287856846.1681.58.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-23 (토), 10:40 -0700, Andrew Morton:
> On Sat, 23 Oct 2010 22:44:42 +0900 Namhyung Kim <namhyung@gmail.com> wrote:
> 
> > Hello,
> > 
> > I see block_prepare_write() has local variable wait[2] to keep track of
> > buffer_heads which are not up-to-date. But I'm wondering how it could be
> > guaranteed there will be no more than 2 such buffer_heads? Is there any
> > restriction on the usage of the function? Using MAX_BUF_PER_PAGE instead
> > of the magic number 2 is just useless? I couldn't find any comments or
> > documentation on this.
> > 
> > Any of your comments would be greatly appreciated. TIA. :-)
> > 
> 
> block_prepare_write() may need to preread any buffer_head which are
> being only partially modified by the write().
> 
> Buffers which aren't being modified at all don't need to be preread. 
> Buffers which are being fully modified don't need to be preread
> (because all their data is being overwritten).
> 
> page:                      |-----------------------|
> buffer_heads:              |-----|-----|-----|-----|
> area we're writing to:               |---------|
> 
> There can only be a maximum of two partially-modified buffers in the page.

I see. It considers both edges of the to-be-written data. Thanks for
your clear and kindly explanation. :-)


-- 
Regards,
Namhyung Kim


