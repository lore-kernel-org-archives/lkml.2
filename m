Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1CVE21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 00:28:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51608 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1CVE2Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 00:28:25 -0400
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] First round of SCSI updates for 2.6.38 merge window
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1300392635.17266.5.camel@mulgrave.site>
	<AANLkTinvwKzYiy5M=Eoae_ViRQwVBF-TgedKspP0qagE@mail.gmail.com>
Date: Tue, 22 Mar 2011 00:27:42 -0400
In-Reply-To: <AANLkTinvwKzYiy5M=Eoae_ViRQwVBF-TgedKspP0qagE@mail.gmail.com>
	(Geert Uytterhoeven's message of "Sat, 19 Mar 2011 21:00:50 +0100")
Message-ID: <yq1fwqfu6dd.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D882543.006F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Geert" == Geert Uytterhoeven <geert@linux-m68k.org> writes:

Geert> drivers/scsi/sd.c: In function ‘sd_prep_fn’:
Geert> drivers/scsi/sd.c:544: warning: ‘ret’ may be used uninitialized
Geert> in this function

Sorry about that.


sd: Fail discard requests when logical block provisioning has been disabled

Ensure that we kill discard requests after logical block provisioning
has been disabled in sysfs.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3be5db5..7ff61d7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -597,6 +597,7 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 		break;
 
 	default:
+		ret = BLKPREP_KILL;
 		goto out;
 	}
 
