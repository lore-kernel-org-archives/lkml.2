Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab2CSQDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:03:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:55318 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab2CSQDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:03:17 -0400
Subject: Re: EFI Boot Stub Early Console
From: Matt Fleming <matt.fleming@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Shea Levy <shea@shealevy.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120319155639.7cff5df6@pyx>
References: <4F5E46EA.7020602@shealevy.com> <4F5E47E4.2070303@shealevy.com>
	 <4F5E74A0.60001@zytor.com> <4F5E761B.7010608@shealevy.com>
	 <4F5E775D.7080702@zytor.com> <4F648DD3.3000405@shealevy.com>
	 <1332069701.4041.42.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4F65D09B.4050807@shealevy.com>
	 <1332146834.4041.46.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20120319155639.7cff5df6@pyx>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Mon, 19 Mar 2012 16:03:09 +0000
Message-ID: <1332172989.4041.52.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 15:56 +0000, Alan Cox wrote:
> > > any bootloader (including the bootstub) will call ExitBootServices() 
> > > before any printk'ing actually happens?? Or am I misunderstanding the 
> > > spec somehow? I suppose I could just try it and see what happens...
> > 
> > Oops. Good point, that isn't going to work.
> 
> Surely it works fine if you are using bootstub directly from EFI ?

Yeah, up until the point you call ExitBootServices(), which is very
early in the boot process. After that you can't rely on the validity of
the console pointers in the system table.

