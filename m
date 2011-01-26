Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1AZXGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:06:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:15068 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab1AZXGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:06:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C8bHH0VJ9g/ZIAAN1xyk4q9Wl8sPYN5tTNSp7XWCfelElgjMM5wd5/3du8C+VsPGQ7
         +6UXr+6xXaLtbTqDHBYw==
MIME-Version: 1.0
In-Reply-To: <iho7ba$kmn$1@dough.gmane.org>
References: <20110125235700.GR8008@google.com>
	<iho7ba$kmn$1@dough.gmane.org>
Date: Wed, 26 Jan 2011 15:05:48 -0800
Message-ID: <AANLkTikaDpZ=Pjb+m7ixCepywtO1bUN02sfimWBSTha3@mail.gmail.com>
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
From: Mandeep Baines <msb@google.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 8:18 PM, WANG Cong <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, 25 Jan 2011 15:57:00 -0800, Mandeep Singh Baines wrote:
>
> > We've been burned by regressions/bugs which we later realized could have
> > been triaged quicker if only we'd paid closer attention to dmesg. To
> > make it easier to audit dmesg, we'd like to make DEFAULT_MESSAGE_LEVEL
> > Kconfig-settable. That way we can set it to KERN_NOTICE and audit any
> > messages <= KERN_WARNING.
> >
>
> Why? We already have "loglevel=" kernel parameter.
>

loglevel allows you to control which messages go to the console.

DEFAULT_MESSAGE_LEVEL selects the default message levels for printk()s which
don't specify a message level.

Most printks()s without a message level aren't really warnings and
just create noise
if you're trying to look closely at all warnings. Some of this is just
old code but new
printk()s without a message level do get committed from time to time.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
