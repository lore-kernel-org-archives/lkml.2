Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab0LVIx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 03:53:57 -0500
Received: from smtp.citrix.com ([66.165.176.89]:62248 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab0LVIx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 03:53:56 -0500
X-IronPort-AV: E=Sophos;i="4.60,212,1291611600"; 
   d="scan'208";a="11652601"
Subject: Re: [Xen-devel] [PATCH 03/10] xen/mmu: Add the notion of
 IDENTITY_P2M_ENTRY.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jan Beulich <JBeulich@novell.com>
In-Reply-To: <1292967460-15709-4-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
	 <1292967460-15709-4-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 22 Dec 2010 08:44:19 +0000
Message-ID: <1293007459.3998.33.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 21:37 +0000, Konrad Rzeszutek Wilk wrote: 
> P.S.
> We cannot set the IDENTITY_P2M_ENTRY in the P2M tree. This is b/c
> the toolstack considers that invalid and would abort during
> migration of the PV guest.

What do we do instead, just write the actual identity MFN value?

Does using 1UL<<30 (or 1UL<<62 on 64 bit, note that Jeremy recently
fixed FOREIGN_FRAME_BIT too) as IDENTITY_P2M_ENTRY keep the toolstack
happy while still allowing us to distinguish from identity from
happens-to-be-the-same as necessary?

To some extent 1-1 I/O regions could be considered foreign mappings (of
"memory" owned by DOMIO) so perhaps it's possible that setting the
FOREIGN_FRAME_BIT is both sufficient and correct?

Ian.


