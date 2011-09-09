Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab1IIM3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758784Ab1IIM3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:29:08 -0400
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in
 'data'
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 09 Sep 2011 14:28:55 +0200
In-Reply-To: <201109091212.59889.pedro@codesourcery.com>
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com>
	 <201109091212.59889.pedro@codesourcery.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1315571337.4127.3.camel@dhcp-25-63.brq.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 12:12 +0100, Pedro Alves wrote:
> On Thursday 08 September 2011 19:22:04, Denys Vlasenko wrote:
> > Make PTRACE_SEIZE set ptrace options specified in 'data' parameter
> >     
> > This can be used to close a few corner cases in strace where we get
> > unwanted racy behavior after attach, but before we have a chance
> > to set options (the notorious post-execve SIGTRAP comes to mind),
> 
> I'm still confused on why you're raising the SIGTRAP argument.  Did you see
> 
>  https://lkml.org/lkml/2011/9/8/7
> 
> From previous discussions, I understood that PTRACE_SEIZE _always_
> disables
> the post-execve SIGTRAP, so I don't believe that race actually exists.
> Or is that not the case?


I believe it is not the case. And I object to making it the case.
My sense of taste says the approach "you need to use SEIZE to affect
feature <foo>" for various unrelated <foo> makes ptrace API ugly.
Especially that in this case, we already have a method in API
to suppress post-execve SIGTRAP.

-- 
vda


