Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849Ab2CJDot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 22:44:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59428 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759037Ab2CJDos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 22:44:48 -0500
Message-ID: <4F5ACE2A.2030807@gmail.com>
Date: Sat, 10 Mar 2012 11:44:42 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
CC: "jbaron@redhat.com" <jbaron@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Refine mutex and rcu method in module.c, kernel<3.2.9>
References: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com> <491D6B4EAD0A714894D8AD22F4BDE0430328AF@SCYBEXDAG04.amd.com> <491D6B4EAD0A714894D8AD22F4BDE043032910@SCYBEXDAG04.amd.com>
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE043032910@SCYBEXDAG04.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 12:48 AM, Chen, Dennis (SRDC SW) wrote:
> Adding dynamic debug maintainer -- Jason Baron...
>
> -----Original Message-----
> From: Chen, Dennis (SRDC SW)
> Sent: Wednesday, March 07, 2012 10:57 PM
> To: linux-kernel@vger.kernel.org
> Cc: Chen, Dennis (SRDC SW)
> Subject: [PATCH 2/2] Refine mutex and rcu method in module.c, kernel<3.2.9>
>
> 1. Add protection code for module_bug_list readers
> 2. Add a new module_bug_mutex as the mutex of the module_bug_list writers

Take a look at the comments in the code:

         /*
          * Strictly speaking this should have a spinlock to protect against
          * traversals, but since we only traverse on BUG()s, a spinlock
          * could potentially lead to deadlock and thus be 
counter-productive.
          */


module_find_bug() is called in a dying path...
