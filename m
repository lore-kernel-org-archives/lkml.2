Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab2B1L6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:58:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54716 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab2B1L6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:58:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dmitry.antipov@linaro.org designates 10.204.141.11 as permitted sender) smtp.mail=dmitry.antipov@linaro.org
Message-ID: <4F4CC19D.9040608@linaro.org>
Date: Tue, 28 Feb 2012 15:59:25 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Rusty Russell <rusty.russell@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH 1/2] vmalloc: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
References: <1330421640-5137-1-git-send-email-dmitry.antipov@linaro.org> <20120228094415.GA2868@mwanda>
In-Reply-To: <20120228094415.GA2868@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 01:44 PM, Dan Carpenter wrote:
> On Tue, Feb 28, 2012 at 01:33:59PM +0400, Dmitry Antipov wrote:
>>   - Fix vmap() to return ZERO_SIZE_PTR if 0 pages are requested;
>>   - fix __vmalloc_node_range() to return ZERO_SIZE_PTR if 0 bytes
>>     are requested;
>>   - fix __vunmap() to check passed pointer with ZERO_OR_NULL_PTR.
>>
>
> Why?

1) it was requested by the subsystem (co?)maintainer, see http://lkml.org/lkml/2012/1/27/475;
2) this looks to be a convenient way to trace/debug zero-size allocation errors (although
    I don't advocate it as a best way).

Dmitry
