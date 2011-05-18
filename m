Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab1ERPCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:02:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54080 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab1ERPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:02:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Ddrx7t+yCj0W1VBqsr5HjYAn+Zomh6SrJ8Twediv0BmOTYw5rvaC7Hc7PUwDAqFAyh
         8w/sNfo7K8xYV5/zfwsU1dxvJhZKbqBFMCqEZF0LmHFgCkKv16u5062GQysx/pWvNs3s
         Bddi4i4E+oz8o7rRRhYHXnWMM0MaX0EPEAYLI=
MIME-Version: 1.0
In-Reply-To: <20110516165352.GA18727@redhat.com>
References: <201105152235.32073.vda.linux@googlemail.com> <20110516153122.GA15856@redhat.com>
 <20110516155253.GA20624@htj.dyndns.org> <20110516165352.GA18727@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 18 May 2011 17:02:11 +0200
Message-ID: <BANLkTinO59MFbz679ZyvVR4U8KfwnbNYxQ@mail.gmail.com>
Subject: Re: Ptrace documentation, draft #1
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 6:53 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> I think resuming from signal delivery trap
>> should be the only place where @data means signo.
>
> Agreed, it would be more clean/simple/understandable.

I think ptrace API never promised that it will be possible
to "create new signal" by passing non-zero data - only
that the already pending signal can be passed, altered
or suppressed. If there *are* cases where "create new signal"
currently works, it's a quirk.

I changed doc to reflect this. If we tighten it up so that we can state
that all such attempts will be ignored, we can update docs.

-- 
vda
