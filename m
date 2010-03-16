Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab0CPUhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:37:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55342 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab0CPUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OxTES7pv44Y1w8Hjz/+nUdnT9BMlBm/d4oCDXCqXPvGs5QzCLDg3hbM4ocgERUJ7so
         L5mqyuDr1UsxZBiFQ4/0fzQYqKkhDTYUY1g0lZfUVfwxnmoAx2EM2xEVnLqt0ZXPmdf+
         aby51ZxZcj/h4Gazk0aX4QIFOh7B5gBCJ5uKw=
MIME-Version: 1.0
In-Reply-To: <4B9FD11E.5050108@gmail.com>
References: <4B9F86E9.2030702@gmail.com> <43e72e891003160918x3b7e3c9asf4fc8a9db35ccd8a@mail.gmail.com> 
	<4B9FD11E.5050108@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 16 Mar 2010 13:36:38 -0700
Message-ID: <43e72e891003161336t1c2f905w13762dfa49257450@mail.gmail.com>
Subject: Re: regd: sleeping in atomic
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 11:42 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 03/16/2010 05:18 PM, Luis R. Rodriguez wrote:
>>
>> one iteration of call_crda() which happens during module
>> initialization and from what I gather I don't think the kernel is
>> happy when you mutex_lock on load routines, please correct my foggy
>> memory if I am mistaken.
>
> No, using mutex in init/exit module routines is fine. Where do you have the
> information from?

A snag I hit when trying this a while ago on reg.c. I suppose the real
issue could have been something else.

> There might be problems only with request_module,
> flush_scheduled_work or similar.

OK -- then in that case I think using a mutex would work here, unless
John spots any other issues.

  Luis
