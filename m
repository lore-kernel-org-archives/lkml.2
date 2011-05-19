Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab1ESEIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 00:08:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64388 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1ESEIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 00:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=E3/y8kTL/yNmNxpJi6tH6nAHEc3XtBICytnH+Q+Z8qORgUL+JuTfcNq4opAQWNIGcJ
         Ex3X9WM6WiJFHsAw8KTsZyqJafcd8XYcvo78DnhxWwPSX4+LtuiILuFVB6EUUUXrZRmI
         yxTr1nZvRxMhplgNNxaw3DRSz+QfwBt11al+o=
MIME-Version: 1.0
In-Reply-To: <4565AEA676113A449269C2F3A549520F80BE7F37@cosmail03.lsi.com>
References: <20110504115324.GE17855@lsi.com>
	<1305616571.6008.23.camel@mulgrave.site>
	<B2FD678A64EAAD45B089B123FDFC3ED70157F7BCE5@inbmail01.lsi.com>
	<20110518041551.GL15227@parisc-linux.org>
	<1305692584.2580.3.camel@mulgrave.site>
	<1305702010.2781.33.camel@pasglop>
	<mpt2sas-writeq-powerpc64@mdm.bga.com>
	<4565AEA676113A449269C2F3A549520F80B66280@cosmail03.lsi.com>
	<x86-32-writeq-is-broken@mdm.bga.com>
	<4565AEA676113A449269C2F3A549520F80BE7F37@cosmail03.lsi.com>
Date: Thu, 19 May 2011 13:08:38 +0900
Message-ID: <BANLkTin4w1QyL1NyTyrZARPWASai45W_4Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
 not atomic
From: Hitoshi Mitake <h.mitake@gmail.com>
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Milton Miller <miltonm@bga.com>, Sam Ravnborg <sam@ravnborg.org>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
        "Desai, Kashyap" <Kashyap.Desai@lsi.com>,
        "Prakash, Sathya" <Sathya.Prakash@lsi.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Matthew Wilcox <matthew@wil.cx>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux scsi dev <linux-scsi@vger.kernel.org>,
        "paulus@samba.org" <paulus@samba.org>,
        linux powerpc dev <linuxppc-dev@lists.ozlabs.org>,
        linux pci <linux-pci@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 04:11, Moore, Eric <Eric.Moore@lsi.com> wrote:
> On Wednesday, May 18, 2011 12:31 PM Milton Miller wrote:
>> Ingo I would propose the following commits added in 2.6.29 be reverted.
>> I think the current concensus is drivers must know if the writeq is
>> not atomic so they can provide their own locking or other workaround.
>>
>
>
> Exactly.
>

The original motivation of preparing common readq/writeq is that
letting each driver
have their own readq/writeq is bad for maintenance of source code.

But if you really dislike them, there might be two solutions:

1. changing the name of readq/writeq to readq_nonatomic/writeq_nonatomic
2. adding new C file to somewhere and defining spinlock for them.
    With spin_lock_irqsave() and spin_unlock_irqrestore() on the spinlock,
    readq/writeq can be atomic.

How do you think about them? If you cannot agree with the above two solutions,
I'll agree with reverting them.

-- 
Hitoshi Mitake
h.mitake@gmail.com
