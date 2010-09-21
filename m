Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0IUWqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:46:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45966 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab0IUWqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:46:37 -0400
Message-ID: <4C99359D.9020700@oracle.com>
Date: Tue, 21 Sep 2010 15:45:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] FW_LOADER: fix kconfig dependency warning on HOTPLUG
References: <20100918132308.074b6c01.randy.dunlap@oracle.com> <20100921222548.GA21202@kroah.com>
In-Reply-To: <20100921222548.GA21202@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/10 15:25, Greg KH wrote:
> On Sat, Sep 18, 2010 at 01:23:08PM -0700, Randy Dunlap wrote:
>>
>> BTW, drivers/base/firmware_class.c should #include <linux/kobject.h>.
> 
> Why, it looks like it builds properly now, right?

Yes, it builds because (apparently) some other header file is causing
<linux/kobject.h> to be sucked in.  That's not how we prefer to have header
files used.

See Documentation/SubmitChecklist, item #1 (from Stephen Rothwell):

1: If you use a facility then #include the file that defines/declares
   that facility.  Don't depend on other header files pulling in ones
   that you use.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
