Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2BBMsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:48:03 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:44391 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2BBMsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:48:00 -0500
MIME-Version: 1.0
X-MIMETrack: S/MIME Sign by Notes Client on Christian Hoff/Germany/IBM(Release 8.5.2FP3|Aug
 10, 2010) at 02/02/2012 13:44:29,
	Serialize by Notes Client on Christian Hoff/Germany/IBM(Release 8.5.2FP3|Aug
 10, 2010) at 02/02/2012 13:44:29,
	Serialize complete at 02/02/2012 13:44:29,
	S/MIME Sign failed at 02/02/2012 13:44:29: The cryptographic key was not
 found,
	S/MIME Sign by Notes Client on Christian Hoff/Germany/IBM(Release 8.5.2FP3|Aug
 10, 2010) at 02/02/2012 13:47:33,
	Serialize by Notes Client on Christian Hoff/Germany/IBM(Release 8.5.2FP3|Aug
 10, 2010) at 02/02/2012 13:47:33,
	Serialize complete at 02/02/2012 13:47:33,
	S/MIME Sign failed at 02/02/2012 13:47:33: The cryptographic key was not
 found,
	Serialize by Router on D06MC042/06/M/IBM(Release 8.5.2FP3|July 10, 2011) at
 02/02/2012 13:47:30,
	Serialize complete at 02/02/2012 13:47:30
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] virtio-scsi: first version
X-KeepSent: 4E98986D:B067F57F-C1257998:0045E0BE;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF4E98986D.B067F57F-ONC1257998.0045E0BE-C1257998.00464590@de.ibm.com>
From: Christian Hoff <christian.hoff@de.ibm.com>
Date: Thu, 2 Feb 2012 13:47:27 +0100
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
x-cbid: 12020212-1948-0000-0000-000000CFAFBC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Paolo,

Paolo Bonzini wrote:
> +              cmd->req.cmd = (struct virtio_scsi_cmd_req){
> +                              .lun[0] = 1,
> +                              .lun[1] = sc->device->id,
> +                              .lun[2] = (sc->device->lun >> 8) | 0x40,
> +                              .lun[3] = sc->device->lun & 0xff,
> +                              .tag = (unsigned long)sc,
> +                              .task_attr = VIRTIO_SCSI_S_SIMPLE,
> +                              .prio = 0,
> +                              .crn = 0,
> +              };

just wondering why you truncate target IDs to one byte? Also, why do you 
limit LUN numbers to 16 bits?

Also will it be possible to extend virtio-scsi to support more than one 
HBA without changing the ABI?

Other than that the patch looks good and I have been using virtio-scsi 
successfully for some time now on my private clone of qemu. 

Mit freundlichen Grüßen / Kind regards Christian Hoff 
-----------------------------------------------------------------------------------------------------------------------------------
IBM Deutschland
Am Fichtenberg 
171083 Herrenberg
-----------------------------------------------------------------------------------------------------------------------------------
IBM Deutschland GmbH / Vorsitzender des Aufsichtsrats: Martin 
JetterGeschäftsführung: Martina Koederitz (Vorsitzende), Reinhard Reschke, 
Dieter Scholz, Michael Diemer, Gregor PillenSitz der Gesellschaft: 
Ehningen / Registergericht: Amtsgericht Stuttgart, HRB 14562 / 
WEEE-Reg.-Nr. DE 99369940

