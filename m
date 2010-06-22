Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab0FVOIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 10:08:20 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37782 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab0FVOIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 10:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QMrNGxmXBBGMUTpywZET+9GIYSpzQoawbF6SHA9iUbVLFsrrFC2RUGAUiV4EkzpRly
         DqelE50xGlhJSCR8uSM0DfCN7ZzMjprsQSGzOPdby6oReVLlPt+/+chSlffL0IuO0wcM
         nevCY/DLGNyAPdALtZryCpHDOFaZ0SDL8prS4=
MIME-Version: 1.0
In-Reply-To: <20100621202854.de928e0a.akpm@linux-foundation.org>
References: <AANLkTilCW2iqsNaWM9NYIomy8OxGC9jG40KpLcKMYTqL@mail.gmail.com>
	<20100621202854.de928e0a.akpm@linux-foundation.org>
Date: Tue, 22 Jun 2010 08:08:17 -0600
Message-ID: <AANLkTimsDSrEL8vT877pLYSa4A338p4Y8w0Ya6Xm7BFJ@mail.gmail.com>
Subject: Re: 2.6.34 Crash in dmaengine_put()
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK.  This bug occurs if you OR in the IFF_UP flag while creating
virtual interfaces without going through the normal ifup/ifdown
scripts.  Looks like a hole.  I will post the trace shortly.  It's
easy to reproduce, take the dummy net driver, OR in the IFF_UP flag in
dummy_setup, and watch the kernel crash.

Jeff

On Mon, Jun 21, 2010 at 9:28 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 21 Jun 2010 20:57:40 -0600 Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
>
>> If someone sets the IFF_UP flags in the netdev structure without going
>> through ifup userspace stuff, during unregister of the the netdev
>> the dmaengine-put code will decrement the reference counter negative,
>> and crash at BUG! in the driver/dma/dmaengine.c code.  This seems
>> busted.
>>
>
> Please send a copy of the kernel BUG trace.
>
