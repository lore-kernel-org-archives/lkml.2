Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab0FYTcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:32:45 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51551 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab0FYTco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:32:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Xps500kmZ2wZttBXpFOyPafaSqHa9YFu7dwOaB0XAuNDK9r5v4axe8856dFbZ77STR
         9jQFA4t5aUC1dbF5/tAiFv0wQoXApu2ebddNMwGFNz+cVU3TeuEvqR5jBlknQ4YHcZ0O
         nsM3F5ebfiH5g0+d3z6WNSCZyYxRC+51ePAkc=
MIME-Version: 1.0
In-Reply-To: <AANLkTila2rrYcBUZKwywHTP6g8rsj7Z1ck6LSoC9GaUY@mail.gmail.com>
References: <AANLkTila2rrYcBUZKwywHTP6g8rsj7Z1ck6LSoC9GaUY@mail.gmail.com>
Date: Fri, 25 Jun 2010 12:32:43 -0700
Message-ID: <AANLkTikbQLTC8HLB2m8LoPtZ0JVUzRl6PvRL5yTC0pZV@mail.gmail.com>
Subject: Fwd: fs/exec.c core dumping on NFS mounted directory
From: Lei Sun <leisun124@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  In 2.6.3x, I am logging in as a root and running app from NFS
mounted directory. The app crashed with 0 bytes core file (I have set
"ulimit -c unlimited", so it's not an issue).

Proposed patch:

--- exec.c 2010-05-19 17:33:16.000000000 -0700
+++ exec.c.new 2010-05-19 17:33:07.000000000 -0700
@@ -1859,7 +1859,7 @@
     * Dont allow local users get cute and trick others to coredump
     * into their pre-created files:
     */
- if (inode->i_uid != current_fsuid())
+ if (inode->i_bytes != 0 && inode->i_uid != current_fsuid())
        goto close_fail;

    if (!file->f_op)


P.S. CC to my email, i am not on the list.

Thanks
lei
