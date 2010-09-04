Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0IDGBO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 02:01:14 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:54055 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751868Ab0IDGBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 02:01:13 -0400
Date: Sat, 4 Sep 2010 02:01:06 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Dave Anderson <anderson@redhat.com>, guenter.roeck@ericsson.com,
        tj@kernel.org, gregkh@suse.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <223297751.117871283580066858.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <856089343.1931201283439399228.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: crash failure with 2.6.36-rc3 vmcore
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> crash> mod -S
> 
> mod: invalid structure member offset: attribute_owner
>      FILE: symbols.c  LINE: 8577  FUNCTION: add_symbol_file_kallsyms()
> 
>      MODULE       NAME                   SIZE  OBJECT FILE
> ffffffffa000de60  dm_mod                76230 
> /lib/modules/2.6.36-rc2-mm1-wqfix-mkdfix+/kernel/drivers/md/dm-mod.ko
> [/usr/bin/crash] error trace: 4affb0 => 4f3236 => 4f12b5 => 4e587a
> 
>   4e587a: OFFSET_verify.clone.4+186
>   4f12b5: add_symbol_file+933
>   4f3236: load_module_symbols+566
>   4affb0: do_module_cmd+1264
> 
> mod: invalid structure member offset: attribute_owner
>      FILE: symbols.c  LINE: 8577  FUNCTION: add_symbol_file_kallsyms()
This failure was due to this commit,

commit 6fd69dc578fa0b1bbc3aad70ae3af9a137211707
Author: Guenter Roeck <guenter.roeck@ericsson.com>
Date:   Wed Jul 28 22:09:26 2010 -0700

    sysfs: Remove owner field from sysfs struct attribute
    
    Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
    Acked-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 8bf06b6..3c92121 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -22,14 +22,8 @@ struct kobject;
 struct module;
 enum kobj_ns_type;
 
-/* FIXME
- * The *owner field is no longer used.
- * x86 tree has been cleaned up. The owner
- * attribute is still left for other arches.
- */
 struct attribute {
        const char              *name;
-       struct module           *owner;
        mode_t                  mode;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
        struct lock_class_key   *key;
