Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2FLRJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:09:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52886 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2FLRJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:09:01 -0400
Message-ID: <4FD777A5.9050001@redhat.com>
Date: Tue, 12 Jun 2012 19:08:53 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org,
        jbottomley@parallels.com
Subject: Re: [PATCH] scsi: allow persistent reservations without CAP_SYS_RAWIO
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com> <20120612175503.3462962f@pyramind.ukuu.org.uk>
In-Reply-To: <20120612175503.3462962f@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/06/2012 18:55, Alan Cox ha scritto:
> On Tue, 12 Jun 2012 18:08:32 +0200
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
>> Persistent reservations commands cannot be issued right now without
>> giving CAP_SYS_RAWIO to the process who wishes to send them.  This
>> is a bit heavy-handed, allow these two commands.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>         Ok for 3.5 as well?
> 
> NAK.
> 
> Persistent reservations are exactly the kind of command that should have
> a security model attached to them.

There is.  It's called "chmod"; you don't give write access to LUNs to
random users.  and SCM_RIGHTS is what lets you override it securely.

> Red Hat seems to be an ever growing source of "mummy its hard, lets
> disable all the security" type fixes. Please stop it.

Last time you were complaining that I was turning things *off* (SG_IO to
partitions for root).  Now you complain that I'm turning things *on*.
It's difficult to say they are the same thing.  Though perhaps you were
talking about someone else.

> There is a sensible debate to be had about whether a lesser privilege
> ought to be allowed. The real fix to this as with half of the other
> crazy attempts to break all the security models that seem to keep spewing
> forth is for someone who cares about it (that seems to me Red Hat) add
> support for pushing a BPF filter onto a block device command queue. 

Sure; however, doing so requires access to some member of "struct file"
from SG_IO.  Thus, ioctl would need to take a "struct file" rather than
just an fmode_t.

The switch to fmode_t was done in 2007 by Al Viro.  I would like to
understand the reasons for the switch; it seems to me that it was part
of the big kernel lock removal.  If it's acceptable to undo it, I would
very much would like to add generic BPF filtering to SG_IO.

Paolo
