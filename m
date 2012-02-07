Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab2BGOAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:00:10 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:54277 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab2BGOAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:00:06 -0500
In-Reply-To: <4F312492.1040002@de.ibm.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com> <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com>
To: BORNTRAE@linux.vnet.ibm.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, mst@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>, rusty@rustcorp.com.au
MIME-Version: 1.0
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
X-KeepSent: AFB86CAE:9917478D-C125799D:004AF231;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com>
From: Christian Hoff <christian.hoff@de.ibm.com>
Date: Tue, 7 Feb 2012 14:59:53 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Christian Hoff/Germany/IBM(Release 8.5.2FP3|Aug
 10, 2010) at 07/02/2012 14:59:58,
	Serialize by Notes Client on Christian Hoff/Germany/IBM(Release 8.5.2FP3|Aug
 10, 2010) at 07/02/2012 14:59:58,
	Serialize complete at 07/02/2012 14:59:58,
	S/MIME Sign failed at 07/02/2012 14:59:58: The cryptographic key was not
 found,
	Serialize by Router on D06MC042/06/M/IBM(Release 8.5.2FP3|July 10, 2011) at
 07/02/2012 14:59:55,
	Serialize complete at 07/02/2012 14:59:55
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
x-cbid: 12020714-0542-0000-0000-000000EB679D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paolo,

On 07/02/12 13:31, Paolo Bonzini wrote:
> The structure of the LUN is defined by SAM, not by me. 

Just had a look at the SAM LUN structure. It appears that you are using 
the SCSI format for hierarchical LUNs(SAM 5 chapter 4.7.6) in order to 
indicate that the LUN is actually attached to the host system and not to 
the Qemu guest operating system itself.

What I am wondering is why you are doing this? The hierarchical SCSI 
format is only retained while the LUN number is being transmitted over the 
virtqueue, so there does not seem to be a technical necessity for using 
this format in order to transmit SCSI target ID and LUN number information 
to the host.

Instead the format has some disadvantages:
- It uses up 8 bytes where 3 bytes would be sufficient in order to store 
both the target ID and LUN number information
- The format limits us to 255 target IDs. I agree that the LUN limit is 
probably more a theoretical and not a practical one, but 255 target IDs 
could become a limitation in the future.

Nonetheless I think that virtio-scsi is a useful project and addresses 
many of the limitations imposed by virtio-block. The fact that I am still 
persisting has more to do with interest in the project rather than wanting 
to keep the code from going upstream. Thank you for your work on this 
topic.

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




From:
BORNTRAE@linux.vnet.ibm.com
To:
Paolo Bonzini <pbonzini@redhat.com>
Cc:
Christian Hoff/Germany/IBM@IBMDE, linux-kernel@vger.kernel.org, 
linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com, 
kvm@vger.kernel.org
Date:
07/02/2012 14:18
Subject:
Re: Pe: [PATCH v5 1/3] virtio-scsi: first version



On 07/02/12 13:31, Paolo Bonzini wrote:
> The structure of the LUN is defined by SAM, not by me. 

Ok, got it.



