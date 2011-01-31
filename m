Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab1AaQh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:37:56 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54463 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1AaQhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:37:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=HpXkQam8TA0RfoYzDaiNpU9SjMFUP0QS0YtFXXxlfqNrGCkxPzRlcZOhmf6X6VOjyh
         wNLd2E8xmZdVCotqtRpZALGCD1NqfcbTGFm5PWDNLpnv1LVRJYwLNdNXIjYVkVA6LMNm
         gYoF0p5np0SdZFJiCbnPSgFiBk/xhC+qbD4vg=
MIME-Version: 1.0
Date: Mon, 31 Jan 2011 11:37:54 -0500
Message-ID: <AANLkTinR=GN+rNqAUcFrnUXea0aWmew-wde0oP22uPcj@mail.gmail.com>
Subject: Please correct this code
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have following snippet of code.

Code A

__asm__ __volatile__(
                     "   lock       ;\n"
                     "   addl %1,%0 ;\n"
                     : "=m"  (my_var)
                     : "ir"  (my_int), "m" (my_var)
                     :                                 /* no clobber-list */
                     );

Code B

 __asm__ __volatile__(  "decl %0; sete %1"
                     : "=m" (my_var), "=q" (cond)
                     : "m" (my_var)
                     : "memory"
                     );

In Code A memory contents are getting updated. And in Code B memory
contents and 'cond' var are getting updated.
In Code B in cobbler column 'memory' is used to indicate that this
code modifies memory contents. But where as in Code A it was not
mentioned

Is is not that Code A is wrong, for not mentioning cobbler list
'memory' to indicate memory contents are getting updated.
Please rectify me, if I am wrong.

Also, what does '+m' constraint mean, if I use in inline assembly.
--
Regards,
Sri.
