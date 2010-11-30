Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0K3KM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 05:12:28 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53829 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0K3KM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 05:12:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-rim-org-msg-ref-id:message-id:reply-to:x-priority:sensitivity
         :importance:subject:to:cc:from:date:content-type:mime-version;
        b=a6X8I1P6hnSAYdH4/4xEgTLddwpLdB12wch5P+oLWs5oWoNj2H79N3tNEn16auOujB
         bAQ5P0rgs6iiGI1/1in2oPC8UCaQYGn8V5QmFWV+8dDSF63enpWkNfeiPBxF4229DLhJ
         CHWl4lvWMW6tyn18RV5rQyyVYpjotqUWps67s=
X-rim-org-msg-ref-id: 1891479568
Message-ID: <1891479568-1291111940-cardhu_decombobulator_blackberry.rim.net-477851730-@bda843.bisx.prod.on.blackberry>
Reply-To: seth.arnold@gmail.com
X-Priority: Normal
Sensitivity: Normal
Importance: Normal
Subject: Re: [apparmor] [PATCH v2] APPARMOR: add sid to profile mapping and sidrecycling
To: wzt.wzt@gmail.com, linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com
From: "Seth Arnold" <seth.arnold@gmail.com>
Date: Tue, 30 Nov 2010 10:12:20 +0000
Content-Type: text/plain
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please forgive the rubbish blackberry quoting.

+
+/* find the first zero bit in the sid_bitmap array */
+spin_lock(&aa_sid_hash_table->lock);
+for (i = 0; i < AA_SID_BITMAP_SIZE; i++) {
+for (j = 0; j < 32; j++) {
+if (!(sid_bitmap[i] & (1 << j))) {
+/* convert offset to sid */
+sid = i * 32 + j;
+goto alloc_ok;
+}
+}
+}
+spin_unlock(&aa_sid_hash_table->lock);

This could be 32768 bit comparisons performed under spinlock (unlikely, perhaps, but that is the size of the datastructures...). At the least a check for sid_bitmap[I]!=0xFFFFFFFF should be placed in the outer for loop, but that could still leave 1024 word comparisons under spinlock, which feels expensive to me.

Thanks
