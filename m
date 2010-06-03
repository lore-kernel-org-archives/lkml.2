Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab0FCIRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:17:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48483 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0FCIRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:17:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FLQoNOfFI8UpCKnARrTiwg95UgvqCYrxS311GJ089M4zKlVsNiWN9DTzbQmE4V+9in
         7PEAJfmezCNiFhBlll5oxk6ZdTPf7YF/KKtvRobCosEZboon3RGrwvnUe3ML7pgpMjp4
         GTHM6g0HokrCv8dD9vcsAOX5le6Hm0GtJwYcI=
Message-ID: <4C076521.8050108@gmail.com>
Date: Thu, 03 Jun 2010 10:17:37 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Don Zickus <dzickus@redhat.com>, Jeff Garzik <jgarzik@pobox.com>,
       Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-ide@vger.kernel.org
Subject: Re: hibernation hangs with ATA errors (lockup_detector bug)
References: <4C03C608.1040600@gmail.com> <20100601135004.GP15159@redhat.com> <4C051D44.7040203@gmail.com> <20100602184459.GA15159@redhat.com> <20100602191336.GA5164@nowhere> <20100602194336.GB5164@nowhere>
In-Reply-To: <20100602194336.GB5164@nowhere>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/02/2010 09:43 PM, Frederic Weisbecker wrote:
> But I'm eventually surprised about this: stopping the cpu hotplug callbacks
> prevents some ATA resume callbacks to execute.
> 
> Does that mean some ata resume path are done from a cpu hotplug notifier?
> That looks weird.

libata itself doesn't use any cpu hotplug notifier.  It just uses
suspend and resume callbacks.  It looks like somehow IRQ delivery is
screwed up?

Thanks.

-- 
tejun
