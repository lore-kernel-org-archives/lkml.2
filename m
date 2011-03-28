Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab1C1TsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:48:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37923 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab1C1TsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:48:06 -0400
Message-ID: <4D90E5ED.3080604@zytor.com>
Date: Mon, 28 Mar 2011 12:47:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Maksym Planeta <mcsim.planeta@gmail.com>
CC: mingo@redhat.com, kernel-janitors@vger.kernel.org, namhyung@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: page: get_order() optimization
References: <1301215556-8898-1-git-send-email-mcsim.planeta@gmail.com>
In-Reply-To: <1301215556-8898-1-git-send-email-mcsim.planeta@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2011 01:45 AM, Maksym Planeta wrote:
> For x86 architecture get_order function can be optimized due to
> assembler instruction bsr.
> 
> This is second version of patch where for constants gcc precompute the
> result.
> 
> Signed-off-by: Maksym Planeta <mcsim.planeta@gmail.com>

gcc 4.x has an intrinsic, __builtin_clz(), which does the opposite of
the bsr instruction; specifically:

	__builtin_clz(x) ^ 31

... generates a bsrl instruction if x is variable.  This tends to
generate much better code than any assembly hacks.

	-hpa
