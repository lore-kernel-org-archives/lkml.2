Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab1CDI4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:56:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58310 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1CDI4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:56:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=smAWWJRga8cvjYGoehz7bJazZulz/6XDRDojAod5H26OszI2UIP13axMQxxxRDEqVz
         B8W798O8dULLuezi2ocmHBvJMvoe02x3yDO9KMP4c3PRUNDPm5Fqr+ePMCgLnS0mZBOJ
         0jFbEYMSYuV+b3/QoA2beYaIXLBPS+os6PUGI=
Message-ID: <4D70A929.4010900@suse.cz>
Date: Fri, 04 Mar 2011 09:56:09 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>, ML netdev <netdev@vger.kernel.org>,
        maxk@qualcomm.com, vtun@office.satix.net
Subject: tun: Failed to create tun sysfs files [was: mmotm 2011-03-02-16-52
 uploaded]
References: <201103030127.p231ReNl012841@imap1.linux-foundation.org>
In-Reply-To: <201103030127.p231ReNl012841@imap1.linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 01:52 AM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2011-03-02-16-52 has been uploaded to

Hi, I'm seeing this with tun (also with earlier versions):
WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xb8/0xe0()
Hardware name: To Be Filled By O.E.M.
sysfs: cannot create duplicate filename '/devices/virtual/net/tun0/group'
Modules linked in: microcode dvb_usb_af9015 tda18271 af9013 dvb_usb dvb_core
Pid: 3840, comm: openvpn Not tainted 2.6.38-rc4-mm1_64+ #1390
Call Trace:
 [<ffffffff8106d61a>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff8106d6f1>] ? warn_slowpath_fmt+0x41/0x50
 [<ffffffff81176638>] ? sysfs_add_one+0xb8/0xe0
 [<ffffffff8117570d>] ? sysfs_add_file_mode+0x5d/0xa0
 [<ffffffff8117575c>] ? sysfs_add_file+0xc/0x10
 [<ffffffff81175841>] ? sysfs_create_file+0x21/0x40
 [<ffffffff813609d4>] ? device_create_file+0x14/0x20
 [<ffffffff813e0256>] ? tun_set_iff+0x3f6/0x4a0
 [<ffffffff813e05fe>] ? __tun_chr_ioctl+0x12e/0x5d0
 [<ffffffff8126c5c2>] ? __strncpy_from_user+0x22/0x60
 [<ffffffff813e0ade>] ? tun_chr_ioctl+0xe/0x10
 [<ffffffff811274ed>] ? do_vfs_ioctl+0x8d/0x300
 [<ffffffff811277aa>] ? sys_ioctl+0x4a/0x80
 [<ffffffff81030dbb>] ? system_call_fastpath+0x16/0x1b

It's because these devices already contain 'group' in the sysfs dir.

regards,
-- 
js
suse labs
