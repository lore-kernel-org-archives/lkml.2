Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0IVWkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:40:45 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:38632 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751967Ab0IVWko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:40:44 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: OfEhDIsVM1l9O6z07Y6cT3q.jlvxi.tajkZUvlxBOXicWvU
 RNADzQdSMjuD0FPv4oWN_00Z1c8KagljFnoIMmkFbGIqqlg0NjgjLjxmYX30
 W4kznkPLi7gjWGq_mXOsPML5gKMQhSH3UhJS_IfgF4RO4yBEQ6HwNSvf7dOi
 HJPR4yemX9Vq3RnqiVJ5Q0MeJhENvHWd0mbVm5b2cTxBrSAdTVeWUBigC4cO
 tFR.ATcqg02ZAXPOaNwIEAorTVYCyHlqP.DHWfgioGlH3Jj0voLRTJkzAPF3
 ar_Ykk.AJwoglxkSEJN8nQeA-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 2/2] siw: Add support for CRC32C offload instruction
	using libcrypto crc32c-intel
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>
In-Reply-To: <20100922220611.GL11157@obsidianresearch.com>
References: <1285187425-10950-1-git-send-email-nab@linux-iscsi.org>
	 <4C9A698B.90806@linux.intel.com>
	 <1285187901.1849.85.camel@haakon2.linux-iscsi.org>
	 <20100922205943.GI11157@obsidianresearch.com>
	 <1285189241.1849.112.camel@haakon2.linux-iscsi.org>
	 <20100922211808.GJ11157@obsidianresearch.com>
	 <1285191511.1849.126.camel@haakon2.linux-iscsi.org>
	 <20100922220611.GL11157@obsidianresearch.com>
Content-Type: text/plain
Date: Wed, 22 Sep 2010 15:36:29 -0700
Message-Id: <1285194989.1849.130.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 16:06 -0600, Jason Gunthorpe wrote:
> On Wed, Sep 22, 2010 at 02:38:31PM -0700, Nicholas A. Bellinger wrote:
> 
> > So I think the main bit here is the ability to request
> > crc32c-intel.ko first, and then fall back to crc32c.ko when the
> > former is not available on CONFIG_X86.
> 
> Well, it is what Andi said, everything is working fine but there is no
> mechanism to autoload the accelerated crypto module. If you did
> modprobe crc32c_intel prior to loading your driver it would
> automatically get crc32c-intel when it asks for crc32c since it is
> loaded and a higher priority.
> 

Ah, OK.  I see what you mean now here wrt to libcrypto priorities and
crc32c + crc32c_intel modules.   My apologies for the in-experience with
libcrypto here..

> So, the drivers are correct to just request crc32c .. The work around
> to limited autoprobing is so trivial (modprob crc32_intel) I'm not
> sure including extra autoprobing code in the drivers is worthwhile?
> 

Indeed, I am happy to drop this patch if Bernard would be nice enough to
add a 'modprobe crc32_intel' into the SIW scripts.

Thanks for your comments Jason!

--nab

