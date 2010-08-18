Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab0HRXoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:44:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33698 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab0HRXof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:44:35 -0400
Message-ID: <4C6C7034.4050501@zytor.com>
Date: Wed, 18 Aug 2010 16:43:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
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
        John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org> <20100818155702.bc62b2a6.akpm@linux-foundation.org>
In-Reply-To: <20100818155702.bc62b2a6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 03:57 PM, Andrew Morton wrote:
> On Wed, 18 Aug 2010 16:55:39 +0300
> Alexander Shishkin <virtuoso@slind.org> wrote:
> 
>> Certain userspace applications (like "clock" desktop applets or cron) might
>> want to be notified when some other application changes the system time.
> 
> The requirements sound a bit fluffy to me.
> 
> Any time-displaying application will find out the new time next time
> it reads the time.  So afaict this is only really useful for clock
> applets which display once per minute, so they will show the new time
> promptly after the time was altered, yes?  Is that really worth adding
> new code for?
> 

Actually a much more significant use case was given for the "civil
periodic" type events: something that wants to happen "every day at
noon", for example.  The logical thing of sleeping until the next noon
breaks if the walltime clock is changed.  As such, things like cron have
to resort to wake up once a minute just to assure themselves that they
have nothing to do.  This is inefficient, especially for battery-powered
devices.

Applications which display time aren't really as much affected, since
they generaly wake up every minute or every second anyway.

	-hpa
