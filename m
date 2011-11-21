Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab1KUSka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:40:30 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46869 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1KUSk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:40:27 -0500
MIME-Version: 1.0
In-Reply-To: <20111119165903.GB2208@openwall.com>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<1319672956-17114-4-git-send-email-keescook@chromium.org>
	<20111119163058.GA3131@albatros>
	<20111119165903.GB2208@openwall.com>
Date: Mon, 21 Nov 2011 10:40:25 -0800
X-Google-Sender-Auth: ZyYb8jSoLYXCqmKrEUQ2odGaNfk
Message-ID: <CAGXu5j+C-LQT2z+J3jEJYmftt1jOnMujNjKqgy0JFwM7b_FPjQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] security: Yama: add ptrace relationship tracking interface
From: Kees Cook <keescook@chromium.org>
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 8:59 AM, Solar Designer <solar@openwall.com> wrote:
> On Sat, Nov 19, 2011 at 08:30:58PM +0400, Vasiliy Kulikov wrote:
>> On Wed, Oct 26, 2011 at 16:49 -0700, Kees Cook wrote:
>> > +   if (mode == PTRACE_MODE_ATTACH &&
>> > +       ptrace_scope &&
>> > +       !capable(CAP_SYS_PTRACE) &&
>> > +       !task_is_descendant(current, child) &&
>> > +       !ptracer_exception_found(current, child))
>> > +           rc = -EPERM;
>>
>> capable() is better to put after all other tests
>
> Right, but...
>
>> as a failed capable()
>> might emit a false positive warning into logs or something.
>
> ...primarily for another reason: a successful capable() sets
> PF_SUPERPRIV, whereas the permission might have been granted without
> capable() as well.  The PF_SUPERPRIV flag is visible via BSD process
> accounting.

Fair point, I'll move it. I had to go look up an earlier thread since
this was ringing a bell, but in there I was talking about moving it to
the end of the tests too. :)

https://lkml.org/lkml/2010/6/30/5

-Kees

-- 
Kees Cook
ChromeOS Security
