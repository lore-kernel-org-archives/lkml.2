Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676Ab0I0PiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:38:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594Ab0I0PiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:38:14 -0400
Date: Mon, 27 Sep 2010 11:38:04 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
Message-ID: <20100927153804.GC26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-6-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285549026-5008-6-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

On Mon, Sep 27, 2010 at 08:57:05AM +0800, Huang Ying wrote:
> @@ -360,6 +362,14 @@ io_check_error(unsigned char reason, str
>  static notrace __kprobes void
>  unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
>  {
> +	/*
> +	 * On some platforms, hardware errors may be notified via
> +	 * unknown NMI
> +	 */
> +	if (unknown_nmi_for_hwerr)
> +		panic("NMI for hardware error without error record: "
> +		      "Not continuing");

Can you modify this to let users know to check the BIOS/BMC for further
messages?  Otherwise people just file bugzillas asking what the problem
is, and the first thing we have to respond with is check the BIOS/BMC.

Cheers,
Don
