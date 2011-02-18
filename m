Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab1BRXpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 18:45:05 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:39225 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1BRXpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 18:45:02 -0500
Message-ID: <4D5F0472.4000403@free.fr>
Date: Sat, 19 Feb 2011 00:44:50 +0100
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
Subject: Re: [PATCH 2/9] security: Make capabilities relative to the user
 namespace.
References: <20110217150224.GA26334@mail.hallyn.com> <20110217150306.GB26395@mail.hallyn.com>
In-Reply-To: <20110217150306.GB26395@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 04:03 PM, Serge E. Hallyn wrote:
> - Introduce ns_capable to test for a capability in a non-default
>    user namespace.
> - Teach cap_capable to handle capabilities in a non-default
>    user namespace.
>
> The motivation is to get to the unprivileged creation of new
> namespaces.  It looks like this gets us 90% of the way there, with
> only potential uid confusion issues left.
>
> I still need to handle getting all caps after creation but otherwise I
> think I have a good starter patch that achieves all of your goals.
>
> Changelog:
> 	11/05/2010: [serge] add apparmor
> 	12/14/2010: [serge] fix capabilities to created user namespaces
> 	Without this, if user serge creates a user_ns, he won't have
> 	capabilities to the user_ns he created.  THis is because we
> 	were first checking whether his effective caps had the caps
> 	he needed and returning -EPERM if not, and THEN checking whether
> 	he was the creator.  Reverse those checks.
> 	12/16/2010: [serge] security_real_capable needs ns argument in !security case
> 	01/11/2011: [serge] add task_ns_capable helper
> 	01/11/2011: [serge] add nsown_capable() helper per Bastian Blank suggestion
> 	02/16/2011: [serge] fix a logic bug: the root user is always creator of
> 		    init_user_ns, but should not always have capabilities to
> 		    it!  Fix the check in cap_capable().
>
> Signed-off-by: Eric W. Biederman<ebiederm@xmission.com>
> Signed-off-by: Serge E. Hallyn<serge.hallyn@canonical.com>
> ---

Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>

