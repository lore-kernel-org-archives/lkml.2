Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1EQHkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:40:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64452 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab1EQHkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:40:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PRO2k67SF5/h3nro9s9f2P+Eye7gUuJ+5UYb8fn+q+tandmq1jpa2zay9AeLti/uVt
         Frop3ou32OPMNmWjLah3UzO6cWK9PGJ0Hb3hvgMxvTBh1/wrp/RCobuggkLP1fvSw6/p
         f8iPjEZHce37hg4ZSB4IilUjF6vcuva87VVGg=
From: Benoit Sigoure <tsunanet@gmail.com>
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tcp: Expose the initial RTO via a new sysctl.
Date: Tue, 17 May 2011 00:40:19 -0700
Message-Id: <1305618020-72535-1-git-send-email-tsunanet@gmail.com>
X-Mailer: git-send-email 1.7.0.2.157.gb7e7f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
it's not easy to change the initial RTO of TCP as right now you need to
recompile your kernel.  In order to make it easier to tune this setting,
I was wondering whether you would consider turning it into a sysctl.  I
attached a first attempt at a patch that does this -- this is my first
patch to the Linux kernel so although I've read SubmitChecklist and
SubmittingPatches, and I've run checkpatch.pl, please let me know if I'm
doing something wrong.

I am doing this because I work in a high-throughput low-latency environment
(line-rate GbE with submillisecond RTT) and some of our clients are negatively
affected by the high initial RTO when the servers are unable to accept() new
connections fast enough.  While we're working on fixing these servers and/or
giving them larger backlog queues when they listen(), being able to tune
the initial RTO at runtime would be very useful as quick workaround for the
server-side issues.

Some large Internet websites are also running with a more aggressive initial
RTO, for instance Google documented some of what they're doing here:
  http://www.ietf.org/proceedings/75/slides/tcpm-1.pdf
While I'm not arguing to change the default value at this time, I believe
that this patch would also come in handy for those who wish to experiment
with various values in their environment.

If you're willing to consider this patch, bear in mind I only compiled it,
I didn't test it yet (not knowing whether you'd want something like that or
not).  I would also appreciate if anyone had any insight on what I did with
`COUNTER_TRIES' in `syncookies.c' as this magic constant is rather mysterious
and the comment didn't help me figure out how it had been derived.  I couldn't
find anything online and git blame didn't help me either (it pre-dates Git).

