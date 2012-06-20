Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab2FTObH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:31:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44055 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab2FTObF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:31:05 -0400
MIME-Version: 1.0
Date: Wed, 20 Jun 2012 22:31:03 +0800
Message-ID: <CAAA3+BpRQ24HED6a+yCF+A_q=vJ7nHexLJd1U+-50pb43MVa5w@mail.gmail.com>
Subject: How does SACK or FACK determine the time to start fast retransmition?
From: LovelyLich <lovelylich@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI all,
    When tcp uses reno as its congestion control algothim, it uses
tp->sacked_out as dup-ack. When the third dup-ack(under default
condition) comes, tcp will initiate its fast retransmition.
    But how about sack ?
    According to kernel source code comments, when sack or fack tcp option
is enabled, there is no dup-ack counter. See comments for function
tcp_dupack_heuristics():
http://lxr.linux.no/linux+v2.6.37/net/ipv4/tcp_input.c#L2300
    So , how does tcp know the current dup-ack is the last one which
triggers the fast retransmition?

    According to rfc3517 section 5:
    "Upon the receipt of the first (DupThresh - 1) duplicate ACKs, the
scoreboard is to be updated as normal."
    "When a TCP sender receives the duplicate ACK corresponding to
DupThresh ACKs,
the scoreboard MUST be updated with the new SACK information (via
Update ()). If no previous loss event has occurred
on the connection or the cumulative acknowledgment point is beyond
the last value of RecoveryPoint, a loss recovery phase SHOULD be
initiated, per the fast retransmit algorithm outlined in [RFC2581]."

    But these sentences doesn't describe how tcp knows the current ack
is the dup-threshold dup-ack.

    Accorrding to rfc3517 seciton 4 and isLost(Seqnum) function:
    "The routine returns true when either
DupThresh discontiguous SACKed sequences have arrived above
’SeqNum’ or (DupThresh * SMSS) bytes with sequence numbers greater
than ’SeqNum’ have been SACKed. Otherwise, the routine returns
false."
    I think this is just what I am searching for, but I still don't know
which line of code in Linux tcp protocol does this check.
    Can any one help me ? thks in advance.
