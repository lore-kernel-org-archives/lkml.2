Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1FCS0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:26:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51144 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab1FCS0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EX2UHFEygOvdbMSlrlp0iwPrhpoRSpttR8mDP8DG5AsZBPhVga6eevB4/cNe3hShRy
         JHIqidKFA9Ou1aEmjUV+X6WADnBGEWN3uVG5+CyrK6oYxAyej+0WmRCMTS/1yaDz0hfq
         fxAbjbowG7Xxnmhv2iNTstshah1HfO0Hrop7Y=
MIME-Version: 1.0
In-Reply-To: <4DE92675.6080908@freescale.com>
References: <1307119552-15573-1-git-send-email-timur@freescale.com>
	<BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>
	<4DE92675.6080908@freescale.com>
Date: Fri, 3 Jun 2011 21:26:21 +0300
Message-ID: <BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>
Subject: Re: [PATCH] lib: introduce strdup_from_user
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Timur Tabi <timur@freescale.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
        scottwood@freescale.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 9:22 PM, Timur Tabi <timur@freescale.com> wrote:
> Alexey Dobriyan wrote:
>> NAK
>> It accesses userspace data twice.
>
> What's wrong with that?

If mm is shared, data can or will change under you.

> How else is it supposed to know how much to allocate
> without using strlen first?

I don't know.
What I know is that your function doesn't guarantee NUL-termination.

> Besides, it was Alan's idea to make this a common function.  I can easily put it
> back in my driver.

Don't do that.
