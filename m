Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab1AEVgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:36:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43297 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1AEVgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:36:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hwXpDheFY/7VsDboqKTMrwZAojxYI25MynjKkrf626fOXYwpYaLhh46CCjECYq/4/q
         nBAZXJ8CWsmoYvuxMDPOl1o1cy1/jYrPDmvjAKeyFHQBhHMvXo6cfvKeGj2UHm+6B2Do
         sQ/miYuwgkBlqnvenWKl+weeePTwkRNhZJcZQ=
Message-ID: <4D24E444.6080308@gmail.com>
Date: Wed, 05 Jan 2011 22:36:04 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>, steiner@sgi.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
Subject: Re: suspend hangs at platform phase [was: mmotm 2010-12-23-16-58
 uploaded]
References: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org> <4D232352.2030809@gmail.com> <4D234F8E.7080102@gmail.com> <201101042357.08600.rjw@sisk.pl>
In-Reply-To: <201101042357.08600.rjw@sisk.pl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 11:57 PM, Rafael J. Wysocki wrote:
> On Tuesday, January 04, 2011, Jiri Slaby wrote:
>> On 01/04/2011 02:40 PM, Jiri Slaby wrote:
>>> On 12/24/2010 01:58 AM, akpm@linux-foundation.org wrote:
>>>> The mm-of-the-moment snapshot 2010-12-23-16-58 has been uploaded to
>>>
>>> Hi, this kernel regresses with respect to suspend to ram in comparison
>>> with mmotm 2010-12-16-14-56.
>>>
>>> This is OK:
>>> echo devices > /sys/power/pm_test
>>> pm-suspend
>>> This hangs at suspend phase:
>>> echo platform > /sys/power/pm_test
>>> pm-suspend
> 
> Hmm.  So it looks like _PTS hangs?

No _PST here :).

>>> Note that this kernel is based on next-20101221. Should I try newer (and
>>> clean) -next?
>>
>> Ok, bisected down to:
>> 16dc39c98a6ca56a27f22f7ac6731d8223237a2e is first bad commit
>> commit 16dc39c98a6ca56a27f22f7ac6731d8223237a2e
...
>> Revert of that patch fixes the problem.
> 
> Can you send a dmesg output and acpidump output from the failing system, please?

Here they are:
http://www.fi.muni.cz/~xslaby/sklad/panics/dmesg-no-susp.txt
http://www.fi.muni.cz/~xslaby/sklad/adump.txt

They are captured from the mmotm minus 16dc39c98a6ca56 if that's OK?
Ignore the BUG there, it's caused by qemu and fixed in later -next.

regards,
-- 
js
