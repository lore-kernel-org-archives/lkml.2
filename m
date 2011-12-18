Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab1LRWsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 17:48:37 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52236 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab1LRWsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 17:48:35 -0500
Message-ID: <4EEE6DC0.2030007@gmail.com>
Date: Sun, 18 Dec 2011 17:48:32 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ryota Ozaki <ozaki.ryota@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-mm@kvack.org,
        stable@kernel.org
Subject: Re: [PATCH][RESEND] mm: Fix off-by-one bug in print_nodes_state
References: <1324209529-15892-1-git-send-email-ozaki.ryota@gmail.com> <alpine.DEB.2.00.1112181439500.1364@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1112181439500.1364@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/18/11 5:44 PM), David Rientjes wrote:
> On Sun, 18 Dec 2011, Ryota Ozaki wrote:
>
>> /sys/devices/system/node/{online,possible} involve a garbage byte
>> because print_nodes_state returns content size + 1. To fix the bug,
>> the patch changes the use of cpuset_sprintf_cpulist to follow the
>> use at other places, which is clearer and safer.
>>
>
> It's not a garbage byte, sysdev files use a buffer created with
> get_zeroed_page(), so extra byte is guaranteed to be zero since
> nodelist_scnprintf() won't write to it.  So the issue here is that
> print_nodes_state() returns a size that is off by one according to
> ISO C99 although it won't cause a problem in practice.
>
>> This bug was introduced since v2.6.24.
>>
>
> It's not a bug, the result of a 4-node system would be "0-3\n\0" and
> returns 5 correctly.  You can verify this very simply with strace.

Usually, /sys files don't output trailing '¥0'. And, '¥0' is not regular
io friendly. So I can imagine some careless programmer think it is 
garbage. Is there any benefit to show trailing '¥0'?

