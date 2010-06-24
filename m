Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0FXU6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 16:58:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50114 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab0FXU6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 16:58:45 -0400
Message-ID: <4C23C6F0.50206@zytor.com>
Date: Thu, 24 Jun 2010 13:58:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
       584846@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#584846: Detects only 64MB and fails to boot on Intel Green
 City board if e820 hooked by GRUB2
References: <20100612185538.GA4511@feather> <4C13F102.7000509@zytor.com> <20100612222634.GA1785@feather> <4C141214.5050601@zytor.com> <20100613000742.GA3469@feather> <4C14235B.7030605@zytor.com> <20100622052236.GA9130@feather> <4C205323.3010509@zytor.com> <20100624072729.GA7952@feather> <4C23693A.9040107@zytor.com> <20100624190107.GA15329@feather>
In-Reply-To: <20100624190107.GA15329@feather>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 12:01 PM, Josh Triplett wrote:
> On Thu, Jun 24, 2010 at 07:18:34AM -0700, H. Peter Anvin wrote:
>> On 06/24/2010 12:27 AM, Josh Triplett wrote:
>>> The following patch fixes GRUB; with this patch, I can reserve memory
>>> (such as with drivemap), boot 2.6.35-rc3 successfully, and it detects
>>> all of my RAM.
>>
>> Congratulations!  You have just committed the single most common BIOS
>> implementation bug.  (Sorry for the sarcasm, but this seems to be a bug
>> that almost everyone who tries to implement BIOS makes at one point or
>> another... even the original IBM BIOS had it in at least one place.)
> 
> And a rather large number of sample interrupt code found on the web,
> including the e820 hook from the version of gPXE/Etherboot that I used
> as an example. :)  Given that I just tested against Linux, which very
> carefully works around that particular BIOS bug, I didn't run into any
> issue.
> 
> So, how high does GRUB's bug ("stc ; iret"/"clc ; iret") rank on the
> list of common BIOS implementation bugs?
> 

Less common, since that one is apparently more obvious to people (you
only have to think one step ahead instead of two steps ahead.)

There is a reason Linux works around this and similar bugs... it truly
is extremely common (and does cause real problems in real code.)

	-hpa

