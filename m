Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab1IBXco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:32:44 -0400
Received: from mail.microway.com ([206.173.81.22]:33195 "EHLO microway.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750735Ab1IBXcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:32:42 -0400
Message-ID: <50815a5ec08cdb713de8eaa92ad6e8b3.squirrel@www.microway.com>
In-Reply-To: <4E56EA02.7020307@intel.com>
References: <201108171751.51648.rick@microway.com>
    <8338f9871d1f52f9376a1eca319a7866.squirrel@www.microway.com>
    <201108222047.11086.rjw@sisk.pl> <201108221651.35654.rick@microway.com>
    <20110823171432.GA10794@redhat.com>
    <faf1d1211a8d409b39119e44727b3c83.squirrel@www.microway.com>
    <4E547B0F.6000001@intel.com>
    <cf5a31c38191654364bd281df6cb81e0.squirrel@www.microway.com>
    <7f348bab30fb6be7706ef35af999e5b1.squirrel@www.microway.com>
    <4E56EA02.7020307@intel.com>
Date: Fri, 2 Sep 2011 19:32:38 -0400
Subject: Re: kernel oops and panic in acpi_atomic_read under 2.6.39.3.   call
 trace included
From: rick@microway.com
To: "Huang Ying" <ying.huang@intel.com>
Cc: "Don Zickus" <dzickus@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richard Houghton" <rhoughton@microway.com>,
        "ACPI Devel Mailing List" <linux-acpi@vger.kernel.org>,
        "Len Brown" <lenb@kernel.org>, "Matthew Garrett" <mjg59@srcf.ucam.org>
User-Agent: SquirrelMail/1.4.21
X-Priority: 3 (Normal)
Importance: Normal
X-Sanitizer: Advosys mail filter
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

Sorry for the delay in my response.  Hurricane Irene delayed our testing a
bit.

I had to switch the 5620 CPUS I had for 5670s.  After 4 days of running
(it was usually about 2 before) I finally got this output in dmesg:

[337296.365930] GHES: gar accessed: 0, 0xbf7b9370
[337296.365936] ACPI atomic read mem: addr 0xbf7b9370 mapped to
ffffc90013ee8370

It is not mapped to 0 as expected, but it didn't crash now!

Thanks,
Rick

> On 08/25/2011 11:47 PM, rick@microway.com wrote:
>> Hi Huang,
>>
>> My new setup reproduced the panic. However I do not have any gar
>> accessed
>> messages on it.  The gar mapped messages are in my previous email.  Here
>> is the latest call trace.  There is no GHES output prior to it:
>>
>
> That is wired.  Can you try the patch attached?  If my guessing is
> correct, there will be no panic, but something as follow will be in dmesg:
>
> ACPI atomic read mem: addr 0xxxxx mapped to 0
>
> Best Regards,
> Huang Ying
>


