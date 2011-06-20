Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab1FTIIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:08:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42998 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1FTIIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:08:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UAVtt0FU121xatw4Fx7jwmLGcMf1BYnP6oL0Z+HBov/vpvjjEwCHy4LtMYcznHNrkG
         HdpoMObJc+EXNGCmpTWDBLWoCXF+o8syB2xsPS6sjDC2b6rkohUYaEhDeQyFbrdttBTZ
         UrxVeYc1GqIzSlahyk/vDWoynU6vWsWU0yhp4=
MIME-Version: 1.0
Date: Mon, 20 Jun 2011 17:08:21 +0900
Message-ID: <BANLkTimuqNey8jUHkLS-MkmBWf8Tcu9=Cg@mail.gmail.com>
Subject: WARNING:'hweight_long' include/linux/bitops.h compile warning problem.
From: NamJae Jeon <linkinjeon@gmail.com>
To: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. Arnd

I found compile warning while compiling module when using -Wsign-compare option.

include/linux/bitops.h: In function 'hweight_long':
include/linux/bitops.h:49: warning: signed and unsigned type in
conditional expression

I found the reason of this problem that the default return value of
the below macro is signed.

#define __const_hweight8(w)        \
     ( (!!((w) & (1ULL << 0))) +       \
       (!!((w) & (1ULL << 1))) +       \
       (!!((w) & (1ULL << 2))) +       \
       (!!((w) & (1ULL << 3))) +       \
       (!!((w) & (1ULL << 4))) +       \
       (!!((w) & (1ULL << 5))) +       \
       (!!((w) & (1ULL << 6))) +       \
       (!!((w) & (1ULL << 7))) )

So, I try to add (unsigned long) in __const_hweight8 like this.

#define __const_hweight8(w)     (unsigned long )        \
     ( (!!((w) & (1ULL << 0))) +       \
       (!!((w) & (1ULL << 1))) +       \
       (!!((w) & (1ULL << 2))) +       \
       (!!((w) & (1ULL << 3))) +       \
       (!!((w) & (1ULL << 4))) +       \
       (!!((w) & (1ULL << 5))) +       \
       (!!((w) & (1ULL << 6))) +       \
       (!!((w) & (1ULL << 7))) )

so, I can't see compile warning after fixing it, Would you plz check this ?

Thanks.
