Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0IMMYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 08:24:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59891 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab0IMMYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 08:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=l5wkk5Wk7tGCCJMba5/w28Dxo8DnIAJ5A7rjkoVOmPC7Kprz9SQphYsE3nJBOxvv5A
         5MdeDZ5iJz8OGU5bhNuXCl7Ra/lEXNcgvnqdLG/WuEKD1ok1aDfeNUqPuO6eLflGOEKP
         BpqHncxKVDdqtMB7/QISg2Bqi6HzB4CZYj7ik=
Message-ID: <4C8E180D.4020309@suse.cz>
Date: Mon, 13 Sep 2010 14:24:45 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: pingc@wacom.com
CC: Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>
Subject: wacom + runtime PM = AA deadlock
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

by mistake when runtime PM is enabled by default for input devices, X
hangs on wacom open:
[<ffffffff814a00ea>] mutex_lock+0x1a/0x40
[<ffffffffa02bc94b>] wacom_resume+0x3b/0x90 [wacom]
[<ffffffff81327a32>] usb_resume_interface+0xd2/0x190
[<ffffffff81327b5d>] usb_resume_both+0x6d/0x110
[<ffffffff81327c24>] usb_runtime_resume+0x24/0x40
[<ffffffff8130a2cf>] __pm_runtime_resume+0x26f/0x450
[<ffffffff8130a23a>] __pm_runtime_resume+0x1da/0x450
[<ffffffff8130a53a>] pm_runtime_resume+0x2a/0x50
[<ffffffff81328176>] usb_autopm_get_interface+0x26/0x60
[<ffffffffa02bc626>] wacom_open+0x36/0x90 [wacom]

wacom_open took wacom->lock and calls usb_autopm_get_interface which in
turn calls wacom_resume which tries to aquire the lock again.

More details (dmesg including) at:
https://bugzilla.novell.com/show_bug.cgi?id=638506

Any ideas how to fix that properly?

thanks,
-- 
js
suse labs
