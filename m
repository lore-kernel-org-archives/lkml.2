Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab0DEUYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:24:15 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59503 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab0DEUYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lTyQ0sEOclFKbtub+UunmdGb6p2DIZWan2G6lx7PqHmVS8MLxWkQqxEK57iPM/h3Od
         3poPIjIEt2UyZuDwxVgU/4okndu7nNljCoBkwcXu8grcPciRYE+2CcB6X72YF+dXI/bW
         vYgSLgihuFBXdv1q3jRPD7KD4swT1kcWpj5Ag=
Subject: [BUG] x86info fails on 2.6.34 ?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Apr 2010 22:24:01 +0200
Message-ID: <1270499041.9013.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave

I just noticed x86info was not working anymore on latest kernel

x86info v1.24.  Dave Jones 2001-2009
Feedback to <davej@redhat.com>.

type seek: Value too large for defined data type


Offending syscall is an lseek(fd, -1, SEEK_CUR) on /dev/mem file



open("/dev/mem", O_RDONLY)              = 3
...
lseek(3, 1023092, SEEK_SET)             = 1023092
read(3, "PCMP\4\3\4\266HP      PROLIANT    \0\0\0\0\0"..., 44) = 44
read(3, "\0"..., 1)                     = 1
lseek(3, -1, SEEK_CUR)                  = -1 EOVERFLOW (Value too large
for defined data type)

It seems -1 is taken as an unsigned quantity ?


