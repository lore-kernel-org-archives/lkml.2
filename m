Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab0CQILV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:11:21 -0400
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:35937 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753523Ab0CQILR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:11:17 -0400
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 04:11:17 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=DzcC0JhCFQg3CJ55/VJuouUUAPVMpWTC/edp5nUVwMms7dJGz/jgy5zwyCv+lNyr;
  h=Received:Message-ID:From:To:Cc:References:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <F0C16B7475144C4089CF76CBAB92072D@wizardess.wiz>
From: "jdow" <jdow@earthlink.net>
To: "Tejun Heo" <tj@kernel.org>, "Kevin Easton" <caf@guarana.org>
Cc: "James Bottomley" <James.Bottomley@suse.de>,
       <linux-kernel@vger.kernel.org>
References: <20100317025101.GA13339@guarana.org> <4BA05004.3040405@kernel.org>
Subject: Re: ATA 4 KiB sector issues.
Date: Wed, 17 Mar 2010 01:01:55 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5843
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
X-ELNK-Trace: bb89ecdb26a8f9f24d2b10475b57112071baa9b735746dc6e2fdcdf0b4623d12b174fd24821b975c350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.127.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Tejun Heo" <tj@kernel.org>
Sent: Tuesday, 2010/March/16 20:44


> Hello,
> 
> On 03/17/2010 11:51 AM, Kevin Easton wrote:
>> Can't we fix the problem by defaulting to aligning partitions to
>> start on an LBA that is a multiple of 64260 ?
>> 
>> Such partitions will always be 4KiB-aligned, *and* start-of-cylinder
>> aligned (assuming 255/63, as seems to be the norm).
>> 
>> Sure, that reduces your partition granularity to almost-32-MiB, but
>> that's pretty small potatoes these days (and it's only a *default*, so
>> you could always override that if you really cared, and didn't need 
>> the compatibility).
> 
> The only thing we can gain by that is possible compatibility w/ very
> old operating systems (<=w2k, BTW, it would be great if someone can
> actually test it).  Plus, breaking the first cylinder assumption might
> not be always safe to begin with.  I personally don't think it's
> something worth departing from the behavior most vendors would assume
> from now on (1MiB alignment).  It should be enough and safer to
> provide a mechanism to choose legacy alignment if someone is trying to
> put something which is older than a decade there.
> 
> Thanks.
> 
> -- 
> tejun

WRT very old filesystems - it won't affect Amiga partition tables or
the Amiga FFS. It already understands large block sizes natively. And
that's MY definition of "old" with "very" in front of it.

{^_^}   Joanne Dow
