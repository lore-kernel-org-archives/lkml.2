Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab2GUM2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 08:28:48 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37314 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766Ab2GUM2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 08:28:46 -0400
Message-ID: <1342873722.2981.5.camel@dabdike.int.hansenpartnership.com>
Subject: efitools rpm up on opensuse build service: contains useful tools
 for taking control of UEFI secure boot platforms
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 21 Jul 2012 13:28:42 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the tools are in the git repository

http://git.kernel.org/?p=linux/kernel/git/jejb/efitools.git;a=summary

But for ease of consumption, this is now packaged and build by the
opensuse build server as installable rpm files.

http://download.opensuse.org/repositories/home:/jejb1:/UEFI/openSUSE_12.1/

If you install the efitools-0.1.rpm package, it will automatically
provision you with Platform Key, Key Exchange Key and db key.  The
README file in /usr/share/efitools/ explains what’s going on, but you
can also do a quick lockdown of your UEFI plaform (or simply boot out
the old keys) if you copy all the efi files in /usr/share/efitools/efi/
and the *.auth files from /usr/share/efitools/keys/ into a partition
accessible to the efi boot loader.  Then in Setup Mode (must be Setup
Mode to alter the keys) do

UpdateVars db db.auth
UpdateVars KEK KEK.auth
UpdateVars PK PK.auth

After the PK update, the platform should once again be in user mode.
Verify by trying to run the HelloWorld efi binary (should fail) and it’s
signed counterpart HelloWorld-signed (should print Hello World!).

I've also summarised the current state, plus a useful collection of odd
information on my blog:

http://blog.hansenpartnership.com/

James


