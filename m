Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0IJQC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:02:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab0IJQC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:02:26 -0400
Date: Fri, 10 Sep 2010 12:02:11 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100910160211.GH4879@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-5-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284087065-32722-5-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -349,6 +351,14 @@ io_check_error(unsigned char reason, str
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
> +
>  #ifdef CONFIG_MCA

I'm not sure I agree with this.  I still see PCI SERR's not coming in
through port 0x61 and get routed to unknown_nmi_error.  Not sure we should
just assume that it is an APEI/HEST error and panic the box.

Also all the perf problems we have seen recently have been going through
that path as we slowly try to figure out why we are not catching those
unknown nmis.

I am grasping for straws here, but is there a register that APEI/HEST can
poke to see if it generated the NMI?

Cheers,
Don
