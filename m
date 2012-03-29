Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab2C2RKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:10:06 -0400
Received: from fifo99.com ([67.223.236.141]:47041 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933558Ab2C2RJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:09:31 -0400
Date: Thu, 29 Mar 2012 10:09:30 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [RFC] Android Logger vs. Shared Memory FIGHT!
Message-ID: <20120329170930.GD16476@fifo99.com>
References: <20120328210631.GB2297@fifo99.com>
 <20120329145055.GE13912@fifo99.com>
 <4F748CF6.4010205@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F748CF6.4010205@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 09:25:26AM -0700, Tim Bird wrote:
> 
> There is concern about applications leaking sensitive data into the logs,
> and a desire to possibly (in the future) support per-application logs
> for some apps.  Having the code in-kernel means that things like the
> timestamp, tid and pid cannot be forged by the process.  The separation
> into channels and kernel management of the read/write position provide
> an impediment to denial of service attacks.

it's unclear what problem would be caused by forging a PID, and why any
app would want to do that. It doesn't look like it would cause any
problems.

> At the moment, I'm not considering an alternative for logger that runs
> completely in user-space.  Having said that, this test is certainly interesting,
> and may provide some performance numbers for logger or alternatives that would
> be useful to compare.

It's certainly up to you what you want to use, but I don't see why any
other architecture or OS would want to use logger.
 
> I like that you've put the gettimeofday() into the shared memory test, to
> capture the cost of the timestamp operation.  Presumably, the fact that
> x86 has VDSO and ARM does not is contributing to the performance difference
> between the two platforms.

John Stultz commented on how gettimeofday() is more accurate that what
is needed. Logger actually uses a less accurate, and faster, method of timing.
The time isn't exactly apples to apples, my shared memory example is actually
using a slower clock compared to logger.
 
> 
> Tests were 60 seconds.  I presume there were multiple runs and these are
> averages.  Can you provide the number of runs and the standard deviation for
> each set?


Test cases were 600 seconds (10 minutes) .. There were three runs. 
Here's the raw data, all in bytes per second:

X86:
Logger TSC = 70072480.0, 83911562.7, 78610971.8
Shared Memory TSC = 460262336.0, 454204684.1, 457050682.2

Logger ACPI_PM = 75523320.0, 81615111.9, 81588600.2
Shared Memory ACPI_PM = 29688532.0, 28211029.2, 28225661.6


ARM:
Logger = 6985508.0, 5827587.3, 7034293.7
Shared Memory = 12371886.7, 18362639.9, 15274489.3

You can feel free to compute the standard deviation if you wish.

Daniel
