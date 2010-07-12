Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab0GLRwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:52:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53242 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0GLRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=X79X3J+leoqXdFlIFInMWqRT0LqnT+z6NuBl6ADIX+9uEdq9sHiaryjFsB19y1bN9T
         zuE2/1eiyGDrTEUC8HILxczLavDswvYMsb+gSfk/DVzUu0f8K83addyvdyerXeLAmP5c
         XeEIn05u4QSWc92adMDISOG36/Sc1+EJahfZA=
Message-ID: <4C3B5660.8020405@lwfinger.net>
Date: Mon, 12 Jul 2010 12:52:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Possible false positive from checkpatch.pl
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy,

In preparing a vendor driver for submission to staging, I am getting the 
following from checkpatch.pl:

ERROR: Macros with multiple statements should be enclosed in a do - while loop
#377: FILE: staging/rtl8712/rtl871x_mp_ioctl.h:377:
+#define GEN_MP_IOCTL_HANDLER(sz, hdl, oid) {sz, hdl, oid},

ERROR: Macros with multiple statements should be enclosed in a do - while loop
#378: FILE: staging/rtl8712/rtl871x_mp_ioctl.h:378:
+#define EXT_MP_IOCTL_HANDLER(sz, subcode, oid) {sz, &mp_ioctl_ \
+       ## subcode ## _hdl, oid},

total: 2 errors, 0 warnings, 466 lines checked

Enclosing these macros in a do {...} while (0) is definitely wrong and will not 
compile. Moving the comma from the end of the macro to the lines that invoke it 
fixes the problem, but should not be necessary.

Thanks,

