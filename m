Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0L1QKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 11:10:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32958 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0L1QKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 11:10:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=fPTesvJKK7CmOg8haDL3Dk+8+iy5BU3uQ02CyH+COs7ymqTRTUIv7PRuPozO/uC/CW
         DdwqY6nT5dMg60pDk5cl94hNfoSDAmZJKpB9Gjs/gIzjjH+rWIq3VmoyCSiYbdnC0/uv
         d4IR+SmfOzmt39aBCiuIxkrlB8RAmTOdWvN8w=
Message-ID: <4D1A0B1C.70406@gmail.com>
Date: Tue, 28 Dec 2010 17:06:52 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>, tytso@mit.edu,
        chris.mason@oracle.com
Subject: Bug in ext4/btrfs fallocate?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it seems that ext4/btrfs code for fallocate doesn't check for
immutable/append inode flag. I think it's possible to do an fallocate
operation even if the immutable flag is turned on. You can think about
this case: an application opens a file for read/write, meanwhile a user
set the immutable flag and then the application calls fallocate. Other
cases shouldn't happen because if the immutable flag is turned on before
the application opens the file, then the application can't open the file
in read/write mode and therefore it can't do an fallocate operation.
Sincerely I haven't tried but I saw this kind of error in my own fs that
have a similar code.

Regards,

Marco
