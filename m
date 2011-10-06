Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935555Ab1JFAbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 20:31:40 -0400
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:58493 "EHLO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab1JFAbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 20:31:39 -0400
Message-ID: <4E8CF69E.4030000@genband.com>
Date: Wed, 05 Oct 2011 18:30:22 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Mark Mielke <mark@mark.mielke.cc>
CC: linux-kernel@vger.kernel.org
Subject: Re: Appropriate use of sync() from user space?
References: <4E8CEECF.4050008@mark.mielke.cc>
In-Reply-To: <4E8CEECF.4050008@mark.mielke.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2011 00:30:24.0568 (UTC) FILETIME=[23923B80:01CC83BF]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18428.003
X-TM-AS-Result: No--14.614900-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 05:57 PM, Mark Mielke wrote:

> The vendor stated that sync() is integral to their synchronization
> process to ensure all files reach disk before they are accessed, and
> that this is not a defect in their product. We have a work around - run
> "sync" before calling their command, and this generally avoids the
> failures.
>
> I think the use of sync() in this regard is a hack. According to POSIX.1
> and the Linux man pages, it seems clear to me that sync() does not
> guarantee data integrity (bytes guaranteed to have reached disk) - and
> it also seems clear that forcing all system data to flush out in
> response to a minor command is over kill. Like cutting down the forest
> to harvest fruit from a single tree.
>
> I'm wondering what you think.

Totally agree.

The susv3 man page for sync() is pretty clear:  "The writing, although 
scheduled, is not necessarily complete upon return from sync()."

They should probably be using msync()/fsync()/fdatasync() which only 
affect the specified files and are supposed to wait for the data to hit 
the storage device.  Of course this would require them to do something 
for each file they touch rather than once at the end of the whole operation.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
