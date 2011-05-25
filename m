Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab1EYXxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:53:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757142Ab1EYXxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:53:12 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1105251922520.1749@ubuntu-natty>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com>
 <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com>
 <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty> <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
 <4DDD5240.2060308@fusionio.com> <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com>
 <4DDD55D6.1080909@fusionio.com> <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty>
 <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com> <alpine.DEB.2.02.1105251613500.8972@ubuntu-natty>
 <BANLkTimndXcBJ9wwJrcTt3Pf3vaNVUUtwg@mail.gmail.com> <alpine.DEB.2.02.1105251638220.8972@ubuntu-natty>
 <1306356735.1641.61.camel@mulgrave.site> <BANLkTimuomu=_JuMr7SWrMVvboMX4BX0fA@mail.gmail.com>
 <BANLkTik+BDbex5-LTjBzhUXf34WuyM0Jmw@mail.gmail.com> <alpine.DEB.2.02.1105251922520.1749@ubuntu-natty>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 May 2011 16:52:20 -0700
Message-ID: <BANLkTinOkPodwvM_x8_68Fg=xb2mSiy3aQ@mail.gmail.com>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 4:45 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>
> So now the issue is with scsi_device refcnt?

No, I'd guess that the problem is just that __scsi_remove_device()
sets queuedata to NULL. Afaik, both sdev and the queue actually stay
around.

That said, I don't have very high opinions of some of the SCSI code.
And that's me being polite. The thing is a overcomplicated mess of
indirection and pointers back-and-forth. The refcounting is crazy
and/or impossible, since the pointers really do go back-and-forth.

                       Linus
