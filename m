Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab1ANSoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:44:24 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62848 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1ANSoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:44:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hBiMpr4UR01PSaSk2ngG1CgvUBVxCcYfPCqyjAG/lRMI6G7vKT+HurS1rtKkleIWXc
         ojnwGJh3Of+xHzBxjpnyQ8hCMymb4xmTf39yXHpbwSeZ96HmN1MmikQ82DXkDcuJeDiR
         vUxYQRrb7oanWLU/yAL/Z1CO2cQIhINBZkdLc=
Message-ID: <4D309981.5030107@garzik.org>
Date: Fri, 14 Jan 2011 13:44:17 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: David Miller <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, marvin@mydatex.cz
Subject: Re: IRQ enable/disable BUG in IDE w/shared IRQs
References: <20110113.233259.157492570.davem@davemloft.net> <alpine.LFD.2.00.1101141031320.2678@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1101141031320.2678@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 05:30 AM, Thomas Gleixner wrote:
> On Thu, 13 Jan 2011, David Miller wrote:
>> I have a hard time believing we've gotten away with this for so long.
>> Maybe it really is that rare to share the IDE interrupts with other
>> stuff?
>
> IIRC, the legacy IDE interrupts were 14/15 and those were never shared.

Yes, non-shared 14/15 were the 95% common case for the longest time. 
Sharing IDE interrupts within old-IDE worked FSVO "working", but the 
interrupt probes were written for a non-shared interrupt, then hacking 
into working for shared interrupts when PCI first starting showing up on 
the scene.

	Jeff


