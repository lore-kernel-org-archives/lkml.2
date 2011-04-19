Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1DSO1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:27:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43923 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab1DSO1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:27:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U0C4K3xXcl5xFaAIytjreha51hn+YbHKPj8wy1HCKErOZaHgk7PPX9JdHrGjxiEMd7
         ww7mFm81iGjnNMX69T8ovJ5gE0jIQ+wwWapMZUiNYP6M2TZz+CBTEJHYt163JBd46cEk
         UxjZjFsDNDJdSMU6H9axmC1u+HTBYtSGY9sfk=
MIME-Version: 1.0
In-Reply-To: <BANLkTikJqgwGixtgXKOY-2e=1sAQYUtbcQ@mail.gmail.com>
References: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
	<20110417180722.GA21112@hallyn.com>
	<BANLkTinumLPEsstxP9px9=K23SUR9e2aRw@mail.gmail.com>
	<20110418082838.GA30088@hallyn.com>
	<BANLkTi=kxpFkQ86ZGd2_q+XFRm-nVWzw4g@mail.gmail.com>
	<20110418220232.GA15967@hallyn.com>
	<BANLkTikJqgwGixtgXKOY-2e=1sAQYUtbcQ@mail.gmail.com>
Date: Tue, 19 Apr 2011 23:27:07 +0900
Message-ID: <BANLkTimELd0WhNYkaQOQuV1vnr+5jAgTZA@mail.gmail.com>
Subject: Re: Linux capabilities shouldn't be lost during setuid to non-root
 from root or to another non-root uid from a non-root uid.
From: crocket <crockabiscuit@gmail.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the precious information.

I think capsh should be introduced somewhere in some manuals.

On Tue, Apr 19, 2011 at 10:14 AM, crocket <crockabiscuit@gmail.com> wrote:
> Is there an existing utility that sets SECBIT_NO_SETUID_FIXUP?
> Or is there a way to set it without writing a C wrapper program?
>
> On Tue, Apr 19, 2011 at 7:02 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
>> Quoting crocket (crockabiscuit@gmail.com):
>>> I have several questions.
>>>
>>> 1) How do I set SECBIT_NO_SETUID_FIXUP?
>>
>> prctl(PR_SET_SECUREBITS, SECBIT_NO_SETUID_FIXUP | SECBIT_NO_SETUID_FIXUP_LOCKED)
>>
>> see capabilities(7) for details.
>>
>>> 2) Is there any reason to unset SECBIT_NO_SETUID_FIXUP by default?
>>
>> Yes, because it's what userspace expects.  If you prefer to run in
>> a full POSIX capabilities environment with unprivileged root, you
>> can have init set SECBIT_NO_SETUID_FIXUP and SECBIT_NOROOT and
>> tune userspace to do the right thing, but it's not trivial.
>>
>> -serge
>>
>
