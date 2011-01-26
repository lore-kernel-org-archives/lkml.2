Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1AZSvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:51:08 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58006 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1AZSvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:51:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=WRmoFz9vmaQnuMdRgv21kQ6M59PtGa+xJ0gZSuOQTQOpMYsOtusxMvZv7rSZv7G0WZ
         ld1QYCkcdqFzH5rWgC8HTb90AbAEig8vQ7EhieRpeOS0kFp4qJYIFdau1X+TYYaAiiCf
         B666ZGyWbTJoiwZV+tLGOVaKbAJx1R9v4+428=
MIME-Version: 1.0
In-Reply-To: <20110126184057.GC17383@linux.vnet.ibm.com>
References: <20110126172148.GB8446@linux.vnet.ibm.com>
	<20110126172508.GF8446@linux.vnet.ibm.com>
	<AANLkTi=eM-e9KU0PedOcXqR8TEVeAuP8Vnna-pxO4pRU@mail.gmail.com>
	<20110126184057.GC17383@linux.vnet.ibm.com>
Date: Wed, 26 Jan 2011 20:51:05 +0200
X-Google-Sender-Auth: _KKnrC09iniIhxvWDT5FdcU5ktk
Message-ID: <AANLkTinMwGf2zDE8MEDCFZtUcVKRYLVZVhzzcdj3TYZf@mail.gmail.com>
Subject: Re: [PATCH 4/7] zram/xvmalloc: free bit block insertion optimization
From: Pekka Enberg <penberg@kernel.org>
To: Pekka Enberg <penberg@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 8:40 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
> * Pekka Enberg (penberg@kernel.org) wrote:
>> On Wed, Jan 26, 2011 at 7:25 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
>> > There is no need to set the bits in the first- and second-level indices
>> > to indicate a free page when we know that a free page existed at this
>> > level.
>> >
>> > Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
>>
>> Why is it not necessary? I don't know that part of the code well
>> enough to tell if this patch is safe or not.
>
> This change is in a conditional block which is entered only when there is
> an existing data block on the freelist where the insert has taken place.
>
> The new block is pushed onto the freelist stack and this conditional block
> is updating links in the prior stack head to point to the new stack head.
> After this conditional block the first-/second-level indices are updated
> to indicate that there is a free block at this location.
>
> This patch adds an immediate return from the conditional block to avoid
> setting bits again to indicate a free block on this freelist. They would
> already be set because there was an existing free block on this freelist.

Some of that information could be put in the changelog.

Reviewed-by: Pekka Enberg <penberg@kernel.org>
