Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab1BEHGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 02:06:05 -0500
Received: from mail.lang.hm ([64.81.33.126]:52623 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab1BEHGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 02:06:04 -0500
Date: Fri, 4 Feb 2011 23:05:55 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Gergely Nagy <algernon@balabit.hu>, James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
In-Reply-To: <20110204171502.GA24226@mail.hallyn.com>
Message-ID: <alpine.DEB.2.00.1102042301420.8162@asgard.lang.hm>
References: <1296733177.14846.26.camel@moria> <20110203153252.GA24153@mail.hallyn.com> <20110204160513.GB17396@mail.hallyn.com> <1296837186.24742.15.camel@moria> <20110204171502.GA24226@mail.hallyn.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011, Serge E. Hallyn wrote:

> Quoting Gergely Nagy (algernon@balabit.hu):
>> On Fri, 2011-02-04 at 16:05 +0000, Serge E. Hallyn wrote:
>>> Quoting Serge E. Hallyn (serge@hallyn.com):
>>>>> From 2d7408541dd3a6e19a4265b028233789be6a40f4 Mon Sep 17 00:00:00 2001
>>>> From: Serge Hallyn <serge@peq.(none)>
>>>>
>>>> At 2.6.39 or 2.6.40, let's add a sysctl which defaults to 0.  When
>>>> 0, refuse if cap_sys_admin, if 1, then allow.  This will allow
>>>> users to acknowledge (permanently, if they must, using /etc/sysctl.conf)
>>>> that they've seen the syslog message about cap_sys_admin being
>>>> deprecated for syslog.
>>>>
>>>> Signed-off-by: Serge Hallyn <serge@hallyn.com>
> -			goto warn; /* switch to return -EPERM after 2.6.39 */
> +		     !capable(CAP_SYSLOG)) {
> +			/* remove after 2.6.39 */
> +			if (capable(CAP_SYS_ADMIN))
> +				WARN_ONCE(1, "Attempt to access syslog with CAP_SYS_ADMIN "
> +				  "but no CAP_SYSLOG (deprecated).\n");
> +			else
> +				return -EPERM;
> +		}
> 	}

why does this need to be removed after 2.6.39?

whenever you go to remove it you will break userspace, what's the benifit 
of breaking userspace?

I can understand that it's better to have a syslog daemon with CAP_SYSLOG 
instead of CAP_SYS_ADMIN, but does "it would be better to have userspace 
changed" really translate into "it's so important to have userspace 
changed that we need to break any userspace that hasn't changed"?

I really don't think so.

David Lang
