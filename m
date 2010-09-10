Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab0IJPHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:07:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754286Ab0IJPHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:07:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100909140439.C945.A69D9226@jp.fujitsu.com>
References: <20100908023417.8B055401AF@magilla.sf.frob.com>
 <20100909134842.C93F.A69D9226@jp.fujitsu.com> <20100909140439.C945.A69D9226@jp.fujitsu.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Sep 2010 08:06:41 -0700
Message-ID: <AANLkTik=ZpiCN-5YfWJ6zejSJBknL8Sj4Vtc+X_XpS71@mail.gmail.com>
Subject: Re: [PATCH 2/2] execve: check the VM has enough memory at first
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net>, Eugene Teo" 
	<eugene@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 10:04 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> After this patch, execve() expand stack at first and receive to
> check vm_enough_memory() properly. then, too long argument of
> execve() than the machine memory return EFAULT properly.

This is horrible. We don't want to walk the arguments one more time
just for this. Let's just improve the checks that we do as we go
along.

                            Linus
