Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1AMH4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 02:56:42 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:52890 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab1AMH4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 02:56:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=NJRlpgE7IKOTSQ3pFvE8dt2CsAsybtsErYvo0xk1u6ZxN86L3RgXksFv3UhG9rKE8w
         gIvYtdcLek//Q0F88ENC57HjADRW+s9+/SvRB4wFEPrst/G0R4KQV8ZiU00eKvolX8On
         hr7o75Jx0fILOzxBGoTl+Pj/E7D228TKVVF2w=
MIME-Version: 1.0
Date: Thu, 13 Jan 2011 00:56:39 -0700
Message-ID: <AANLkTim+fY4jUoE_8zVkZ2xxZ+nT3_SeMrOvwW6714z9@mail.gmail.com>
Subject: [UPDATE] gcc NULL strings passed from ternary operators in kernel modules
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

might help if my examples are correct -- geez...

interesting case with gcc.  The following code example:

printk("%s\n", (value & 1) ? "set": "clear");

will evaluate to NULL unless the ":" character has a space after
static string declaration.

this version

printk("%s\n", (value & 1) ? "set" : "clear");

works.

go figure.   Looks like gcc assumes this case is a C++ construct of
some sort and
evaluates it to NULL.

Jeff
