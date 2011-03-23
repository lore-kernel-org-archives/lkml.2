Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1CWDwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:52:00 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59645 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1CWDv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:51:58 -0400
X-Nat-Received: from [202.181.97.72]:63618 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1300852313.16187
Message-Id: <201103230351.p2N3pqSG086890@www262.sakura.ne.jp>
Subject: Re: [PATCH][RFC] Null short-circuit for selinux_cred_free()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: jj@chaosbits.net
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Mar 2011 12:51:52 +0900
References: <alpine.LNX.2.00.1103212215230.23432@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1103212215230.23432@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 22032011 #5128797, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Let selinux_cred_free accept NULL pointers.
No need to do so.

> If we don't do this, then we can crash if someone manages to pass NULL to 
> cred_free. Seems to me it's better to just do nothing in that case rather 
> than crash.
If cred == NULL, put_cred_rcu(NULL) causes the kernel to panic before calling
LSM hooks.
