Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab0HRXuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:50:54 -0400
Received: from exprod7og118.obsmtp.com ([64.18.2.8]:49522 "EHLO
	exprod7og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0HRXuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:50:52 -0400
Message-ID: <4C6C71B9.6090606@genband.com>
Date: Wed, 18 Aug 2010 17:50:17 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Shishkin <virtuoso@slind.org>, lkml@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org> <20100818155702.bc62b2a6.akpm@linux-foundation.org>
In-Reply-To: <20100818155702.bc62b2a6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Aug 2010 23:50:22.0838 (UTC) FILETIME=[1F6C9160:01CB3F30]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17578.002
X-TM-AS-Result: No--13.373500-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 04:57 PM, Andrew Morton wrote:

> The requirements sound a bit fluffy to me.
> 
> Any time-displaying application will find out the new time next time
> it reads the time.  So afaict this is only really useful for clock
> applets which display once per minute, so they will show the new time
> promptly after the time was altered, yes?  Is that really worth adding
> new code for?

There are other users of this functionality.  We have an emulator
running on top of linux which in turn runs code originally intended for
another OS.  It cares about walltime, so it wants to know ASAP if the
linux system time changes.

We've actually been carrying an internal patch doing something like this
for years now...never pushed it to mainline since we didn't think anyone
else would be interested.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
