Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1GRNbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:31:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53332 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1GRNbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:31:05 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=XYJHFtupD_QA:10 a=ireDzxY-55sA:10 a=3jLnhWJ0iCQA:10 a=kj9zAlcOel0A:10 a=jYIiGc7Ns1uVrPe6EHAf2g==:17 a=SMAS4svWwT2ZaCSST1UA:9 a=CjuIK1q_8ugA:10 a=jYIiGc7Ns1uVrPe6EHAf2g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.113.120.88
Date: Mon, 18 Jul 2011 08:31:01 -0500
From: Ayman El-Khashab <ayman@elkhashab.com>
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 1/1] powerpc/4xx: enable and fix pcie gen1/gen2 on
 the 460sx
Message-ID: <20110718133101.GB26701@crust.elkhashab.com>
References: <1310603611-8960-2-git-send-email-ayman@elkhashab.com>
 <1310748027-31956-1-git-send-email-aymane@elkhashab.com>
 <20110718040115.GK20597@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718040115.GK20597@ozlabs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (crust.elkhashab.com [127.0.0.1]); Mon, 18 Jul 2011 08:31:03 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 02:01:15PM +1000, Tony Breeds wrote:
> On Fri, Jul 15, 2011 at 11:40:27AM -0500, Ayman Elkhashab wrote:
> 
> > @@ -1582,8 +1628,8 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
> >  		dcr_write(port->dcrs, DCRO_PEGPL_OMR2BAH, lah);
> >  		dcr_write(port->dcrs, DCRO_PEGPL_OMR2BAL, lal);
> >  		dcr_write(port->dcrs, DCRO_PEGPL_OMR2MSKH, 0x7fffffff);
> > -		/* Note that 3 here means enabled | single region */
> > -		dcr_write(port->dcrs, DCRO_PEGPL_OMR2MSKL, sa | 3);
> > +		dcr_write(port->dcrs, DCRO_PEGPL_OMR2MSKL,
> > +				sa | DCRO_PEGPL_OMRxMSKL_VAL);
> 
> Didn't you just change "sa | 3" to "sa | 1" ?
> 

Yes, but I think that is correct for it to be "1".  The data
sheets for these parts that I checked had bit 1 marked as
reserved.  Only OMR1MSKL and OMR3MSKL had extra definitions
such as the _IO and _UOT.  The parts I checked which were
the sheets for the EX and SX (which cover another 6 or 7
parts) all had it with just a single bit defined on that
register.

Ayman

