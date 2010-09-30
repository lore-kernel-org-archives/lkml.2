Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab0I3TBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:01:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37429 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab0I3TBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:01:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=PbPWBynKEKQ2kLAiGu1XoPNxqtS+vaSnM7awJDSb1tJUDbrdzsOksF9DxS8LuwifuX
         TyKBVgBm89WdTjv6RE/xILWKqcdSfL5STNUyzo3085hQ1HbMd6GS6uX5YLOZmLIvbLjA
         DVdeaaIVtrU/PtrxUmxZ0gXG9ZzGHwh/ssYtU=
MIME-Version: 1.0
Date: Thu, 30 Sep 2010 14:01:00 -0500
Message-ID: <AANLkTi=A=MH1hNMKCOHL8_j7ZHBVQfDHL-KuekvGUcSL@mail.gmail.com>
Subject: DEVELOPER ONLY vs. EXPERIMENTAL in Kconfigs
From: Steve French <smfrench@gmail.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which is the preferred configure option for early experimental code -
"DEVELOPER ONLY" or "EXPERIMENTAL"  ?

After successful testing at the Storage Developer Conference last
week, I am trying to clean up the smb2 (network file system) config
files and had a question about marking an option as "DEVELOPER ONLY"
in Kconfig.  The smb2 file system mounts, does basic file operations,
but has enough known bugs that I would lean toward marking it
"DEVELOPER ONLY" initially, as NFS client did with NFSv4.1 support at
first - but I don't see other components using "DEVELOPER ONLY" (and
"DEVELOPER" for some component seems to mean something different  -
like tools that developers might use instead of "code that is mainly
intended for developers working on network file systems and Samba but
not for general users yet").  Is "DEVELOPER ONLY" or "EXPERIMENTAL"
preferred?

Jeff Layton and I discussed creating a "fs/cifs_common" directory to
move shared code into (perhaps as much as 25% of the code eventually)
for smb2 and cifs, and getting the smb2 code checked in, will help
make this transition faster.   Even though the smb2 and cifs network
file system protocols are quite different (and smb2 is simpler), there
is some overlap in areas such as connection establishment, and
security which will benefit from the move into cifs_common, and
getting the smb2 code in (as either "DEVELOPER ONLY" or "EXPERIMENTAL"
will help).

-- 
Thanks,

Steve
