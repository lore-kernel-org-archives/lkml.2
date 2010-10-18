Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0JRVoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:44:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60266 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab0JRVoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:44:14 -0400
Message-ID: <4CBCBF9D.1060409@zytor.com>
Date: Mon, 18 Oct 2010 14:43:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] x86: Cleanup TIF value gaps in shift range
References: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com> <alpine.DEB.2.00.1010181340080.10965@chino.kir.corp.google.com> <alpine.LFD.2.00.1010182320440.6815@localhost6.localdomain6> <4CBCBBFC.1090500@zytor.com> <alpine.DEB.2.00.1010181431440.15782@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1010181431440.15782@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 02:36 PM, David Rientjes wrote:
> On Mon, 18 Oct 2010, H. Peter Anvin wrote:
> 
>> The problem is that someone exports something as debugging information,
>> then someone else suddenly thinks it's an ABI.  I believe the same
>> complainant in the past has objected to changing of formatting in dmesg,
>> which is equally insane.
>>
> 
> It's not insane if there is no other way to ascertain that information.  
> If it's available through sysfs or debugfs (and, even better, documented 
> as part of the API in Documentation/ABI), then I don't think anyone would 
> object to changing a log message.  But I don't think all log messages 
> should be fair game under some general principle if they are being changed 
> (instead of just extending it) without a compelling reason, such as 
> technically being incorrect in its present form.

YES IT IS.  In fact, it is completely and totally bananas bonkers.

By not pushing for a proper maintainable ABI, you will have an
indefinite forward compatibility problem, and when predictably it
breaks, you'll complain.  This is, however, backwards -- the right thing
would have been to say "I need this, this isn't available, I should add
a maintainable API and push it upstream", and perhaps add log parsing as
a backwards-compatibility solution.

	-hpa

