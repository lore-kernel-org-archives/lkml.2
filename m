Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2BAAs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:48:29 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:33945 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2BAAs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:48:28 -0500
Message-ID: <4F288BBC.9080202@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 16:47:56 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        Carl Love <carll@us.ibm.com>
Subject: Re: [PATCH 5/9] perf: Adding sysfs group format attribute for pmu
 device
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com> <1327674868-10486-1-git-send-email-jolsa@redhat.com> <1327674868-10486-6-git-send-email-jolsa@redhat.com> <4F231256.8080905@linux.vnet.ibm.com> <1327699182.2446.177.camel@twins>
In-Reply-To: <1327699182.2446.177.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020100-2398-0000-0000-000003D6F962
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 01:19 PM, Peter Zijlstra wrote:
> On Fri, 2012-01-27 at 13:08 -0800, Corey Ashford wrote:
>> s an example, the IBM PowerEN processor has roughly 20 different PMU's
>> on it.  Some of those PMU's are quite complex and divide their events up
>> into subsets, each with different fields.  For example, some events may
>> have a PID matching field, and others may have an bus number matching
>> field, or matching mode field, etc.  The fields are different widths,
>> and may overlap in the config/1/2 space.
>>
>> It seems that there are two approaches you could take:
>>
>> 1) Keep your format, but allow the fields to overlap in the bit space.
>> For example:
>>
>>   "/sys/...<dev>/format/event" contains "config:0-7"
>>   "/sys/...<dev>/format/pidmatch" contains "config:8-15"
>>   "/sys/...<dev>/format/busmatch"   contains "config:8-13"
>>
>> Note that busmatch overlaps pidmatch
>>
>> 2) Create event groups that have their overlapping config space
>> separated out:
>>
>>   "/sys/...<dev>/format/event" contains "config:0-7"
>>
>>   "/sys/...<dev>.1/format/pidmatch" contains "config:8-15"
>>
>>   "/sys/...<dev>.2/format/busmatch"   contains "config:8-13"
>>
>>
>> Notice the .1 and .2 on the <dev>.
>>
>> This might help the user understand which fields go together.  I'm not
>> sold on the .1 syntax... you could do it as <dev>.<event-group-name>/ or
>> <dev>/<event-group-name>/... or whatever seems to make the most sense
>> and is relatively easy to implement and use. 
> 
> Why try and stuff those 20 in a single driver? Have 20 drivers and each
> their own format/ hierarchy.

I'm sure that could work.  Since sysfs seems to be fairly independent
(if necessary) of the hardware structure, I suppose this wouldn't be a
problem.

What do you think of Jiri's (Jirka's ?) other ideas of subdividing the
format directory?

- Corey

