Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab1EFR1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:27:21 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:45325 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1EFR1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:27:19 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Samir Bellabes <sam@synack.fr>
Subject: Re: [RFC v3 02/10] Revert "lsm: Remove the socket_post_accept() hook"
Date: Fri, 6 May 2011 13:27:15 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r2; KDE/4.6.2; x86_64; ; )
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        hadi@cyberus.ca, kaber@trash.net, zbr@ioremap.net, root@localdomain.pl
References: <1304432663-1575-1-git-send-email-sam@synack.fr> <201105060643.JBD90633.MOQJtSFFLFHOOV@I-love.SAKURA.ne.jp> <87iptop4di.fsf@synack.fr>
In-Reply-To: <87iptop4di.fsf@synack.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105061327.15339.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 06, 2011 5:25:45 AM Samir Bellabes wrote:
> the main argument for socket_post_accept is to known informations of the
> remote inet.
> 
> from socket_accept(), we have no clue of who (inet->daddr and inet->saddr)
> is connecting to the local service. with socket_post_accept(), inet->daddr
> and inet->saddr are filled with the true distant informations.
> 
> This informations is interesting for next security operations on the
> socket. (we known with who we are talking to).

Looking at the snet_socket_post_accept() hook, I believe all of the 
information you are looking for should be available to you in the sock_graft() 
hook.

--
paul moore
linux @ hp
