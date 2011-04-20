Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab1DTSCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:02:31 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:39357 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751984Ab1DTSC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:02:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=eNnzyDyNaOXiuFWV49VNuJnsdGBlB+SZHgod55kO61Tm/hvqGCkSY96/M2n6uqfxEn3YQXBrd2+y4/AZyVqZeB0RW5AHZZaH9/+HYMTKrWsVc2ZEwp2TQTCvuYAeD60b;
Date: Wed, 20 Apr 2011 11:02:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 20
Message-Id: <20110420110224.e3974722.rdunlap@xenotime.net>
In-Reply-To: <20110420144329.fce0e28e.sfr@canb.auug.org.au>
References: <20110420144329.fce0e28e.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 14:43:29 +1000 Stephen Rothwell wrote:

> Hi all,

> Merging sound/for-next
> Merging sound-asoc/for-next

Takashi,

mainline contains commit a2800300f28bd1814f3ba8cfd93ecb0b00c2dfe3
Author: Takashi Iwai <tiwai@suse.de>
Date:   Tue Mar 8 18:20:46 2011 +0100
    ALSA: asihpi - Use %zd for size_t argument in error message

which changes:
--- a/sound/pci/asihpi/hpi6205.c
+++ b/sound/pci/asihpi/hpi6205.c
@@ -2088,7 +2088,7 @@ static u16 message_response_sequence(struct hpi_adapter_ob
j *pao,
 		phr->specific_error = sizeof(interface->u);
 		phr->size = sizeof(struct hpi_response_header);
 		HPI_DEBUG_LOG(ERROR,
-			"message len %d too big for buffer %ld \n", phm->size,
+			"message len %d too big for buffer %zd \n", phm->size,
 			sizeof(interface->u));
 		return 0;
 	}


However, it looks like there is a patch in your for-next branch which undoes
that commit, since hpi6205.c still uses %ld to print the sizeof() value and this
warning is still produced:

linux-next-20110420/sound/pci/asihpi/hpi6205.c:2091: warning: format '%ld' expects type 'long int', but argument 3 has type 'unsigned int'


Please drop at least that one line from for-next.

or am I completely befuddled?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
