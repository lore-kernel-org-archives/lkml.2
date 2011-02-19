Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab1BSRxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 12:53:00 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:60290 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab1BSRw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 12:52:59 -0500
Message-ID: <4D60036E.6040401@free.fr>
Date: Sat, 19 Feb 2011 18:52:46 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: xemul@parallels.com, containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        LSM <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 6/9] user namespaces: convert all capable checks in	kernel/sys.c
References: <20110217150224.GA26334@mail.hallyn.com> <20110217150342.GF26395@mail.hallyn.com>
In-Reply-To: <20110217150342.GF26395@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 04:03 PM, Serge E. Hallyn wrote:
> This allows setuid/setgid in containers.  It also fixes some
> corner cases where kernel logic foregoes capability checks when
> uids are equivalent.  The latter will need to be done throughout
> the whole kernel.
>
> Changelog:
> 	Jan 11: Use nsown_capable() as suggested by Bastian Blank.
> 	Jan 11: Fix logic errors in uid checks pointed out by Bastian.
> 	Feb 15: allow prlimit to current (was regression in previous version)
>
> Signed-off-by: Serge E. Hallyn<serge.hallyn@canonical.com>

Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>

>
> -	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
> +	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN)) {
> +		printk(KERN_NOTICE "%s: did not have CAP_SYS_ADMIN\n", __func__);
>   		return -EPERM;
> +	}
> +	printk(KERN_NOTICE "%s: did have CAP_SYS_ADMIN\n", __func__);

A couple of printk left here.


