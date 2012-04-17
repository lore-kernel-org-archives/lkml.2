Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2DQQ0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:26:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57248 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2DQQ0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:26:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120416225520.GD9756@moon>
References: <20120416225520.GD9756@moon>
Date: Tue, 17 Apr 2012 09:26:07 -0700
X-Google-Sender-Auth: s40NuyDdMYOBMloJWSCMkf1-SjY
Message-ID: <CAGXu5jKHZSXXxWQdkQ2d0-soaUkQys85XjQ1M2Fx_hg5vTrs2Q@mail.gmail.com>
Subject: Re: [PATCH c/r -mm] c/r: prctl: Simplify PR_SET_MM on mm::code/data assignment
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 3:55 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> The mm::start_code, end_code, start_data, end_data members
> are set during startup of executable file and are not changed
> after.
>
> But the program itself might map new executable or/and data areas in
> time so the original values written into mm fields mentioned above
> might not have correspond VMA area at all, thus if one try to
> use this prctl codes without underlied VMA, the error will be
> returned.

Hrm, what is the utility of these fields then? If they're not "real",
should the kernel even bother tracking it at all? (Or, should it be
fixed to actually do something useful?)

-Kees

-- 
Kees Cook
ChromeOS Security
