Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0IWWrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:47:06 -0400
Received: from mail.tpi.com ([70.99.223.143]:2874 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab0IWWrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:47:05 -0400
Message-ID: <4C9BD8D5.7080201@canonical.com>
Date: Fri, 24 Sep 2010 06:46:45 +0800
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MCP limit log messages, 2.6.36-rc4
References: <4C9106C1.4080505@canonical.com>	<20100923134816.57e932fc@jbarnes-desktop> <20100923145428.4805adcb@jbarnes-desktop>
In-Reply-To: <20100923145428.4805adcb@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2010 05:54 AM, Jesse Barnes wrote:
> On Thu, 23 Sep 2010 13:48:16 -0700
> Jesse Barnes<jbarnes@virtuousgeek.org>  wrote:
>
>> On Wed, 15 Sep 2010 11:47:45 -0600
>> Tim Gardner<tim.gardner@canonical.com>  wrote:
>>
>>> I've been getting regular MCP limit log messages on a Dell Studio 1458
>>> (i5 CPU) with an A02 BIOS. With the attached debug hack it prints the
>>> following values:
>>>
>>> [   33.605098] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
>>> 30123, limit 1023
>>> [   38.597998] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
>>> 21697, limit 1023
>>> [   43.590917] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
>>> 15390, limit 1023
>>> [   48.583821] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
>>> 43370, limit 1023
>>> [   53.576740] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
>>> 64728, limit 1023
>>>
>>> This is an idle machine which starts printing these messages about 30
>>> seconds after boot. Any thoughts?
>>
>> Actually, it looks like you have some non-upstream patches to the IPS
>> driver, maybe one of Joe's patches to add more debug output when limits
>> are exceeded?
>>

Its just a debug hack which I wrote (that I mentioned in the first 
email) so I could figure out why the driver was complaining.

>> At any rate, I think we're setting the MCP power limit incorrectly.
>> The BIOS must be giving us a limit in 0.1W units (though even then it
>> looks bogus); we need to clamp it to one of the available defaults.
>>
>> Joe has some code for that as well, I've just asked him to update his
>> patch, which we should get into 2.6.35.x.
>
> Just posted some fixes for this to the x86 driver list, in particular
> the "[PATCH 2/2] IPS driver: verify BIOS provided limits" should help a
> bit here, but I still have a bug to fix in the i915 driver to really
> make things work.
>

I'll be back from Asia by Monday and will give these patches a try.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
