Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254Ab2JDIyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:54:45 -0400
Received: from mga06.intel.com ([134.134.136.21]:15725 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965538Ab2JDIym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:54:42 -0400
Message-ID: <1349340875.15966.18.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] efi: add efivars kobject to efi sysfs folder
From: Matt Fleming <matt.fleming@intel.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, glin@suse.com,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Matthew Garrett <mjg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Jones <pjones@redhat.com>
Date: Thu, 04 Oct 2012 09:54:35 +0100
In-Reply-To: <1349317486-30006-1-git-send-email-jlee@suse.com>
References: <1349317486-30006-1-git-send-email-jlee@suse.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 10:24 +0800, Lee, Chun-Yi wrote:
> UEFI variable filesystem need a new mount point, so this patch add
> efivars kobject to efi_kobj for create a /sys/firmware/efi/efivars
> folder.
> 
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  drivers/firmware/efivars.c |   11 +++++++++++
>  include/linux/efi.h        |    1 +
>  2 files changed, 12 insertions(+), 0 deletions(-)

Jeremy, did you want to pick this up as part of your series?

Actually, shouldn't the new filesystem be called "efivarfs", or "efifs"
to make it more explicit that it is a filesystem?

We also need something in Documentation/filesystems/ describing the old
EFI variable method, why it's no longer any good, and why the new
filesystem is favoured. Does anybody have anything to add to the
following?

diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index 8c624a1..ddf5a83 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -38,6 +38,8 @@ dnotify_test.c
 	- example program for dnotify
 ecryptfs.txt
 	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
+efivars.txt
+	- info for the efivars filesystem.
 exofs.txt
 	- info, usage, mount options, design about EXOFS.
 ext2.txt
diff --git a/Documentation/filesystems/efivars.txt b/Documentation/filesystems/efivars.txt
new file mode 100644
index 0000000..4350c1a
--- /dev/null
+++ b/Documentation/filesystems/efivars.txt
@@ -0,0 +1,16 @@
+
+efivars - a (U)EFI variable filesystem
+
+The efivars filesystem was created to address the shortcomings of
+using entries in sysfs to maintain EFI variables. The old sysfs EFI
+variables code only supported variables of up to 1024 bytes. This
+limitation existed in version 0.99 of the EFI specification, but was
+removed before any full releases. Since variables can now be larger
+than a single page, sysfs isn't the best interface for this.
+
+Variables can be created, deleted and modified with the efivars
+filesystem.
+
+The efivars filesystem is typically mounted like this,
+
+	mount -t efivars none /sys/firmware/efi/efivars


