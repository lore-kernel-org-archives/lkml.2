Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1AaQXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:23:11 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50192 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1AaQXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:23:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tDfEmvBekkNJSxlW7Ay7lpubDzCLBMa1oQ+Ix7zanLdhn/qGGVQyKzZpfDHdA5rTbc
         qTwjy2w71JBQDErTV00KA4ZDFsvCD1DEIhNHLg+GDdeTTumC+fWyWM5RgY9AJ00zEUCQ
         YMfaJdUPXis9Add+et1XINIy6KRv4gckA9RBw=
MIME-Version: 1.0
Date: Mon, 31 Jan 2011 11:23:09 -0500
Message-ID: <AANLkTi=cCN4gaa_Gh=dWFXORe6mLVLF9y1nWoO5pCupF@mail.gmail.com>
Subject: Please correct this code
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
Regards,
Sri.
