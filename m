Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab1CWVHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:07:46 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24116 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1CWVHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:07:44 -0400
Date: Wed, 23 Mar 2011 22:07:38 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Null short-circuit for selinux_cred_free()
In-Reply-To: <201103230351.p2N3pqSG086890@www262.sakura.ne.jp>
Message-ID: <alpine.LNX.2.00.1103232207120.20169@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1103212215230.23432@swampdragon.chaosbits.net> <201103230351.p2N3pqSG086890@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, Tetsuo Handa wrote:

> Jesper Juhl wrote:
> > Let selinux_cred_free accept NULL pointers.
> No need to do so.
> 
> > If we don't do this, then we can crash if someone manages to pass NULL to 
> > cred_free. Seems to me it's better to just do nothing in that case rather 
> > than crash.
> If cred == NULL, put_cred_rcu(NULL) causes the kernel to panic before calling
> LSM hooks.

Good point. Thanks.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

