Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab1ELNcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:32:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42356 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab1ELNcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=Aa8l4x57IOd8TVSIgZ3WLn2VgQHhRFD1HmXisEbZHCs/T1Iv17E/FN1M9gptHEVMVI
         Pp5RrLThxm8DjyC+PhD4xJ/kh1m2mxZRThBBILn0bCSq04YCfzs59PpfDJSRq2F+DdrR
         t6EXbylpQ8UnZtU8dlkbJC/Me+NS+xsI1rlRI=
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 12 May 2011 09:31:49 -0400
X-Google-Sender-Auth: E5xjsr-uit6Zp1_YNOs9nf_pluI
Message-ID: <BANLkTinWePJ9N8D=JSezOfiQ94qp2bDGrw@mail.gmail.com>
Subject: [2.6.39 regression] X locks up hard right after logging in
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just installed 9f381a6 (-linus from yesterday) on my Sandy Bridge
desktop, and it locks up hard within a few seconds of logging in.
netconsole says:

[  506.629723] block group 24725422080 has an wrong amount of free space
[  506.629723] block group 24725422080 has an wrong amount of free space
[  506.808501] fuse init (API version 7.16)
[  506.819996] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[  506.829847] SELinux: initialized (dev fusectl, type fusectl), uses
genfs_contexts
[  506.808501] fuse init (API version 7.16)
[  506.819996] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[  506.829847] SELinux: initialized (dev fusectl, type fusectl), uses
genfs_contexts

If it's any help, the system is locked so hard that the reset button
doesn't work.  It's an Intel DQ67SW board, which apparently doesn't
have the most reliable reset button in the world :)

2.6.38.{4,5,6} are all rock-solid on this box.

I've started bisecting, but I don't expect to finish today.  I need to
do some work other than kernel hacking...

--Andy
