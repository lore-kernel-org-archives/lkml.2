Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1AJKTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:19:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51724 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1AJKTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:19:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lFYgL1OvLppQD5Cdto7MBQojS4vyVzclPYCnzIPR5kdfIRcEG8OppdajCdFNlwWZV2
         5sVq5GXrrGUIh5MsFuH465wwY0kER2LJqFk2jQ6gF4dIye5xlzrfKBA4EL1dyADldRbR
         zI5yR0yN5eyC9yOQsz9mGAPMTo5tetGGA6rb0=
Message-ID: <4D2ADD43.2020702@gmail.com>
Date: Mon, 10 Jan 2011 11:19:47 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: WARNING: at kernel/workqueue.c [was: mmotm 2011-01-06-15-41 uploaded]
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
In-Reply-To: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 12:41 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2011-01-06-15-41 has been uploaded to

Hello, I get this during boot:
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1
CPU1: Thermal LVT vector (0xfa) already installed
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 2 CPUs
Total of 2 processors activated (11970.26 BogoMIPS).
devtmpfs: initialized
------------[ cut here ]------------
WARNING: at kernel/workqueue.c:1202 worker_enter_idle+0xd0/0x140()
Hardware name: To Be Filled By O.E.M.
Modules linked in:
Pid: 5, comm: kworker/u:0 Not tainted 2.6.37-mm1_64+ #1343
Call Trace:
 [<ffffffff8106ad2a>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff8106ad75>] ? warn_slowpath_null+0x15/0x20
 [<ffffffff8107f690>] ? worker_enter_idle+0xd0/0x140
 [<ffffffff81081e28>] ? worker_thread+0x208/0x320
 [<ffffffff81081c20>] ? worker_thread+0x0/0x320
 [<ffffffff81086436>] ? kthread+0x96/0xa0
 [<ffffffff81030b14>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810863a0>] ? kthread+0x0/0xa0
 [<ffffffff81030b10>] ? kernel_thread_helper+0x0/0x10
---[ end trace 4eaa2a86a8e2da22 ]---

Probably a result of the workqueue rewrite...

regards,
-- 
js
