Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1C3Gyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 02:54:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1C3Gyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 02:54:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] unicore32 framebuffer driver fix: make videomemory kmalloc-ed and floatable
Date: Wed, 30 Mar 2011 08:54:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: "'Paul Mundt'" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
References: <019701cbee1e$c4e2d260$4ea87720$@mprc.pku.edu.cn> <201103291642.49555.arnd@arndb.de> <01ca01cbee7b$4f790370$ee6b0a50$@mprc.pku.edu.cn>
In-Reply-To: <01ca01cbee7b$4f790370$ee6b0a50$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103300854.05366.arnd@arndb.de>
X-Provags-ID: V02:K0:fuWg3mKRWsuqQSLRWb1auFQnGOWAW12OaePNYPaHgRM
 KpnmrjH4Gej/uBp8GxKKdQ+eSU4hgPNXtayomxn03L4auBCOLL
 /MYmFqonMBDhoFYp5JtQT/y0zkdIN0KlzFOUiwizpLbrZHWyUk
 W/KWQoYIjWW9NtwMSKT5ATQ7rTyCOLnkgaw3BLhP8FtLy/Tujn
 pjH6vIv46RV2p3JoRa23g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011 03:39:26 Guan Xuetao wrote:
> > How does this work? UNIFB_MEMSIZE seems to be 4 MB, much more than the
> > maximum of 128 KB that kmalloc can allocate.
> > 
> > Shouldn't this use get_free_pages() instead of kmalloc?
> > 
> 
> When using SLUB allocator, if required memory size  is larger
> than 2*PAGE_SIZE, kmalloc_large is called,
> and eventually __get_free_pages will  be called.
> So,  it would be the same as __get_free_pages.

Ok, I see. It's probably still better to use __get_free_pages directly,
because it's possible to select a different allocator that does not
do this itself.

	Arnd
