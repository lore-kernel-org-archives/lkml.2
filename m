Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab2AMS4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:56:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab2AMS43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:56:29 -0500
Message-ID: <1326480891.4342.7.camel@localhost>
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from
 granting privs
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@MIT.EDU, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net
Date: Fri, 13 Jan 2012 13:54:51 -0500
In-Reply-To: <20120113182422.28e648fb@pyramind.ukuu.org.uk>
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
	 <20120113164547.GA22061@redhat.com>
	 <20120113182422.28e648fb@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-13 at 18:24 +0000, Alan Cox wrote:
> This still appears to be a bit broken
> 
> There are three problems here
> 
> 1. I can stop an app changing privs which in some SELinux or APParmour
> cases might mean I prevent it being dropped into a less privileged
> position. That's something only the security policy knows.
> 
> So for SELinux and Apparmour and the like in some situations you are
> potentially adding a security hole. That one seems hard to fix unless you
> fail the exec if it causes a security transition, as opposed to just
> keeping the old one. For non change cases we can however still pass the
> filter on, which is the usual sane case.

I can't speak about AppArmour at all, but not transitioning in SELinux
(the same as MNT_NOSUID) is safe since policy will still make a security
decision if you are allowed to launch the binary without transitioning.
I have thoughts on how to make the SELinux approach more flexible and
policy controlled, but I'd be fine with this flag just applying no
transition for now and adding that as a new feature down the road.

