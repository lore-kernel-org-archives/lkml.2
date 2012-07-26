Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2GZSSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 14:18:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37076 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2GZSSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 14:18:07 -0400
Message-ID: <501189DA.4030709@enkore.de>
Date: Thu, 26 Jul 2012 20:18:02 +0200
From: Marian Beermann <public@enkore.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [BUG] NTFS code doesn't sanitize folder names sufficiently
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

today I noticed some very odd behaviour, which could lead people to 
believe a loss of data, because it is possible to create directories 
with backslashes in them.

I am currently running kernel 3.5.

To completly reproduce the problem to the full extend you'll need a 
Windows computer, but to see whats wrong Linux completly suffices :-)

On a Linux computer
1. Create a directory named TestA on an NTFS partition
2. Create a subdirectory of TestA named TestB
3. Create a third directory alongside TestA named TestA\TestB (the 
fundamental problem is this: backslashes in directory names)

Connect the drive containing the NTFS partition now to a Windows 
computer and navigate to the directory containing TestA and TestA\TestB. 
If you navigate to the folder (not path!) TestA\TestB you'll actually 
see the contents of the path TestA\TestB (the subfolder TestB) and not 
the contents of the directory.
It is not possible on a Windows machine to access the contents of the 
directory named TestA\TestB. This is not a bug in Windows, it's caused 
by a bug in the NTFS driver, which allows illegal characters.

The solution to this would be to disallow creation of files and folders 
on NTFS drives containing illegal characters.

Best regards
Marian Beermann

(notice: I'm not subscribed to linux-fsdevel...)
