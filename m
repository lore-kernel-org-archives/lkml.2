Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1LLUjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:39:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39070 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab1LLUi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:38:58 -0500
MIME-Version: 1.0
In-Reply-To: <20111212201715.244414996@openvz.org>
References: <20111212200642.836001668@openvz.org>
	<20111212201715.244414996@openvz.org>
Date: Mon, 12 Dec 2011 12:38:58 -0800
X-Google-Sender-Auth: d8VUUa9VHKZw7-2-JYEJ17EOFV4
Message-ID: <CAGXu5jLSrwLeWoQNAA5uyWEewugnr1cWrxzH=wD9JnvZwgAggw@mail.gmail.com>
Subject: Re: [patch 3/3] [PATCH] prctl: Add PR_SET_MM codes to set up
 mm_struct entires v3
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 12:06 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> When we restore a task we need to set up text, data and data
> heap sizes from userspace to the values a task had at
> checkpoint time. This patch adds auxilary prctl codes for that.
> ...
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Looks good; I like having this wrapped in CONFIG_CHECKPOINT_RESTORE.

> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +static int prctl_set_mm(int opt, unsigned long addr,
> +                       unsigned long arg4, unsigned long arg5)
> ...
> +#else /* CONFIG_CHECKPOINT_RESTORE */
> +static int prctl_set_mm(int opt, unsigned long addr)

These need to have matching argument lists.

Reviewed-by: Kees Cook <keescook@chromium.org>


-Kees

-- 
Kees Cook
ChromeOS Security
