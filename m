Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab0K2TjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:39:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52477 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab0K2TjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:39:24 -0500
Message-ID: <4CF4012E.3040901@zytor.com>
Date: Mon, 29 Nov 2010 11:38:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: Ingo Molnar <mingo@elte.hu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk, serue@us.ibm.com,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
References: <20101116104600.GA24015@suse.de>	<20101119191906.GA31760@xanatos>	<AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com>	<20101126074809.GD19589@elte.hu>	<20101129163308.GA2383@xanatos>	<20101129180429.GB14046@elte.hu>	<4CF3F996.4090703@zytor.com> <AANLkTinQHidwuZLqjjdyxyT-UAVao4XngNsz3tFUPN8M@mail.gmail.com>
In-Reply-To: <AANLkTinQHidwuZLqjjdyxyT-UAVao4XngNsz3tFUPN8M@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 11:21 AM, Eric Paris wrote:
>>
>> Delegating CAP_SYS_ADMIN, of course, otherwise known as "everything", is
>> worse than anything...
> 
> Serge just proposed a new CAP_SYSLOG
> 
> http://lwn.net/Articles/378472/
> 
> Which could probably still be renamed and used to cover this access as well....
> 

Quite frankly, the Linux capability system is largely a mess, with big
bundled capacities that don't make much sense and are hideously
inconvenient with the capability system used in user space (groups).
For things like this that genuinely has a file node, *let's use it* and
allow permissions to be controlled by the file node!

	-hpa
