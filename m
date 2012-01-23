Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab2AWOiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:38:19 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:37748 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2AWOiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 09:38:17 -0500
Message-ID: <4F1D7056.1080705@linux.vnet.ibm.com>
Date: Mon, 23 Jan 2012 08:36:06 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com> <1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com> <20120120141232.a7572919.akpm@linux-foundation.org>
In-Reply-To: <20120120141232.a7572919.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012314-1780-0000-0000-0000028DBA7C
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00107443; UDB=6.00026946; UTC=2012-01-23
 14:38:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andrew, 

Thanks again for responding.

On 01/20/2012 04:12 PM, Andrew Morton wrote:
> On Mon,  9 Jan 2012 16:51:56 -0600
> Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:
> 
>> This patch creates a new memory allocation library named
>> zsmalloc.
> 
> I haven't really begun to look at this yet.  The code is using many
> fields of struct page in new ways.  This is key information for anyone
> to effectively review the code.  So please carefully document (within
> the code itself) the ways in which the various page fields are used:
> semantic meaning of the overload, relationships between them, any
> locking rules or assumptions.

Will do.

> It appears that a pile of dead code will be generated if CPU hotplug is
> disabled.  (That's if it compiles at all!).  Please take a look at users
> of hotcpu_notifier() - this facility cunningly causes all the hotplug code
> to vanish from vmlinux if it is unneeded.

I'll take a look at hotcpu_notifier() users.  Thanks.

> afacit this code should be added to core mm/.  Addition of code like
> this to core mm/ will be fiercely resisted on principle!  Hence the
> (currently missing) justifications for adding it had best be good ones.

Thanks for the insight.  I'll put some work into spelling out the benefits
this code provides that are not currently provided by any other code in the
kernel right now (afaik).

If you think this belongs in mm/ then disregard my previous comment in
the response to the cover letter.  I guess I was leaning toward putting it
in lib/ specifically because I knew that it would be hard to get it into mm/.

Thanks
--
Seth

