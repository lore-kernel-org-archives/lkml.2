Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546Ab2JLL4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:56:32 -0400
Received: from mail.x86-64.org ([217.9.48.20]:56778 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758980Ab2JLL4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:56:31 -0400
Date: Fri, 12 Oct 2012 13:56:28 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC PATCH 3/3] Convert mce_disabled
Message-ID: <20121012115628.GA14991@aftab.osrc.amd.com>
References: <1349878801-15956-1-git-send-email-bp@amd64.org>
 <1349878801-15956-4-git-send-email-bp@amd64.org>
 <5077F600.9090605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5077F600.9090605@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 04:20:40PM +0530, Naveen N. Rao wrote:
> Hi Boris, Thanks for getting to this before I could!

Ah ok, I thought you wasn't interested in doing this anymore :).

> I had a look but I still feel boolean is a better way to go. With
> bool, we can get rid of the #defines above and more importantly, the
> aux field in dev_ext_attribute since that is used in other places
> too. Further, I suspect we'll still end up using the same or less
> memory since we don't have that many boolean members within the MCA
> code.

My main intention was to have all those in a single struct and use a
single store_bit/show_bit function.

Sure, you can do bools but this'll still be single variables spread
around in mce.c instead of one single struct mca_config which nicely
encapsulates all the configuration we do in the MCA code.

Or, you can modify the mca_config I have there and use bools and pass a
pointer to each actual bool member in each DEVICE_BIT_ATTR invocation
(and rename it to DEVICE_BOOL_ATTR). Yeah, that could work, unless I'm
missing something else, of course.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
