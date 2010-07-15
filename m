Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab0GOPSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:18:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64116 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab0GOPSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:18:04 -0400
MIME-Version: 1.0
In-Reply-To: <1279154621-25868-3-git-send-email-john.johansen@canonical.com>
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
	<1279154621-25868-3-git-send-email-john.johansen@canonical.com>
Date: Thu, 15 Jul 2010 11:18:03 -0400
Message-ID: <AANLkTimGhmUiCMMWaDs5aV4Hg86QvQJs3ZFUSqAdlKAt@mail.gmail.com>
Subject: Re: [PATCH 02/13] AppArmor: basic auditing infrastructure.
From: Eric Paris <eparis@parisplace.org>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 8:43 PM, John Johansen
<john.johansen@canonical.com> wrote:
> Update lsm_audit for AppArmor specific data, and add the core routines for
> AppArmor uses for auditing.
>
> Signed-off-by: John Johansen <john.johansen@canonical.com>

> + * Currently AppArmor auditing is fed straight into the audit framework.
> + *
> + * TODO:
> + * convert to LSM audit


TODO?

> +       if (sa->aad.profile) {
> +               struct aa_profile *profile = sa->aad.profile;
> +               pid_t pid;
> +               rcu_read_lock();
> +               pid = tsk->real_parent->pid;
> +               rcu_read_unlock();
> +               audit_log_format(ab, " parent=%d", pid);
> +               audit_log_format(ab, " profile=");
> +               if (profile->ns != root_ns) {
> +                       audit_log_format(ab, ":");
> +                       audit_log_untrustedstring(ab, profile->ns->base.hname);
> +                       audit_log_format(ab, "://");
> +               }
> +               audit_log_untrustedstring(ab, profile->base.hname);
> +       }

what does this message look like?  I don't think it fits the nice
key=value rules of the audit system....   Are you sure this is what
you want?

> +#define COMMON_AUDIT_DATA_INIT_NONE(_d) \
> +       do { \
> +               memset((_d), 0, sizeof(struct common_audit_data)); \
> +               (_d)->type = LSM_AUDIT_DATA_NONE; \
> +       } while (0)
> +
> +#endif /* __AA_AUDIT_H */

Why are you redefining this?  You should just use
COMMON_AUDIT_DATA_INIT(sa, NONE);
