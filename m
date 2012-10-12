Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab2JLUUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:20:14 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:38672 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab2JLUUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:20:12 -0400
Date: Fri, 12 Oct 2012 14:20:05 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2] TPM: Provide a tpm_tis OF driver
Message-ID: <20121012202005.GL4124@obsidianresearch.com>
References: <20121002210453.GA12231@obsidianresearch.com>
 <20121010162428.GA5013@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010162428.GA5013@ennui.austin.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 11:24:28AM -0500, Kent Yoder wrote:

>   Why change the structs to const here? This generates warnings for me:

I should have dropped this, I was added when I added the __devinitdata
annotations..

> > +
> > +static struct platform_driver tis_driver = {
> >  	.driver = {
> >  		.name = "tpm_tis",
> >  		.owner		= THIS_MODULE,
> >  		.pm		= &tpm_tis_pm,
> > +		.of_match_table = of_match_ptr(tis_of_platform_match),
> >  	},
> 
>   Patch v2 removes the ifdef around of_match_table, which now generates
> an error:

Yes, this update was following the style of other drivers. Obviously I
never thought to try this on x86 (only PPC), so I will try to setup a
compile for that as well and send v3.

I suspect this is simply a missing #include.

Regards,
Jason
