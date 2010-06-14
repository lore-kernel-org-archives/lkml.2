Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab0FNSFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:05:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36731 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0FNSFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Drbfxcszktyu0KWwLBSE4+vkIK+BX799KO9XYuKmxDD6iFI3KdDxVjE9y1fz7mknOX
         brZBnBMDa+QNzsxq8Cvykrq+GqLg/iH6K0Ewu25+K3XQp85234Wnc+Az+nByxz/O2RWE
         mPV7R6lMly8g9obgYU4cZIUzwrs8Nb8/MozIw=
MIME-Version: 1.0
Date: Mon, 14 Jun 2010 11:05:53 -0700
Message-ID: <AANLkTilgdKWWHaN1VUX349rbuuB6156v6TOJTPZN3iv_@mail.gmail.com>
Subject: core dumping on NFS mounted directory
From: Lei Sun <leisun124@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi :
   In 2.6.3x, I am logging in as a root and running app from NFS
mounted directory. The app crashed with 0 bytes core file (I have set
"ulimit -c unlimited", so it's not an issue).
The following code in fs/exec.c is causing this:

    /*
     * Dont allow local users get cute and trick others to coredump
     * into their pre-created files:
     * Note, this is not relevant for pipes
     */
    if (!ispipe && (inode->i_uid != current_fsuid()))
        goto close_fail;

What is the intention of above piece of code?  If it's security
concern,  it clearly break the NFS mounted (different uid) core
dumping logic.

Thanks
lei
