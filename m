Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2BFJvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 04:51:48 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:33370 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab2BFJvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 04:51:46 -0500
To: pbonzini@redhat.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,
        kvm@vger.kernel.org
MIME-Version: 1.0
Subject: Pe: [PATCH v5 1/3] virtio-scsi: first version
X-KeepSent: 2D939B55:7C07E33B-C125799C:0032B83A;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com>
From: Christian Hoff <christian.hoff@de.ibm.com>
Date: Mon, 6 Feb 2012 10:51:26 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Christian Hoff/Germany/IBM(Release 8.5.2FP3|Aug
 10, 2010) at 06/02/2012 10:51:32,
	Serialize by Notes Client on Christian Hoff/Germany/IBM(Release 8.5.2FP3|Aug
 10, 2010) at 06/02/2012 10:51:32,
	Serialize complete at 06/02/2012 10:51:32,
	S/MIME Sign failed at 06/02/2012 10:51:32: The cryptographic key was not
 found,
	Serialize by Router on D06MC042/06/M/IBM(Release 8.5.2FP3|July 10, 2011) at
 06/02/2012 10:51:28,
	Serialize complete at 06/02/2012 10:51:28
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
x-cbid: 12020609-5024-0000-0000-0000019C86B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paolo,

first let me say that your patch is working fine on my local clone of the 
qemu repository.

Let me ask just one question about the format of the data being 
transmitted over the virtqueue.

Paolo Bonzini wrote:
+                cmd->req.cmd = (struct virtio_scsi_cmd_req){
+                                .lun[0] = 1,
+                                .lun[1] = sc->device->id,
+                                .lun[2] = (sc->device->lun >> 8) | 0x40,
+                                .lun[3] = sc->device->lun & 0xff,
+                               [...]
+                };

Can't we have seperate fields for the SCSI target ID and the LUN number 
here? Putting all this into a single field seems confusing. The following 
line of code (sc->device->lun >> 8) | 0x40 essentially means that LUN 
numbers will be limited to 8+6 Bits=14 Bits for no obvious reason that I 
can see. Maybe we could just split the LUN field up into two uint32 fields 
for target ID and LUN number?

Also, lun[1] = sc->device->id means that only 255 SCSI target IDs will be 
supported. Think about bigger usage scenarios, such as FCP networks with 
several hundred HBAs in the net. If you want to have the target ID<->HBA 
mapping the same as on the guest as on the host, then 255 virtual target 
IDs could be a limit.

Sorry for coming up so late with these suggestions. I hope there is still 
enough time left to discuss and address these problems.

Mit freundlichen Grüßen / Kind regards

Christian Hoff

Student - Applied Computer Science


Phone:
49-16098976-950
 IBM Deutschland

E-Mail:
christian.hoff@de.ibm.com
 Am Fichtenberg 1


 71083 Herrenberg


 Germany


IBM Deutschland GmbH / Vorsitzender des Aufsichtsrats: Martin Jetter
Geschäftsführung: Martina Koederitz (Vorsitzende), Reinhard Reschke, 
Dieter Scholz, Gregor Pillen, Joachim Heel, Christian Noll
Sitz der Gesellschaft: Ehningen / Registergericht: Amtsgericht Stuttgart, 
HRB 14562 / WEEE-Reg.-Nr. DE 99369940 

