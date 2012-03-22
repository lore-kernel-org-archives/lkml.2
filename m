Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab2CVVCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:02:25 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:50847 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab2CVVCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:02:24 -0400
X-Greylist: delayed 1413 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2012 17:02:23 EDT
MIME-Version: 1.0
Date: Thu, 22 Mar 2012 16:38:46 -0400
Message-ID: <CAEwYmTJzzUi1qfRHYfZg77g1K7myNsAh2oDiY7hWxzRO5hQGHA@mail.gmail.com>
Subject: sysfs binary attribute API flux
From: Jonathan McCune <jonmccune@cmu.edu>
To: linux-kernel@vger.kernel.org
Cc: "Jonathan M. McCune" <jonmccune@cmu.edu>
Content-Type: text/plain; charset=ISO-8859-1
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_ENDS_IN_URL_NOT_WWW 0, BODY_SIZE_1000_1099 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, FROM_EDU_TLD 0, TO_NO_NAME 0, WEBMAIL_SOURCE 0, __CP_URI_IN_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HELO_GMAIL 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __PHISH_SPEAR_HTTP_RECEIVED 0, __PHISH_SPEAR_STRUCTURE_1 0, __PHISH_SPEAR_STRUCTURE_2 0, __RDNS_GMAIL 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NO_WWW 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I maintain a Linux kernel module for a research project*, where it is
necessary to move some binary data from userspace into the kernel. I
have been using sysfs's 'struct bin_attribute'.  Unfortunately, every
few kernel versions, my code breaks because of a change in the
definition of some elements in this struct.  For example, kernel
versions 2.6.20, 2.6.32, and 2.6.38 each define the 'read' and 'write'
function pointers differently. I will spare the inline diff, but they
can each be seen here:

http://lxr.linux.no/linux+v2.6.32.59/include/linux/sysfs.h#L65
http://lxr.linux.no/linux+v2.6.38.8/include/linux/sysfs.h#L88
http://lxr.linux.no/linux+v2.6.20.21/include/linux/sysfs.h#L54

My question: is there some other interface that I should be using?  Am
I using sysfs incorrectly?  All of the documentation I've been able to
find seems to strongly encourage the use of sysfs.

http://kernel.org/doc/Documentation/filesystems/sysfs.txt

cc appreciated in reply.

Many thanks,
-Jon

* http://flickertcb.sourceforge.net/
