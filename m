Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab0JFKcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:32:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36714 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab0JFKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tMZsyUyuOK/lTctxzHMpXPSmX+IdGDP0KhCZp2x+CczK/51EhLhz0ShrX0bzJW2qK9
         Bv3AcllROazFoYPgUXF3c1qDcNv4HAnrrFzYRZgCwRYdWKXcoq+di22iAjXRkc2XK1jd
         uBPL4z5cInSAXuy6ZRBoRSdvbEW6MBRCu+42I=
Date: Wed, 6 Oct 2010 18:36:58 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH v2] procfs: fix numbering in /proc/locks
Message-ID: <20101006103658.GC5724@cr0.nay.redhat.com>
References: <4CA484BA.7090809@redhat.com>
 <4CAB1693.2080301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAB1693.2080301@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 02:14:11PM +0200, Jerome Marchand wrote:
>On 09/30/2010 02:38 PM, Jerome Marchand wrote:
...
>> -	f->private = (void *)1;
>> +	f->private = (void *) (*pos + 1);
>
>That cast trigger a warning on some arch:
>"warning: cast to pointer from integer of different size"
>
>There is no real risk here. At worst /proc/locks will show wrong number
>if there is more than 2^32 locks, but should I mute the warning it with
>something like:
>        f->private = (void *) (size_t) (*pos + 1);
>?

Or maybe cast to (void *) (unsigned long)?
