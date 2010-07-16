Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887Ab0GPJr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:47:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58713 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810Ab0GPJr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OKpI84wz4K6/VaVd9lPEmQHD5f9bqwkhQCvdj+glRmGj5aYV2cdAj0mWFWHjAFssPf
         Yx3r3LApJBFDF4BU/xSFCz0trTb/d/XDSd83whyWfjxlwN54f3bz8L+hxPke71f/yrBs
         heqmzQoWFd3dIVs4T7g2L7Md0D/e77pMedTIs=
Date: Fri, 16 Jul 2010 13:47:10 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: process_reloc_for_got: no ENOMEM check
Message-ID: <20100716094710.GA24173@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've found in ./arch/alpha/kernel/module.c in process_reloc_for_got()
such code:
                     
  g = kmalloc (sizeof (*g), GFP_KERNEL);
  g->next = chains[r_sym].next;
  g->r_addend = r_addend;
  g->got_offset = *poffset;

Here we use 'g' without checking it for zero. I don't know what this
function does so I cannot write a patch myself.

Thanks.
