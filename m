Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab1AMJwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 04:52:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40344 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab1AMJwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 04:52:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZNWM9ua9GCWsh2oY4b4s92Lq5WKwU6Sw1W6aIFjydoWTI8PfFINViluubWCWE6YKVv
         ekEwTDha5OSwjX0Mi0m9fQhA9l8GZOos3I0XJc9zm8CuIvIzfSiupfi+6eO8PWdbd3Am
         0Mw7PzGD0BCLJeLpD+/VDG6paDaOx/7HuhfWM=
Message-ID: <4D2ECB56.4070802@gmail.com>
Date: Thu, 13 Jan 2011 10:52:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        autofs@linux.kernel.org, npiggin@kernel.dk
Subject: WARNING: at fs/dcache.c:1359 d_set_d_op [was: mmotm 2011-01-06-15-41
 uploaded]
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

Hi, after some uptime and several suspend/resume cycles, I got:
WARNING: at fs/dcache.c:1359 d_set_d_op+0x82/0xb0()
Hardware name: To Be Filled By O.E.M.
Modules linked in: dvb_usb_af9015 tda18271 af9013 dvb_usb dvb_core
Pid: 3474, comm: automount Tainted: G        W   2.6.37-mm1_64+ #1344
Call Trace:
 [<ffffffff8106bd2a>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff8106bd75>] ? warn_slowpath_null+0x15/0x20
 [<ffffffff81125a32>] ? d_set_d_op+0x82/0xb0
 [<ffffffff8120d829>] ? autofs4_dir_mkdir+0x169/0x180
 [<ffffffff8111caa8>] ? vfs_mkdir+0x78/0xa0
 [<ffffffff811209e6>] ? sys_mkdirat+0xf6/0x110
 [<ffffffff81120a13>] ? sys_mkdir+0x13/0x20
 [<ffffffff81030dbb>] ? system_call_fastpath+0x16/0x1b

I changed those BUG_ONs to WARN_ONs intentionally because I had problems
with that previously -- I had to:
dentry->d_flags &= ~(DCACHE_OP_HASH | DCACHE_OP_COMPARE |
      DCACHE_OP_REVALIDATE | DCACHE_OP_REVALIDATE_RCU |
      DCACHE_OP_DELETE);

in d_set_d_op to not oops when calling NULLish op->d_delete later.


The "Tainted: G        W" is caused by:
https://lkml.org/lkml/2011/1/10/63

regards,
-- 
js
