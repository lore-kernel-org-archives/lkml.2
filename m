Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab0JDTZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:25:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35570 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab0JDTZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 15:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=po9LfgHSWZ1P1gKgFNJ8+4kQ+hOsHSG0O7aaU62pNe3Q8ZFuqXQn8nskMr9Mz9f6pU
         YD5hXy1GYcDG45PSX3gy793XYw5Dcid3O4pivrxMQR9Ti4lAcyF+cYU4c0c5ZgN1sbP1
         yFRYYOMQAiUhsBqX0aEPcjm0b2InU3gnTQaqU=
Date: Mon, 4 Oct 2010 21:24:59 +0200
From: Dan Carpenter <error27@gmail.com>
To: Armin Schindler <mac@melware.de>
Cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] eicon: make buffer larger
Message-ID: <20101004192459.GE5692@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Armin Schindler <mac@melware.de>,
	Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In diva_mnt_add_xdi_adapter() we do this:
  strcpy (clients[id].drvName,     tmp);
  strcpy (clients[id].Dbg.drvName, tmp);

The "clients[id].drvName" is a 128 character buffer and
"clients[id].Dbg.drvName" was originally a 16 character buffer but I've
changed it to 128 as well.  We don't actually use 128 characters but we
do use more than 16.

I've also changed the size of "tmp" to 128 characters instead of 256.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/isdn/hardware/eicon/debuglib.h b/drivers/isdn/hardware/eicon/debuglib.h
index 8ea5877..02eed6b 100644
--- a/drivers/isdn/hardware/eicon/debuglib.h
+++ b/drivers/isdn/hardware/eicon/debuglib.h
@@ -249,7 +249,7 @@ typedef struct _DbgHandle_
  }     regTime ;  /* timestamp for registration       */
  void               *pIrp ;   /* ptr to pending i/o request       */
  unsigned long       dbgMask ;  /* current debug mask               */
- char                drvName[16] ; /* ASCII name of registered driver  */
+ char                drvName[128] ; /* ASCII name of registered driver  */
  char                drvTag[64] ; /* revision string     */
  DbgEnd              dbg_end ;  /* function for debug closing       */
  DbgLog              dbg_prt ;  /* function for debug appending     */
diff --git a/drivers/isdn/hardware/eicon/debug.c b/drivers/isdn/hardware/eicon/debug.c
index 33ce89e..3626401 100644
--- a/drivers/isdn/hardware/eicon/debug.c
+++ b/drivers/isdn/hardware/eicon/debug.c
@@ -862,7 +862,7 @@ void diva_mnt_add_xdi_adapter (const DESCRIPTOR* d) {
   diva_os_spin_lock_magic_t old_irql, old_irql1;
   dword sec, usec, logical, serial, org_mask;
   int id, best_id = 0, free_id = -1;
-  char tmp[256];
+  char tmp[128];
   diva_dbg_entry_head_t* pmsg = NULL;
   int len;
   word size;
