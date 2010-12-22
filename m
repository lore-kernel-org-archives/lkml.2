Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab0LVF4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 00:56:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54148 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab0LVF4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 00:56:06 -0500
Message-ID: <4D119353.9030401@cn.fujitsu.com>
Date: Wed, 22 Dec 2010 13:57:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/4] futex,plist: remove debug lock assignment for plist_node
References: <4D10797E.7040803@cn.fujitsu.com> <4D10FC90.6020104@linux.intel.com>
In-Reply-To: <4D10FC90.6020104@linux.intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-22 13:55:57,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-22 13:55:58,
	Serialize complete at 2010-12-22 13:55:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2010 03:14 AM, Darren Hart wrote:
> On 12/21/2010 01:55 AM, Lai Jiangshan wrote:
>> original code use&plist_node->plist as the faked head of
>> the priority list for plist_del(), these debug locks in
>> the faked head are needed for CONFIG_DEBUG_PI_LIST.
>>
>> But now we always pass the real head to plist_del(), the debug locks
>> in plist_node will not be used, so we remove these assignments.
> 
> Any reason to keep this separate from  patch 1/4 ?
> 

Make the changes clearer and the patches are easier to read.
For me the purposes of patch 1/4 and 2/4 are different,
1/4 makes the code sensible. 2/4 removes unused code.
