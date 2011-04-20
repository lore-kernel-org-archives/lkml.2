Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1DTXvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 19:51:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52022 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1DTXvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 19:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:cc
         :content-type:content-transfer-encoding;
        b=kJXAXhOSRsOjwT7QTgGd3d4TLUklh7GJHil83NvJsINsVsJgjwgW8lQuH1//QqqC4Q
         h5lFwPjZ1UBTXx/pBGElYJFlUAe49enXDyflnexMhX9C/T0s6wG5FDenhqZM6Df78YV+
         ASnP/q/g6GYMyMOaQeLMdG1sa+Jy57xoQriY4=
MIME-Version: 1.0
In-Reply-To: <20110419143548.GA26461@hallyn.com>
References: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
	<20110417180722.GA21112@hallyn.com>
	<BANLkTinumLPEsstxP9px9=K23SUR9e2aRw@mail.gmail.com>
	<20110418082838.GA30088@hallyn.com>
	<BANLkTi=kxpFkQ86ZGd2_q+XFRm-nVWzw4g@mail.gmail.com>
	<20110418220232.GA15967@hallyn.com>
	<BANLkTikJqgwGixtgXKOY-2e=1sAQYUtbcQ@mail.gmail.com>
	<BANLkTimELd0WhNYkaQOQuV1vnr+5jAgTZA@mail.gmail.com>
	<20110419143548.GA26461@hallyn.com>
Date: Thu, 21 Apr 2011 08:51:40 +0900
Message-ID: <BANLkTimMGm=Qd-exvKmwJdh4pGRscRTHVw@mail.gmail.com>
Subject: Re: Linux capabilities shouldn't be lost during setuid to non-root
 from root or to another non-root uid from a non-root uid.
From: crocket <crockabiscuit@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrew Morgan <morgan@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 11:35 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting crocket (crockabiscuit@gmail.com):
>> Thanks for the precious information.
>>
>> I think capsh should be introduced somewhere in some manuals.


     Yes I think mentioning capsh in capabilities(7) would be a good idea.


>
> Would mentioning capsh in capabilities(7) be a good idea?
>
>> On Tue, Apr 19, 2011 at 10:14 AM, crocket <crockabiscuit@gmail.com> wrote:
>> > Is there an existing utility that sets SECBIT_NO_SETUID_FIXUP?
>> > Or is there a way to set it without writing a C wrapper program?
>> >
>> > On Tue, Apr 19, 2011 at 7:02 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
>> >> Quoting crocket (crockabiscuit@gmail.com):
>> >>> I have several questions.
>> >>>
>> >>> 1) How do I set SECBIT_NO_SETUID_FIXUP?
>> >>
>> >> prctl(PR_SET_SECUREBITS, SECBIT_NO_SETUID_FIXUP | SECBIT_NO_SETUID_FIXUP_LOCKED)
>> >>
>> >> see capabilities(7) for details.
>> >>
>> >>> 2) Is there any reason to unset SECBIT_NO_SETUID_FIXUP by default?
>> >>
>> >> Yes, because it's what userspace expects.  If you prefer to run in
>> >> a full POSIX capabilities environment with unprivileged root, you
>> >> can have init set SECBIT_NO_SETUID_FIXUP and SECBIT_NOROOT and
>> >> tune userspace to do the right thing, but it's not trivial.
>> >>
>> >> -serge
>> >>
>> >
>
