Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab2J2C33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 22:29:29 -0400
Received: from antispam.phi9.com ([66.181.8.243]:52045 "EHLO antispam.phi9.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005Ab2J2C32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 22:29:28 -0400
X-Greylist: delayed 3765 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Oct 2012 22:29:27 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns;
        d=phi9.com; s=dumbledore;
        h=received:message-id:date:from:user-agent:mime-version:to:subject
          :content-type:content-transfer-encoding;
        b=MWChJLAhVhpoqO27GXOV4I+RsqnpkzUMSWQZiH7lHTc5MeF7PvqdwXVBb680H1L+n
          BZtfpbkiGC3ESrARZl/H0OmI9iS9xE52vBMepOhKMipSHROCC35qhdVPFLeajBZ14
          XqtUqoZU+TqlBMnTWt0CA2XsysizdTqPOk2ETID8k=
Message-ID: <508DDB49.1060400@phi9.com>
Date: Sun, 28 Oct 2012 18:26:33 -0700
From: Abbas <akhan@phi9.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: iwlwifi crash with queue full and qos errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.1 (/)
X-Spam-Report: host: ANTISPAM.PHI9 | contact: postmaster@phi9.com | scores: DKIM_SIGNED=0.1,DKIM_VALID=-0.1,DKIM_VALID_AU=-0.1 | autolearn=unavailable, score=-0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reporting a possible regression with latest kernel 3.6.2-1. Intel's 
iwlwifi crashes intermittently.
Downgraded to 3.5.3.1 including the microcode drivers and didnot notice 
any crashes since.

Chunks from stack trace:

[108759.658475] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
[108761.655855] iwlwifi 0000:03:00.0: Error sending REPLY_QOS_PARAM: time out
after 2000ms.
[108761.655867] iwlwifi 0000:03:00.0: Failed to update QoS
..... repetitions ....
[108844.230466] iwlwifi 0000:03:00.0: Restarting adapter queue is full
[108844.230479] iwlwifi 0000:03:00.0: Error sending REPLY_SCAN_CMD:
enqueue_hcmd failed: -28
[108844.251368] ------------[ cut here ]------------
[108844.251383] WARNING: at drivers/net/wireless/iwlwifi/iwl-io.c:150
iwl_grab_nic_access+0x7f/0xf0 [iwlwifi]()
[108844.251385] Hardware name: 2306CTO
[108844.251477] Pid: 12818, comm: kworker/u:0 Not tainted 3.6.2-1-ARCH #1
[108844.251479] Call Trace:
[108844.251489]  [<ffffffff81055c2f>] warn_slowpath_common+0x7f/0xc0
[108844.251495]  [<ffffffff81055d26>] warn_slowpath_fmt+0x46/0x50
[108844.251501]  [<ffffffffa04e4838>] ? iwl_grab_nic_access_silent+0x188/0x200


------
abbas


