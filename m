Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab0EGRvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:51:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63388 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab0EGRvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:51:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kGeC4MP1z5D8mwOIr0D7o5PN16cF3CSAVrvt2wM8QPfubC3UqCsE/FC2/nRrXZsJGr
         9eyL1nagUacFd+Nspke31l0+fNJnGYedTfaCUqLuC4/AWVFJJSEcBdBaXHvvinjjBwZ4
         mNV/WRsVaurQIdgZQgAxoNAW/aiT79BJ9T4Hc=
MIME-Version: 1.0
Date: Fri, 7 May 2010 23:21:00 +0530
Message-ID: <y2gf22d86811005071051q28a4fa84g2a3ea1a7ff487934@mail.gmail.com>
Subject: Link time manipulation of kernel symbols like read/write
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Is it possible to wrap module entry points like open/close during the
module compilation?
By wrapping, I mean interposing using linker --wrap option. This is
very much possible in
user space and is commonly used to interpose library functions.

E.g.

void *
__wrap_malloc (int c)
{
  printf ("malloc called with %ld\n", c);
  return __real_malloc (c);
}

int main()
{
    malloc(17);
    return 0;
}

Above works expected, can we wrap kmalloc this way?

-Leo.
