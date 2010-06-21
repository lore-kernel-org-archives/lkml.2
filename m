Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab0FUQd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:33:58 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51209 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932316Ab0FUQd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:33:57 -0400
Subject: Re: 2.6.35-rc3 regression: IBM Maia system is unbootable [ACPI
 related?]
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <87pqzkqrzq.fsf@basil.nowhere.org>
References: <1277136189.10998.63.camel@mulgrave.site>
	 <87pqzkqrzq.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 11:33:54 -0500
Message-ID: <1277138034.10998.69.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 18:18 +0200, Andi Kleen wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> > The system in question has a set of root bridges, with the CD rom (which
> > is seen) being on bus 0 and the SCSI controller, which doesn't show up
> > being on bus 1 (with several other things on busses > 1).
> >
> > The system uses ACPI to detect the multiple bridges, so it seems that
> > this failure in 2.6.35-rc3:
> >
> > ACPI: Core revision 20100428
> > ACPI Error: Hardware did not enter ACPI mode (20100428/evxfevnt-103)
> > ACPI Warning: AcpiEnable failed (20100428/utxface-147)
> > ACPI: Unable to enable ACPI
> 
> That probably causes all the other problems. Without ACPI enabled
> modern systems generally do not work.
> 
> Just guessing, but maybe try to revert
> 
> b430acbd7c4b919886fa7fd92eeb7a695f1940d3
> 
> That was the last change in this area.

I can confirm that reverting this over a vanilla 2.6.35-rc3 fixes my
boot problem.

James


