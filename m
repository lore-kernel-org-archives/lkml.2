Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab0C2JGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:06:06 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:65241 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab0C2JGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=qFQMYuQEf0ggKfkiFqzEG3kdkxcbE7bRc13jnn+VyyTUb9wL1t1sW+RqciPUQoZq1U
         hz0kfUTImqjYpqQjctajXr3XLr5EP6hkbbR8wTVrxNTGPtIucgC8ubiBdGzZaw/f5Hn1
         BjADoN+AEaS2nbEL3gyyHt1kVIWePraReIoqw=
Message-ID: <4BB06D78.4070407@googlemail.com>
Date: Mon, 29 Mar 2010 11:06:00 +0200
From: Timo Witte <timo.witte@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100322 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fs/cifs added additional info to error message
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added additional info to error message, cifs trys to resolve DNS Names 
via /sbin/request-key
this is not installed by default in Ubuntu systems, so you can´t use DFS 
shares correctly without it.

Signed-off-by: Timo Witte <timo.witte@googlemail.com>

--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -137,7 +137,7 @@ dns_resolve_server_name_to_ip(const char *unc, char 
**ip_addr)
                 len = rkey->type_data.x[0];
                 data = rkey->payload.data;
         } else {
-               cERROR(1, ("%s: unable to resolve: %s", __func__, name));
+               cERROR(1, ("%s: unable to resolve: %s have you installed 
/sbin/request-key ?", __func__, name));
                 goto out;
         }

