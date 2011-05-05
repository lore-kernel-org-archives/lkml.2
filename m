Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1EEVod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 17:44:33 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60068 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab1EEVob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 17:44:31 -0400
X-Nat-Received: from [202.181.97.72]:58905 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1304631825.5221
To: paul.moore@hp.com, sam@synack.fr
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        hadi@cyberus.ca, kaber@trash.net, zbr@ioremap.net, root@localdomain.pl
Subject: Re: [RFC v3 02/10] Revert "lsm: Remove the socket_post_accept() hook"
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1304432663-1575-1-git-send-email-sam@synack.fr>
	<201105031802.34724.paul.moore@hp.com>
	<201105041128.BAB13061.LMHVtOSOQOFFJF@I-love.SAKURA.ne.jp>
	<201105051011.32845.paul.moore@hp.com>
In-Reply-To: <201105051011.32845.paul.moore@hp.com>
Message-Id: <201105060643.JBD90633.MOQJtSFFLFHOOV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 6 May 2011 06:43:42 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 05052011 #5380428, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore wrote:
> On Tuesday, May 03, 2011 10:28:24 PM Tetsuo Handa wrote:
> > Paul Moore wrote:
> > > On Tuesday, May 03, 2011 10:24:15 AM Samir Bellabes wrote:
> > > > snet needs to reintroduce this hook, as it was designed to be: a hook
> > > > for updating security informations on objects.
> > > 
> > > Looking at this and 5/10 again, it seems that you should be able to do
> > > what you need with the sock_graft() hook.  Am I missing something?
> > > 
> > > My apologies if we've already discussed this approach previously ...
> > 
> > Second problem is that genlmsg_unicast() might return -EAGAIN because we
> > can't sleep inside write_lock_bh()/write_unlock_bh().
> 
> Ah yes, the real problem.  I forgot that snet relied on a user space tool.  I 
> tend to agree with others who have suggested this is not the right approach, 
> but I understand why you want the post_accept() hook; thanks for reminding me.
> 
However, it sounds that Samir says genlmsg_unicast() failure is not fatal.

Samir Bellabes wrote:
> using snet_do_send_event() means that system is sending data to
> userspace. the system is not waiting for a verdict from userspace.
> 
> If error occurs, we actually loose the information data.
> I may be able to write a solution which try to send the data again, but
> we need a exit solution for this loop (a number of try ?).

If genlmsg_unicast() failure is not fatal, snet doesn't need the
socket_post_accept hook. Samir, is genlmsg_unicast() failure fatal for snet?
(Although, I'd like to ask for revival of the hook for TOMOYO anyway.)
