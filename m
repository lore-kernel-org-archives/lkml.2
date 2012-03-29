Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab2C2S1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:27:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63699 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221Ab2C2S1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJPx4ROsyn3TDwpjAD0r150rDf54Y5heyVEHjShgXcT9g@mail.gmail.com>
References: <20120323233212.GA18484@www.outflux.net>
	<4F6F6839.6020605@schaufler-ca.com>
	<CAGXu5jJB8nD1LJSJSDx2CF_j_-uLKOmq++2OHBVvXhvao37EeQ@mail.gmail.com>
	<4F70A067.9070907@schaufler-ca.com>
	<CAGXu5jJPx4ROsyn3TDwpjAD0r150rDf54Y5heyVEHjShgXcT9g@mail.gmail.com>
Date: Thu, 29 Mar 2012 11:27:35 -0700
X-Google-Sender-Auth: psGTXpMGc8cGqGLANSPxuiaKeuA
Message-ID: <CAGXu5jLv1kRjYt1OuiSo1so2DFchVz++ug-x8mBgVJfcizYcsA@mail.gmail.com>
Subject: Re: [PATCH] audit: always report seccomp violations
From: Kees Cook <keescook@chromium.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Casey Schaufler <casey@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 10:02 AM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Mar 26, 2012 at 9:59 AM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 3/26/2012 8:56 AM, Kees Cook wrote:
>>> On Sun, Mar 25, 2012 at 11:47 AM, Casey Schaufler
>>> <casey@schaufler-ca.com> wrote:
>>>> On 3/23/2012 4:32 PM, Kees Cook wrote:
>>>>> When a program violates its own seccomp rules, that is a pretty dire
>>>>> situation, and the audit message should always be reported (not just
>>>>> when there is already a rule active for the process).
>>>> Hmm. If the program is never going to violate its own
>>>> seccomp rules it seems sort of silly to have them in the
>>>> first place, doesn't it? Oh, I know that the expectation
>>>> of seccomp is that the application would only try something
>>>> you've disallowed if it gets compromised. Problem is that
>>> Well, either compromised or doing something new (e.g. a library in the
>>> code has changed).
>>>
>>>> Modern Programmers tend to rely very heavily on the opaque
>>>> behavior of APIs that they don't understand nor particularly
>>>> care if they understand. When assumptions are made about the
>>>> behavior of the API code, and the API code changes, as
>>>> occurs with amazing frequency on today's mobile devices,
>>>> there are going to be surprises. I would wager that the
>>>> modern frequency of API changes will result in this behavior
>>>> being very unpopular.
>>> You seem to be advocating for my patch -- instead of the program
>>> "silently" getting killed, now there will be notification. A seccomp
>>> failure is extremely uncommon; much less common that core dumps. This
>>> is why it should always be reported -- it is uncommon and important to
>>> notice.
>>
>> Silence is golden. The situation that I am concerned with is one where
>> a library changes and a program preforms an action that results in a
>> violation. The application runtime environment notices the applications
>> demise and restarts it, resulting in a repeat of the violation.
>>
>> In a classic computer environment you would want the log filled with
>> notifications so that the user could do something about it. On a
>> phone, settop box, TV set or seatback entertainment system logging is
>> evil. No one who has any business seeing a log message has any desire
>> to see one. It does not matter how important the log message might be.
>>
>> It's getting harder and harder to have rational error handling at the
>> OS level as application environments move to higher levels and greater
>> abstraction. Because seccomp is an OS interface level facility there
>> are going to be many cases where it fails to align with the intent of
>> its highly abstracted users. When it does, the programmers are not
>> going to look at the OS level logs, they are going to look at the API
>> definitions and such.
>>
>> In the end I am opposed to any logging that can't be turned off. There
>> is enough difference in environments and expectations that you can't
>> say that something should always be reported. I am not saying that I
>> approve of this situation, but it is clear that most modern application
>> developers want to hear as little from the OS as possible. Even in
>> cases where they should be paying attention.
>
> Handling logging output is up to the system owner. Already all
> segfaults are reported to dmesg. Seccomp violation is a much less
> common case, so I think the benefit outweighs the potential for
> "clutter". If a system owner wants to ignore klog, they can go ahead
> and do so. :)

Eric, do you have thoughts on this? I'd really like to see seccomp
failures regardless of audit daemon state.

-Kees

-- 
Kees Cook
ChromeOS Security
