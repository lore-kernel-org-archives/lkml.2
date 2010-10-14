Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0JNEYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:24:06 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58808 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0JNEYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:24:05 -0400
Date: Thu, 14 Oct 2010 06:24:09 +0200
From: Borislav Petkov <bp@amd64.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] edac/mce_amd: fix shift warning
Message-ID: <20101014042409.GB29342@aftab>
References: <20101013131057.88238be6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013131057.88238be6.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, Oct 13, 2010 at 04:10:57PM -0400

> The BIT() macro works on unsigned longs, but this warning happens
> on i386 (X86_32), where UL is 32 bits and this value needs to be
> 64 bits, so use open-coded ULL.
> 
> drivers/edac/mce_amd.c:262: warning: left shift count >= width of type

Ok, so BIT() should be fixed to work with the largest type available,
IMHO. Let me cook up something.

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Doug Thompson <dougthompson@xmission.com>
> Cc: Borislav Petkov <borislav.petkov@amd.com>

In the meantime, I'll push your fix to Linus, thanks for testing this on
32-bit :).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
