Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1ATU0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:26:01 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55103 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab1ATU0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:26:00 -0500
Subject: sshd issues with 2.6.38-rc1
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: apw@canonical.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 12:20:42 -0800
Message-ID: <1295554842.2998.79.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just an FYI: I'm having problems sshing to a machine I just updated to
2.6.38-rc1. The machine is running Ubuntu 10.10, and and 2.6.37 with the
same config doesn't seem to have a problem.

The box is always pingable. But when I ssh in from a client, it just
hangs before authenticating. 

In the dmesg, on both kernels, I see:
sshd (1852): /proc/1852/oom_adj is deprecated, please
use /proc/1852/oom_score_adj instead.

Using ssh -vvv I get all the way to:

debug1: SSH2_MSG_NEWKEYS received
debug1: Roaming not allowed by server
debug1: SSH2_MSG_SERVICE_REQUEST sent
debug2: service_accept: ssh-userauth
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug2: key: <blah blah>

With ps, I see:
root  ...  Ss ...  sshd: [accepted]
sshd  ...  S  ...  sshd: [net]


Anyone have a clue? Otherwise I'll try bisecting it down.

thanks
-john


