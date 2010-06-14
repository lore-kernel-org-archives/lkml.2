Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0FNUp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:45:59 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58241 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab0FNUp6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=bWg6IqU9JVa+ScgeIgCQedthc/ILfzGT+NI6ISp3SzRs8wXPa8p0Ez18qWEpxMDmV9
         NPPzJAJDXViyby9ZsGIg7wJEl5WMd8pGPXcc7aLYd75DOYuQcsmGZtdceoe/7qKqoXrN
         l33yVev4gy0naoDMVlIM38+pd1CbyvNS/duxg=
MIME-Version: 1.0
Date: Mon, 14 Jun 2010 13:45:57 -0700
Message-ID: <AANLkTila2rrYcBUZKwywHTP6g8rsj7Z1ck6LSoC9GaUY@mail.gmail.com>
Subject: fs/exec.c core dumping on NFS mounted directory
From: Lei Sun <leisun124@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
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

What is the intention of above piece of code?  If it's security
concern,  it clearly break the NFS mounted (different uid) core
dumping logic.

P.S. CC to my email, i am not on the list.

Thanks
lei
