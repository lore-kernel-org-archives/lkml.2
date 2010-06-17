Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310Ab0FQQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:16:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38280 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab0FQQQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FWqtYPyEFqM3o9aIJSSctPKvo4rUy8zggCUa1iJRNf+unt9EtNuhn44KnmOsSQM10K
         nDkpaHRg0k8v/62axcuJmLhAOAmWqHXCV8MXTRAclCxV3Gh6nKRxdJ8yj00ekqiHJG+y
         D25dGzyZx+gvKtE2US7qgJCNqcgLwnC8+jmSY=
Message-ID: <4C1A4A69.7060801@gmail.com>
Date: Thu, 17 Jun 2010 09:16:41 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/5]scsi:hosts.c Fix warning: variable 'rval' set but
 not used
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>	 <1276666434-11227-6-git-send-email-justinmattock@gmail.com>	 <1276702443.2847.153.camel@mulgrave.site>  <4C18F524.4000902@gmail.com> <1276709590.2847.176.camel@mulgrave.site>
In-Reply-To: <1276709590.2847.176.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Erm, well, as I said, error code and the fact that the thread failed to
> start, so more
>
> printk(KERN_WARNING "scsi%d: error handler thread failed to spawn, error
> = %d\n", host->host_no, PTR_ERR(shost->ehandler));
>
> James
>

o.k. I looked at this a bit more and finally got the thing to build 
through without a warning, using what you had sent, but keep in mind I 
still need to add error  = %d\n", host->host_no, to the printk

here's what I have so far:


  drivers/scsi/hosts.c |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 6660fa9..c1ff708 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -419,8 +419,9 @@ struct Scsi_Host *scsi_host_alloc(struct 
scsi_host_template *sht, int privsize)

  	shost->ehandler = kthread_run(scsi_error_handler, shost,
  			"scsi_eh_%d", shost->host_no);
+	rval = PTR_ERR(shost->ehandler);
  	if (IS_ERR(shost->ehandler)) {
-		rval = PTR_ERR(shost->ehandler);
+		printk(KERN_WARNING "scsi%d: error handler thread failed to spawn\n", 
rval);
  		goto fail_kfree;
  	}

I'll continue to look at this today!!

cheers,

Justin P. Mattock
