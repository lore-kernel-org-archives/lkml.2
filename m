Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1C3Kzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:55:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51198 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab1C3Kz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:55:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] unicore32 framebuffer driver fix: make videomemory kmalloc-ed and floatable
Date: Wed, 30 Mar 2011 12:55:18 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "'Paul Mundt'" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
References: <019701cbee1e$c4e2d260$4ea87720$@mprc.pku.edu.cn> <201103300854.05366.arnd@arndb.de> <01ea01cbeeb6$99bb5240$cd31f6c0$@mprc.pku.edu.cn>
In-Reply-To: <01ea01cbeeb6$99bb5240$cd31f6c0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301255.18551.arnd@arndb.de>
X-Provags-ID: V02:K0:+YMExDqKgp7Q1rQe9Vi3/zUEsDjfVzJUbTmqq+2dELx
 krJGYJ8TMbaRS6EwJOqXUIZGsn6qYzRTKS43i95g5LkjS8lHeL
 gHnlXby0s91nVJ1NwkiBaOnUqZWHw+YDiyE3DZOuDH8m9z5cUz
 3DiLo+0D5vpNp0FqpU2LJimPItEnp3ejGeHBq4RBcsQK4GIdiC
 6RF4gKRJPGuhgTvhg84lg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011, Guan Xuetao wrote:
> Is it appropriate to using __get_free_pages in framebuffer driver?

Yes, it is appropriate, and it is also more efficient than using
kmalloc.

> And both SLAB and SLUB allocators support 4MB request.

Ok, I did not know that, but I see now how the maximum size is computed.
The limit was 128 KB for a long time, but has apparently changed.

	Arnd
