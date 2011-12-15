Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab1LOLgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 06:36:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53639 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab1LOLgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 06:36:06 -0500
Date: Thu, 15 Dec 2011 12:35:53 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Steve Allen <sla@ucolick.org>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
Message-ID: <20111215113553.GA124@cherladcori01>
References: <cover.1323739287.git.luto@amacapital.net>
 <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm>
 <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
 <20111214074640.GB2180@netboy.at.omicron.at>
 <1323881310.6805.41.camel@work-vm>
 <20111214183025.GB2465@netboy.at.omicron.at>
 <1323889666.6805.71.camel@work-vm>
 <CALCETrXwQXnRRAUZ+h=kR4wUVyfAQyGRd==W47W7LsW7Ci-KAw@mail.gmail.com>
 <1323898490.6805.92.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323898490.6805.92.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 01:34:50PM -0800, john stultz wrote:

> FYI: Interesting additional emails from Steve Allen below (forwarded
> with permission) that put some caution around CLOCK_TAI. 

I saw that, too, and I have a comment, below.

> -------- Forwarded Message --------
> From: Steve Allen <sla@ucolick.org>
> To: John Stultz <johnstul@us.ibm.com>
> Subject: TAI in linux kernel
> Date: Wed, 14 Dec 2011 11:44:23 -0800
> 
> Greetings John Stultz,
> 
> I note the linux kernel discussion mentioning the use of TAI.
> 
> It may be relevant to note the position of the CCTF and BIPM on
> the use of TAI as expressed in Document CCTF/09-27
> 
> http://www.bipm.org/cc/CCTF/Allowed/18/CCTF_09-27_note_on_UTC-ITU-R.pdf
> 
> Their position is that they do not want TAI used as an operational
> system time, and in their last paragraph they make it plain that
> they would consider suppressing TAI in order to accomplish that.
> 
> Building TAI into the linux kernel could result in the use of
> an nonexistent time standard.

Yes, they would do this only if UTC becomes continuous and decoupled
from the whole leap second mess. I don't think it would be a problem
for the kernel, since we could simply re-name the kernel time scale to
UTC+X, or just remove the offset and call it UTC.

This would only happen if and when everyone agrees to the UTC
redefinition. I am not holding my breath. Earlier on in the article we
read that "after serveral years of discussions and analysis of
documents no firm postion has been taken."  That article is dated
2007. Is the UTC fixup any closer now than it was back then?

Also, TAI has already been standardized as an operational time scale
by IEEE standard 1588.

Thanks,
Richard
