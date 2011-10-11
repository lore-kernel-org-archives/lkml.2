Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1JKQOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:14:18 -0400
Received: from 2605ds1-ynoe.0.fullrate.dk ([90.184.12.24]:59757 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab1JKQOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:14:17 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Oct 2011 12:14:16 EDT
Message-ID: <4E9469CC.4090507@krogh.cc>
Date: Tue, 11 Oct 2011 18:07:40 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        aradford@gmail.com, xfs@oss.sgi.com
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O
 load
References: <20111011091757.GA32589@otto.nzcorp.net> <20111011133448.GA10692@infradead.org> <20111011141338.GA11808@otto.nzcorp.net>
In-Reply-To: <20111011141338.GA11808@otto.nzcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-11 16:13, Anders Ossowicki wrote:
> On Tue, Oct 11, 2011 at 03:34:48PM +0200, Christoph Hellwig wrote:
>> This is core VM code, and operates purely on on-stack variables except
>> for the page cache radix tree nodes / pages.  So this either could be a
>> core VM bug that no one has noticed yet, or memory corruption.  Can you
>> run memtest86 on the box?
> Unfortunately not, as it is a production server. Pulling it out to memtest 256G
> properly would take too long. But it seems unlikely to me that it should be
> memory corruption. The machine has been running with the same (ecc) memory for
> more than a year and neither the service processor nor the kernel (according to
> dmesg) has caught anything before this. It would be a rare (though I admit not
> impossible) coincidence if we got catastrophic, undetected memory corruption a
> week after attaching a new raid controller with a new disk array.
A sidenote that Anders forgot.. the system was stable for very long time,
but on a 2.6.37 kernel. We upgraded to 2.6.38 to get the raid-controller
support and then it crashed.

Now we're trying to get the new hardware in the air on 2.6.37 with  
backpatched
megaraid driver for the RAID-controller.

-- 
Jesper
