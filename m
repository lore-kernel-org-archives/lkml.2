Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab0KMUGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 15:06:20 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34228 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab0KMUGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 15:06:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ZLu6miMMN/ozm0VmOX6MCWqgFpbk9W2LF59rJyMbYQAPppOHM4nVMDoW7TJX6PUcD3
         DHF3FIPCwBEh8esJWo8Yh2Qm2rJzKwah1hiSMHFRPwOM4ENFsXPW8s0UVJVFVLzrVsi1
         ZXoVarHxFBGrFegKGfQxzuXLfPacQ0eYPvv0Q=
MIME-Version: 1.0
Date: Sat, 13 Nov 2010 13:06:16 -0700
Message-ID: <AANLkTinAuL_XEjtJP57oT3OxarMJBiWZ14zqqV5cG6Mx@mail.gmail.com>
Subject: [INFO] ndiswrapper WEP key problems with iwconfig
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This email is for informational purposes.  Lot's of folks have
problems with ndiswrapper when using WEP if you configure from the
command line or are using Fedora. If you try to use iwconfig manually,
i.e.

iwconfig wlan0 essid "SOMEID"

it does not display the essid in iwconfig.  Also the default is to set
the security mode is always "restricted" which does not work with WEP
by default, even if you change the security mode manually.  So a
sequence like:

iwconfig wlan0 key 0123456789
iwconfig essid SOMEID

usually does not work correctly on some versions of Fedora.

The fix is to set all the iwconfig params in a single command and be
aware the default security mode of "restricted" does not work with
ndiswrapper.

Try using iwconfig in the following manner and it will usually work:

iwconfig wlan0 key open 0123456789 essid SOMEID

Jeff
