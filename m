Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab1FVS0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:26:42 -0400
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:32987 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab1FVS0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:26:41 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jun 2011 14:26:40 EDT
Message-ID: <4E02328A.80305@genband.com>
Date: Wed, 22 Jun 2011 12:20:58 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Nemo Publius <nemo@self-evident.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Does Linux select() violate POSIX?
References: <BANLkTik9HzR_oJ7FocQ=o+zNoK22tUTjBg@mail.gmail.com>
In-Reply-To: <BANLkTik9HzR_oJ7FocQ=o+zNoK22tUTjBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2011 18:20:59.0217 (UTC) FILETIME=[229E5410:01CC3109]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18216.001
X-TM-AS-Result: No--17.417900-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2011 11:06 AM, Nemo Publius wrote:
> Suppose I  have a file descriptor referencing a TCP/IP socket in blocking mode.
>
> Suppose select() reports that the descriptor is ready for reading.
>
> If I then call recv() on that descriptor, can it _ever_ block?

There was a long discussion about this back in 2004.

http://lkml.org/lkml/2004/10/6/117

Based on that discussion and the need to deal with legacy apps, 
udp_poll() has special-case code to handle blocking sockets--it 
validates the checksum before declaring the socket readable.  This costs 
some performance, so for non-blocking sockets the checksum validation is 
deferred until later when it will be hot in the cache due to the copy to 
userspace.

Other protocols may not handle this and so the warning is still valid in 
general.

Chris


-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
