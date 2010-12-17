Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab0LQQAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:00:19 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:55305 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab0LQQAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:00:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kKLyY2BeEolGsaxD/TbHMpjUe+gmEXxsy643tIyUx157HkgXn5XimFCR+Rm0+uuxiL
         sBt2FNEu2KLXhRk9TdBcMcFOtLdflmc6YuXhbZMsfYHbc18anzVHBmsA9Gs7kdKgXICC
         qykIzK7uBOpogXsYIX5n8OTcsMFgR3gZZVhoQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinPBAPjeEdhn21JN6zVpAKDHR9=3gszj84CyyNx@mail.gmail.com>
References: <20101217152246.GA8221@mail.hallyn.com>
	<20101217152458.GA11162@mail.hallyn.com>
	<AANLkTinPBAPjeEdhn21JN6zVpAKDHR9=3gszj84CyyNx@mail.gmail.com>
Date: Fri, 17 Dec 2010 18:00:17 +0200
Message-ID: <AANLkTik2ry7zbRMgiwhrXMYfQ4tr07BW0ODCNbKBMWmc@mail.gmail.com>
Subject: Re: [RFC 1/5] user namespaces: Add a user_namespace as creator/owner
 of uts_namespace
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 5:56 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Fri, Dec 17, 2010 at 5:24 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
>> +/*
>> + * userns count is 1 for root user, 1 for init_uts_ns,
>> + * and 1 for... ?
>> + */
>>  struct user_namespace init_user_ns = {
>>        .kref = {
>> -               .refcount       = ATOMIC_INIT(2),
>> +               .refcount       = ATOMIC_INIT(3),
>
> +1 is for init_nsproxy ;-)

Err, no.

+1 is to ensure it's never freed, but since allocator will BUG_ON (?) if fed
with static object, maybe it's completely bogus.
