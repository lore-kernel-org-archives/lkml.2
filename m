Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935094Ab0GPAOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 20:14:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58615 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933992Ab0GPAOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 20:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bxd+7gt14UCi/RbuZk7XsrF0dVUxJF5NNtMRjcQ1iQgJrVMgs/3USSVGsIgzyBLTyI
         mKZf7/G+yMbIHLfA1ijQC8jnbUrOMfKH4RWA78H1tgU/cHvkvZ4els7iZ9vGcOOIV+16
         Dy1veRMy9gGfDctKP6Z6dxY4JtPfBF3tCrtfI=
MIME-Version: 1.0
In-Reply-To: <202899B0-BADE-4CD0-B0E4-1A2FC99397D6@themaw.net>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de>
	<20100705195837.GF5240@nowhere>
	<1278378690.3070.6.camel@localhost>
	<201007061335.00264.arnd@arndb.de>
	<202899B0-BADE-4CD0-B0E4-1A2FC99397D6@themaw.net>
Date: Fri, 16 Jul 2010 02:14:03 +0200
Message-ID: <AANLkTimVzSzCl2XfWBg5HauYtIT5znxkm6M0yo_1en2b@mail.gmail.com>
Subject: Re: [PATCH 3/6] autofs/autofs4: move compat_ioctl handling into fs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ian Kent <raven@themaw.net>
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "autofs@linux.kernel.org" <autofs@linux.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/6 Ian Kent <raven@themaw.net>:
>
>
> On 06/07/2010, at 7:35 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
>>
>> Well, the only use of the BKL in autofs4 is in the ioctl function. You
>> can probably replace that trivially with a global mutex, but from a quick
>> inspection, even that should not be needed: The only ioctl command in
>> autofs4 that does not already seem to have adequate locking is
>> autofs4_get_set_timeout, which is even easier to change and still harmless
>> if you don't do it at all.
>
> That's right of course.
>
> Even this shouldn't be a problem as it is called by a single instance, per autofs mount, of the daemon only. A fair amount of effort has gone into trying to make the autofs4 module independent of the BKL over time. However I would still rather not do the change concurrently with the ioctl changes.
>
> Ian


In any case, can we let you handle this patch for 2.6.36 inclusion?

Thanks.
