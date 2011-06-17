Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159Ab1FQO2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:28:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59744 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758350Ab1FQO2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cKzjbdnOsFe6hFpLEuNxdlAdrSKWnc4eS+MlrwiP1GqtS3SY+0GrPrMdpjSz71m/8x
         nqo3D+W/BjPbwh/u9ySRWZHaaNvnEY1kq0zMRWqps9lgkEddNIpeOQ8XVSZU/ttgwx5N
         2TGclKevx8InzCjpsxWL3q7SbGw80m8Y8WUX0=
Message-ID: <4DFB649C.8030303@gmail.com>
Date: Fri, 17 Jun 2011 08:28:44 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf: add reference time event
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com> <1307490946-24673-1-git-send-email-dsahern@gmail.com> <20110617133230.GC25197@somewhere.redhat.com> <4DFB5F0B.4020903@gmail.com> <20110617141707.GE25197@somewhere.redhat.com>
In-Reply-To: <20110617141707.GE25197@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2011 08:17 AM, Frederic Weisbecker wrote:
>>> We would like to avoid adding more custom events like these. They were very convenient
>>> but they steal the kernel event type space. They are deemed for removal in the long term.
>>>
>>> Another idea to achieve what you want would be to create a new perf event header feature,
>>> like HEADER_TRACE_INFO or HEADER_BUILD_ID are. Then use that to create a space in the perf
>>> file to save that couple of clocks initial values.
>>
>> you mean like this:
>> https://lkml.org/lkml/2010/12/7/813
>>
>> David
> 
> Exactly, why did you change?

As I recall suggestions on adding new clock events and using those for
periodic samples. Once we have the initial correlation (the point of
this patch) and updates to xtime (the new tracepoints) periodic events
should not be needed.

I'll go back to this option -- and address comments from that round as well.

David
