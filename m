Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0KSRxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:53:08 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37377 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756044Ab0KSRxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:53:07 -0500
Subject: Re: [PATCH 8/9] scsi: megaraid_sas - Driver take some workloads
 from FW
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        "'akpm@osdl.org'" <akpm@osdl.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106A96223@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A961E4@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A961F2@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A96213@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A96218@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A9621E@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A96223@cosmail02.lsi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 11:53:01 -0600
Message-ID: <1290189181.23556.77.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 10:43 -0700, Yang, Bo wrote:
> Driver added the new feature to take some of the workloads from FW to increase
> performance of the iMR controller.  FW assigns the read cmds back to driver
> which will increase the performance for megaraid sas iMR controller.

Just on a process note: you don't have to cc me at every known
address ... I do read linux-scsi ...

My first take on this patch is that you're basically passing data back
to the kernel for RAID-N parity calculations.  This effectively makes
your RAID one of those pseudo HW ones.  In which case, why not simply
abandon the HW raid piece and have it all done by DM/MD, which are well
optimised for all types of RAID?  The reason for asking is that we're
trying to reduce the number of in-kernel raid implementations and this
is going in the wrong direction.

James


