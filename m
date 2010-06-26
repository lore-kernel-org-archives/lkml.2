Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab0FZDwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 23:52:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56898 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab0FZDwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 23:52:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=esHq7LWzOjaKJDnJVPlNQIpOdbq+rU9nntKnW+6+rrkBsODHX49Pqs/EscPo3aWRnJ
         6s/8iM12YxjbK9rfpaqUY2+m09pcqTa2icJ/TAjtk1EgSMstYzaLRVBaFB9gfaLxI7cp
         FbRFELqMhEksG47T7A03GKTdbmz6cCHjNXuMY=
Message-ID: <4C257962.1060506@garzik.org>
Date: Fri, 25 Jun 2010 23:52:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org> <4C2577F2.4030005@garzik.org>
In-Reply-To: <4C2577F2.4030005@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 11:45 PM, Jeff Garzik wrote:
> ata_qc_complete_multiple(), you call
> unexpect_irq()
> expect_irq()


Correction,

	unexpect_irq() x N
	expect_irq()

for N NCQ commands.

Controller-wide irq twiddling in the function that completes a single 
ATA command is painful.

	Jeff


