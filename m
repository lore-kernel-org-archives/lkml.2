Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011Ab1FWT7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:59:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46661 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645Ab1FWT7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PYnWgsFF4owbpTiHPRp3cUeig2llZ8Uqdq32bFYneRp0noR6qAKNSEw2H4SB9gf7i2
         oUonrCNzI19dDJNTyc6LEgPdYp3pLuJm+uZpe+dn4iAPNVNVMocfZHnTfYgixEYwvIbE
         xz7P/KXSYjlfVAipGcBibYEvzd2O5sBNV/rlI=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1106231438530.2033-100000@iolanthe.rowland.org>
References: <1308849690-14530-25-git-send-email-paul.gortmaker@windriver.com>
	<Pine.LNX.4.44L0.1106231438530.2033-100000@iolanthe.rowland.org>
Date: Thu, 23 Jun 2011 15:59:43 -0400
Message-ID: <BANLkTimi7Srt+jgxU3gEt=-XsgLQ1VwCkA@mail.gmail.com>
Subject: Re: [34-longterm 024/247] USB: prevent buggy hubs from crashing the
 USB stack
From: Paul Gortmaker <paul.gortmaker@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 2:48 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 23 Jun 2011, Paul Gortmaker wrote:
>
>> From: Alan Stern <stern@rowland.harvard.edu>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
>> commit d199c96d41d80a567493e12b8e96ea056a1350c1 upstream.
>>
>> If anyone comes across a high-speed hub that (by mistake or by design)
>> claims to have no Transaction Translators, plugging a full- or
>> low-speed device into it will cause the USB stack to crash.  This
>> patch (as1446) prevents the problem by ignoring such devices, since
>> the kernel has no way to communicate with them.
>
> This commit had some unexpected fallout.  It shouldn't be merged unless
> the following upstream commits are also merged:
>
> c5c69f3f0dcf9b569c8f3ad67f3af92cfcedac43
> cee6a262550f53a13acfefbc1e3e5ff35c96182c
> ec95d35a6bd0047f05fe8a21e6c52f8bb418da55

Thanks Alan, I'll sort this out and the Nvidia one.    Greg, it looks like
you have two and three in 32.40, but not #1 (c5c69f) queued up, in
case that saves you looking.

P.


>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
