Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab0LQKtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:49:07 -0500
Received: from goliath.siemens.de ([192.35.17.28]:17889 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab0LQKtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:49:06 -0500
Message-ID: <4D0B400D.8010903@siemens.com>
Date: Fri, 17 Dec 2010 11:48:45 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012161410440.12146@localhost6.localdomain6> <4D0A75E3.3090900@web.de> <4D0B1CD9.5060601@web.de> <alpine.LFD.2.00.1012171116480.12146@localhost6.localdomain6> <4D0B3C11.4090307@siemens.com> <alpine.LFD.2.00.1012171137430.12146@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012171137430.12146@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.12.2010 11:41, Thomas Gleixner wrote:
> On Fri, 17 Dec 2010, Jan Kiszka wrote:
>> Am 17.12.2010 11:23, Thomas Gleixner wrote:
>>> OTOH, if we have to disable anyway, then we could simply keep it
>>> disabled across the installation of a new handler. That would make the
>>> notification business go away, wouldn't it ?
>>
>> No, the notification is still necessary in case the registered handler
>> keeps the line off after returning from both hard and threaded handler.
> 
> And how should that happen? If it is in oneshot mode then the line is
> reenabled when the thread handler returns.

disable_irq_nosync is called by the handler before returning. And it's
the handler's job to revert this, properly synchronizing it internally.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
