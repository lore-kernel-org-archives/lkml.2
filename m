Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab2A3VpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:45:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:31208 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab2A3VpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:45:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="104302397"
Message-ID: <4F270F67.4070809@linux.intel.com>
Date: Mon, 30 Jan 2012 13:45:11 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: remove .. in perf includes/
References: <1327091804-3984-1-git-send-email-andi@firstfloor.org> <20120130191429.GB5797@infradead.org>
In-Reply-To: <20120130191429.GB5797@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/2012 11:14 AM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 20, 2012 at 12:36:44PM -0800, Andi Kleen escreveu:
>> From: Andi Kleen<ak@linux.intel.com>
>>
>> The perf user space has a lot of includes with ugly .. chains. This also
>> makes it impossible to include any perf files from other code.
>>
>> I think the original reason for this were some wrapper include files
>> for the kernel includes, and the explicit paths were needed to avoid
>> endless recursion. A better way to handle this is #include_next
>>
>> - Add all the relevant directories as -I in the Makefile
>> - Remove (near) all the .. in include statements
>> - Remove unnecessary wrappers that do nothing
>> - Fix up some fallout
>>
>> This makes the code more pleasant to read.
>>
>> I did it all in one big patch to keep bisectability.
> It builds, but breaks this:

Hmm cannot reproduce. The extra tarball builds fine and includes memset_64.S
with my patch on Linus latest.

-Andi


