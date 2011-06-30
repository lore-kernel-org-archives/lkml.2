Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1F3S3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:29:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47174 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab1F3S3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:29:15 -0400
Message-ID: <4E0CC06E.7040204@zytor.com>
Date: Thu, 30 Jun 2011 11:29:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Chubb <peter.chubb@nicta.com.au>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
Subject: Re: Acer Aspire One now hangs on reboot/shutdown
References: <w4oc1qp2wf.wl%peter@chubb.wattle.id.au>	<20110622194324.GD8861@srcf.ucam.org> <w4sjr1v323.wl%peter@chubb.wattle.id.au>
In-Reply-To: <w4sjr1v323.wl%peter@chubb.wattle.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 04:50 PM, Peter Chubb wrote:
>>>>>> "Matthew" == Matthew Garrett <mjg59@srcf.ucam.org> writes:
> 
> Matthew> On Wed, Jun 22, 2011 at 08:38:08PM +1000, Peter Chubb wrote:
>>>
>>> Hi Matthew, GIT commit 660e34cebf0a11d54f2d5dd8838607452355f321
>>> x86: reorder reboot method preferences causes my Acer Aspire One to
>>> hang on shutdown/reboot.
> 
> Matthew> Also, shutdown? Really?
> 
> Sorry, shutdown -r (which is reboot really).
> 
> 
> Writing the reset value `6' to the reset port 3321 in single user mode
> makes the screen go blank, and the machine to become totally
> unresponsive.  The power light remains on.  But the machine does *not*
> reboot.
> 
> I've put up the ACPI tables at
> http://www.cse.unsw.edu.au/~peterc/AspireOneACPI
> 
> The relevant part of the FADT is:
> [074h 0116 12]               Reset Register : <Generic Address Structure>
> [074h 0116  1]                     Space ID : 01 (SystemIO)
> [075h 0117  1]                    Bit Width : 08
> [076h 0118  1]                   Bit Offset : 00
> [077h 0119  1]                 Access Width : 01
> [078h 0120  8]                      Address : 0000000000000CF9
> 
> [080h 0128  1]         Value to cause reset : 06
> 

OK, so this machine is actively broken and needs a quirk.

Which "reboot=" options work on this machine?

	-hpa
