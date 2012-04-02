Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab2DBRul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:50:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42520 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2DBRuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:50:40 -0400
Date: Mon, 2 Apr 2012 13:45:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 58/76] idle, x86: Allow off-lined CPU to enter deeper C
 states
Message-ID: <20120402174557.GA9446@phenom.dumpdata.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
 <1333102459-23750-1-git-send-email-lenb@kernel.org>
 <1a022e3f1be11730bd8747b1af96a0274bf6356e.1333101989.git.len.brown@intel.com>
 <CA+8MBbLROfbyfAGZ0xn1tZVHsndeTUNrn=-gHhsfzkocBLh=iQ@mail.gmail.com>
 <CA+8MBbJnrhKmy5f_pbL8Ogi1ihM-51hfqCDY5gUQ1hkvw7p22Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CA+8MBbJnrhKmy5f_pbL8Ogi1ihM-51hfqCDY5gUQ1hkvw7p22Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090207.4F79E6EA.0077,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 10:25:27AM -0700, Tony Luck wrote:
> >> +       while (1) {
> >> +
> >> +               if (cx->entry_method == ACPI_CSTATE_HALT)
> >> +                       halt();
> 
> What's the intent here?  I think that I can just set up a function pointer
> named "halt" on ia64 and point it to my cpu_halt() function (which looks
> for the deepest C-state, and then calls PAL to enter it. Is that equivalent
> to what the x86 "halt()" function does?

Or use the appropiate safe_halt() which should work on IA64.

> 
> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
