Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584Ab2FUWDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:03:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55909 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760494Ab2FUWDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120621221858.25b8be67@pyramind.ukuu.org.uk>
References: <20120621194319.GA5961@www.outflux.net>
	<20120621221858.25b8be67@pyramind.ukuu.org.uk>
Date: Thu, 21 Jun 2012 15:03:42 -0700
X-Google-Sender-Auth: peNBs3JKjtbzkEpJNcHlZDJXhDo
Message-ID: <CAGXu5jJhOQWBxasT+QbQnMPsZmG1OoU=q+N2zRywzK9fCd39WA@mail.gmail.com>
Subject: Re: [PATCH] fs: make dumpable=2 only write to a pipe
From: Kees Cook <keescook@chromium.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>, Marcel Holtmann <marcel@holtmann.org>,
        Doug Ledford <dledford@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 2:18 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 21 Jun 2012 12:43:19 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> When the suid_dumpable sysctl is set to "2", and there is no
>> core dump pipe defined in the core_pattern sysctl, a local user
>> can cause core files to be written to root-writable directories,
>> potentially with user-controlled content. This means an admin
>> can unknowningly reintroduce a variation of CVE-2006-2451 (see
>> abf75a5033d4da7b8a7e92321d74021d1fcfb502).
>
> Its intended to work the way it does. It's also ABI. I think pipe-only is
> a really good idea. Likewise I accept with the pipe feature nowdays there
> is a good case to kill off case 2.
>
> However I don't think magically turning one into the other is sensible,
> in fact its *stupid* IMHO because it's asking systems to get unexpected
> behaviour.
>
> I would much rather see case 2 either left as is, or set to return
> -EINVAL (or similar) and a new case 3 for pipe only.

If mode 2 switches to -EINVAL, setuid dumps won't be written to disk,
and won't go to pipes. If mode 2 switches to pipe-only, only disk
dumps go missing. Either change seems like a break from the prior
behavior, but the latter seems the least disruptive to me.

I'm happy to go the -EINVAL route and add mode 3 (which will just be
mode 2 renamed) if that really is more acceptable.

-Kees

-- 
Kees Cook
Chrome OS Security
