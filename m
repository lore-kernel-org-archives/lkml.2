Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1CEOZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 09:25:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57946 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1CEOZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 09:25:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YUOMyAmsWXQNDeSZE9TmzTUReZX/L2sMICLw8QyyDHl4lLv5vyNk/Orfm3oq39xYtw
         nQbD9Z+Rvh1mqqcb89LH55+X+4bzt4v0Vo9RoLdVRokQ2zjMtf1R5qDj0q4VO0jRgIX5
         T3eCj+69Lgvdrd2t28krtUtztBFZW7QlMg/X8=
MIME-Version: 1.0
Date: Sat, 5 Mar 2011 16:25:35 +0200
Message-ID: <AANLkTim9hWBfaPrqWpsKD9dYDAGY47i-ggA0FRrk-ey7@mail.gmail.com>
Subject: LSM hooks: which to use? .socket_sock_rcv_skb or .socket_sendmsg?
From: =?KOI8-R?B?SWdvciAnTG8nICjpLkwuKQ==?= <bombsiteunrested@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

I need to capture outgoing TCP packet and modify it using LSM
framework (and not Netfilter).

First, which hooks will work for outgoing packets, preferably before
Netfilter comes in play (actually there was a note that some LSM hooks
reuse Netfilter's, but don't know the right order)?

Second, can .socket_sendmsg provide the access to structures
containing both packet payload and TCP header? Does even
.socket_sock_rcv_skb provide those structures via some skb?

/* It's the old story about trying to modify packet size so they got
larger that IP fragmentation limit and get another set of SEQ/ACK,
that is almost broken behind documentation in default NFQUEUE target
and makes me to successfully lurk with tcp_output.c hacks rather than
wishing to write NF modules. (TCPOPTSTRIP target is next to explore,
but first want to get the best joy of System.map and LSM tricks) */
-- 
cheers,
Igor
