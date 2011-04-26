Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab1DZU6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:58:14 -0400
Received: from solo.fdn.fr ([80.67.169.19]:60850 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab1DZU6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:58:13 -0400
Date: Tue, 26 Apr 2011 22:58:09 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: konrad.wilk@oracle.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] pv-grub: Fix for incorrect dom->p2m_host[] list initialization
Message-ID: <20110426205809.GU4918@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Daniel Kiper <dkiper@net-space.pl>, konrad.wilk@oracle.com,
	stefano.stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
	linux-kernel@vger.kernel.org
References: <20110426185649.GA29940@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110426185649.GA29940@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kiper, le Tue 26 Apr 2011 20:56:49 +0200, a écrit :
> New time optimized version.
> 
> After a lot of debugging and long reading of Linux Kernel and Xen code
> finally I killed deeply hidden bug in pv-grub. Details below.
> Additionally, I am CC'ing this e-mail to LKML because this issue
> looks like Linux Kernel problem, however, it is not.
> 
> This patch applies to Xen Ver. 4.0, Xen Ver. 4.1 and Xen unstable tree.
> 
> # HG changeset patch
> # User dkiper@net-space.pl
> # Date 1303843062 -7200
> # Node ID c4c2919afe9727e107ad3b862619b40d4731d3e4
> # Parent  dbf2ddf652dc3dd927447e79ef4bc586de55d708
> Introduction of Linux Kernel git commit ceefccc93932b920a8ec6f35f596db05202a12fe
> (x86: default CONFIG_PHYSICAL_START and CONFIG_PHYSICAL_ALIGN to 16 MB) revealed
> deeply hidden bug in pv-grub. During kernel load stage dom->p2m_host[] list has
> been incorrectly initialized.
> 
> At the beginning of kernel load stage dom->p2m_host[] list is populated with
> current PFN->MFN layout. Later during memory allocation (memory is allocated
> page by page in kexec_allocate()) page order is changed to establish linear
> layout in new domain. It is done by exchanging subsequent MFNs with newly
> allocated MFNs. dom->p2m_host[] list is indexed by currently requested PFN
> (it is incremented from 0) and PFN of newly allocated paged. If PFN of newly
> allocated page is less than currently requested PFN then earlier allocated
> MFN is overwritten which leads to domain crash later. This patch corrects
> that issue. If PFN of newly allocated page is less then currently requested
> PFN then relevant PFN/MFN pair is properly calculated and usual exchange
> occurs later.
> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>

Reviewed-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
