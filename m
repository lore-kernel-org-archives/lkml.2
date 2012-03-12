Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2CLOiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:38:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47387 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2CLOiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:38:10 -0400
Date: Mon, 12 Mar 2012 14:38:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Vasco Dias <rafa.vasco@gmail.com>, linux-kernel@vger.kernel.org,
        mikew@google.com
Subject: Re: Problem with efibootmgr on asus 1215b
Message-ID: <20120312143806.GB12382@srcf.ucam.org>
References: <CAH1LqYj0pPnv-2dTx5gCXO=S8ypk_fSO6PDpwX-dToJp9ZWOnQ@mail.gmail.com>
 <1327060106.3618.53.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327060106.3618.53.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somewhat late to this I know, but:

On Fri, Jan 20, 2012 at 11:48:26AM +0000, Matt Fleming wrote:

> [  441.370854] BUG: unable to handle kernel paging request at 00000000ffe1fbc8

So it's attempting a direct access to 00000000ffe1fbc8, which, if I had 
to guess, is probably where the flash is located. That makes sense from 
the perspective of it being used in efivars. The obvious sadness here is 
that it's doing this with a physical address rather than a virtual one.

It's possible that the machine is too broken to live - does Windows 
succeed in performing a UEFI install? If it does then I think we need to 
just accept that life is ugly and map the UEFI runtime areas with a 1:1 
mapping as well as into virtual address space. That would also fix the 
problem we see right now where the reboot call often uses a physical 
address rather than a virtual one.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
