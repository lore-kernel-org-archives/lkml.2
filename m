Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1FTUD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:03:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43525 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1FTUD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=fAWXpTpcpwUEZMt5a6BzjvvFPMY49m1qZEaphEDhV5Ac2gTzrOP+ct2T3cKsNBNFQs
         YM14UOCESe2c+2wtsJfQ==
MIME-Version: 1.0
In-Reply-To: <4DFFA6B8.50506@fusionio.com>
References: <1308599559-16839-1-git-send-email-teravest@google.com> <4DFFA6B8.50506@fusionio.com>
From: Justin TerAvest <teravest@google.com>
Date: Mon, 20 Jun 2011 13:03:34 -0700
Message-ID: <BANLkTin6yt5PCG1uOamGiGjU++tznQNkAcdTGfNDOhLQvU-1=g@mail.gmail.com>
Subject: Re: [PATCH] cfq: Remove special treatment for metadata rqs.
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 12:59 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-06-20 21:52, Justin TerAvest wrote:
>> There is no consistency among filesystems from what bios (or requests)
>> are marked as being metadata. It's interesting to expose this in traces,
>> but we shouldn't schedule the requests differently based on whether or
>> not they're marked as being metadata.
>
> Agree, we should kill that. What is this patch against? cfq_choose_req()
> also has a "choose meta over non-meta" preference.

This is against for-3.1. Let me know if you want it against something else.

Sorry, I missed the preference in cfq_choose_req, since it changed to
be clever about bit operations. I'll send a v2 patch that cleans that
use up as well.

>
> --
> Jens Axboe
>
>
