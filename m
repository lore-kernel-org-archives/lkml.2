Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab1EBVk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:40:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56664 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab1EBVkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OatCop9WISBNI56lxQnNTfW5Pu0ZN/JykmJSF4E9yRAkbmVbtV6lNg+aJ4wSJbtJVO
         22YKDoclMI/nwIEc9fZQ==
MIME-Version: 1.0
In-Reply-To: <1304365095.6400.20.camel@macbook.infradead.org>
References: <BANLkTimmr=rD84cAkQ2xGsG7PccxQKKqVg@mail.gmail.com> <1304365095.6400.20.camel@macbook.infradead.org>
From: Mike Waychison <mikew@google.com>
Date: Mon, 2 May 2011 14:40:33 -0700
Message-ID: <BANLkTinTUdAgF4eQ8_JtWgT_jJB5f7nT-A@mail.gmail.com>
Subject: Re: linux-firmware tree
To: David Woodhouse <dwmw2@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 12:38 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2011-05-02 at 19:57 +0100, Mike Waychison wrote:
>> Hi David,
>>
>> I'm trying to understand the purpose of the linux-firmware tree.
>> Forgive me if this is a stupid question, but the only information
>> about it I could find was your original post back in 2008:
>> https://lwn.net/Articles/294308/
>>
>> Will the Linux kernel sources always continue to have the firmware
>> blobs and the linux-firmware tree is only for those users of distros
>> that strip the firmware out?
>
> No, the legacy firmware images from the kernel tree are going to be
> removed. They were only kept for backward compatibility.
>
> The linux-firmware tree has a lot of things that were never included in
> the kernel source; no *new* firmware images are being (or at least
> should be) added to the kernel source itself.
>
> Everyone should be using the linux-firmware tree by now.

Fair enough.  We haven't actually hit a case where the firmware
required by any of the drivers we use isn't already present in the
tree.

I'm trying to figure out how we could ship firmware blobs on our
systems going forward.  Currently, we let firmware get installed to
our install root via the modules_install target, and then package up
the install root.  If drivers are going to request firmware blobs from
userland without them being picked up in-tree by
fw-shipped-$(CONFIG_FOO), we'll need to know at build time which
firmware blobs to package up.

I don't see anything in the build (looking at scripts/Makefile.fwinst
in particular) that allows the build to enumerate out-of-tree firmware
files required by drivers.  Do you have any thoughts on how this could
be enumerated? (if it isn't already?)


The alternative would be to ship the whole of the linux-firmware tree
on every machine we have, but that seems like a bad idea as it is only
going to grow with time and we don't have the MiB budget for such a
thing.
