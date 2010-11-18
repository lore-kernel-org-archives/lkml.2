Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab0KRSNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:13:36 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58601 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685Ab0KRSNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:13:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=bdvHZId7yZ7hxaurHpakqNL7/EjAdDbqtkfQPb37rQ15qLHhw6wNQNJ6/qtz7orxqy
         daP4rLIyfTLEw3HWyTCzl7nq+3wajEuiQ1NvEffoYifUV+Kku6Pxd715fv5rRDOzCloB
         wEeylD6RcTBoyvmoA7N1a26PsPTjecM51RCco=
MIME-Version: 1.0
Date: Thu, 18 Nov 2010 13:13:24 -0500
Message-ID: <AANLkTin01j5oTUdh6fAgs--Gi46BZOWZCdypUPd8uhm4@mail.gmail.com>
Subject: [PATCH] Bug in scripts/package/mkspec?
From: Patrick LeBoutillier <patrick.leboutillier@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've been building RPMs for the Linux kernel for a while now and only
recently noticed that the RPM Release field is always set to 1.
After a bit of searching I found the offending line in
scripts/package/mkspec. Here is a patch that worked for me, but
perhaps this
could be fixed in better way by someone knowledgeable of the kernel
build process...:


--- ./mkspec.next       2010-11-18 13:08:56.000000000 -0500
+++ mkspec      2010-11-18 13:10:13.000000000 -0500
@@ -29,7 +29,7 @@
 echo "Version: $__KERNELRELEASE"
 # we need to determine the NEXT version number so that uname and
 # rpm -q will agree
-echo "Release: `. $srctree/scripts/mkversion`"
+echo "Release: `cd $srctree && ./scripts/mkversion`"
 echo "License: GPL"
 echo "Group: System Environment/Kernel"
 echo "Vendor: The Linux Community"


Note: Please cc: me on replies as I'm not subscribed to the list.


Thanks,

Patrick

-- 
=====================
Patrick LeBoutillier
Rosemère, Québec, Canada
