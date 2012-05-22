Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172Ab2EVPLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:11:45 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41805 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759099Ab2EVPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:11:44 -0400
Message-ID: <4FBBAC59.1000805@linaro.org>
Date: Tue, 22 May 2012 08:10:17 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 4/6] time: introduce leap second functional interface
References: <cover.1337348892.git.richardcochran@gmail.com> <eee0b50afdea829c727d6210afb8299a4cf30981.1337348892.git.richardcochran@gmail.com> <4FBA82DF.9060009@linaro.org> <20120521191844.GC19812@netboy.at.omicron.at> <4FBAA499.1070905@linaro.org> <20120522042534.GA2184@netboy.at.omicron.at>
In-Reply-To: <20120522042534.GA2184@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052215-2398-0000-0000-000006D8C933
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 09:25 PM, Richard Cochran wrote:
> On Mon, May 21, 2012 at 01:24:57PM -0700, John Stultz wrote:
>> The locking order is pretty straight forward: timekeeper.lock ->
>> ntp_lock.   This only gets messy when you require timekeeping data
>> from the ntp context, but usually we provide the required data via
>> the caller.  But better documentation is always welcome.
> The icky part is the fact that ntp would need access to timekeeper
> state while holding ntp_lock.
Well, that needs to be reworked so it doesn't.  :)   Again, passing the 
required time state to NTP functions from the timekeeping context should 
handle these issues, and for those few NTP paths that aren't triggered 
from the timekeeping core (do_adjtimex basically), we can grab the 
required time state before taking the ntp lock as we have been doing.

thanks
-john

