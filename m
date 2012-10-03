Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2JCQNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:13:48 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40943 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab2JCQNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:13:46 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1210022236370.10573@chino.kir.corp.google.com>
References: <20121002234934.GA9194@www.outflux.net>
	<alpine.DEB.2.00.1210022209070.9523@chino.kir.corp.google.com>
	<CAGXu5j+ZU_wrqeEYE7GCE6ArFo8z4AO=OW7mOSn0-fp1E9B6+Q@mail.gmail.com>
	<alpine.DEB.2.00.1210022236370.10573@chino.kir.corp.google.com>
Date: Wed, 3 Oct 2012 09:13:45 -0700
X-Google-Sender-Auth: DhcUXnIaA8LTVJNqrhufojaADmA
Message-ID: <CAGXu5jL4Dd3jCusr+Du4q7tOhcsKaSQbW6u_ZN8ZSBry2AQARg@mail.gmail.com>
Subject: Re: [PATCH] mm: use %pK for /proc/vmallocinfo
From: Kees Cook <keescook@chromium.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Joe Perches <joe@perches.com>,
        Kautuk Consul <consul.kautuk@gmail.com>, linux-mm@kvack.org,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 10:37 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 2 Oct 2012, Kees Cook wrote:
>
>> >> In the paranoid case of sysctl kernel.kptr_restrict=2, mask the kernel
>> >> virtual addresses in /proc/vmallocinfo too.
>> >>
>> >> Reported-by: Brad Spengler <spender@grsecurity.net>
>> >> Signed-off-by: Kees Cook <keescook@chromium.org>
>> >
>> > /proc/vmallocinfo is S_IRUSR, not S_IRUGO, so exactly what are you trying
>> > to protect?
>>
>> Trying to block the root user from seeing virtual memory addresses
>> (mode 2 of kptr_restrict).
>>
>> Documentation/sysctl/kernel.txt:
>> "This toggle indicates whether restrictions are placed on
>> exposing kernel addresses via /proc and other interfaces.  When
>> kptr_restrict is set to (0), there are no restrictions.  When
>> kptr_restrict is set to (1), the default, kernel pointers
>> printed using the %pK format specifier will be replaced with 0's
>> unless the user has CAP_SYSLOG.  When kptr_restrict is set to
>> (2), kernel pointers printed using %pK will be replaced with 0's
>> regardless of privileges."
>>
>> Even though it's S_IRUSR, it still needs %pK for the paranoid case.
>
> So root does echo 0 > /proc/sys/kernel/kptr_restrict first.  Again: what
> are you trying to protect?

Only CAP_SYS_ADMIN can change the setting. This is, for example, for
containers, or other situations where a uid 0 process lacking
CAP_SYS_ADMIN cannot see virtual addresses. It's a very paranoid case,
yes, but it's part of how this feature was designed. Think of it as
supporting the recent uid 0 vs ring 0 boundary. :)

-Kees

-- 
Kees Cook
Chrome OS Security
