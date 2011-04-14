Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab1DNUgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:36:01 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44290 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1DNUgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=uRmokcAucyQ1z5+s9wa+28ZdeN2c/G5ImRCe4O8y9++i3NK3CwVf2g+gVpJj+5kMzg
         X8EPFEe5K6efyOtaDSXqTX2KZg1Cs9w7dZZQN8VrQVzEUlNbAAAqWybHMYjJUFwZEb+M
         daeZ728M0+WgxW1fH1ZaSL831T5TbPjoFHrUc=
MIME-Version: 1.0
Date: Thu, 14 Apr 2011 17:35:58 -0300
X-Google-Sender-Auth: iYgDzob_3HoFRkhYCFiC6rgMyso
Message-ID: <BANLkTim-KC7qfijD5rFNTR98GSs=cTPzJw@mail.gmail.com>
Subject: [REGRESSION] 2.6.32.36 - Linux Xen DomU doesn't boot anymore
From: "guilherme m. schroeder" <guilherme.m.schroeder@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Linux Kernel 2.6.32.36 introduced a regression that prevents Linux Xen
DomU from booting.
Linux DomU starts and after a while it shutdown without log messages.

I bisected a vanilla kernel from 2.6.32.36 (bad) to 2.6.32.32 (good)
and got this commit:

vm:~/linux-2.6.32.y# git bisect bad
856460aa905dcc6d11a05a832d487a7b0ce69402 is the first bad commit
commit 856460aa905dcc6d11a05a832d487a7b0ce69402
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Fri Feb 18 11:32:40 2011 +0000

    xen: set max_pfn_mapped to the last pfn mapped

    commit 14988a4d350ce3b41ecad4f63c4f44c56f5ae34d upstream.

    Do not set max_pfn_mapped to the end of the initial memory mappings,
    that also contain pages that don't belong in pfn space (like the mfn
    list).

    Set max_pfn_mapped to the last real pfn mapped in the initial memory
    mappings that is the pfn backing _end.

    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    LKML-Reference: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 a679f50b64c290b9a51e3dba8d3d648bca50fdf0
e7b018c4e0015aae44ed6f9f6323d8b13d032b86 M	arch

I have tested against XCP 1.0, Citrix XenServer 5.6 and 5.6 FP1.
Without this patch, Linux DomU boots and runs fine.
If more info is needed, please let me know.
