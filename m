Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab2BHRXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:23:15 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49687 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2BHRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:23:14 -0500
Message-ID: <4F32AF27.8050401@linux.vnet.ibm.com>
Date: Wed, 08 Feb 2012 09:21:43 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/5] staging: zsmalloc: zsmalloc memory allocation library
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com> <1326149520-31720-2-git-send-email-sjenning@linux.vnet.ibm.com> <4F21A5AF.6010605@linux.vnet.ibm.com> <4F300D41.5050105@linux.vnet.ibm.com> <4F32A55E.8010401@linux.vnet.ibm.com> <409797c4-a6e7-493d-9681-4166a9473ab8@default>
In-Reply-To: <409797c4-a6e7-493d-9681-4166a9473ab8@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020817-5806-0000-0000-00001236967A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 09:15 AM, Dan Magenheimer wrote:
> The zsmalloc allocator can grab
> any random* page "A" with X unused bytes at the END of the page,
> and any random page "B" with Y unused bytes at the BEGINNING of the page
> and "coalesce" them to store any byte sequence with a length** Z
> not exceeding X+Y.  Presumably this markedly increases
> the density of compressed-pages-stored-per-physical-page***.

Ahh, I did miss that.  I assumed it was simply trying to tie two order-0
pages together.  I _guess_ the vmap() comment stands, though.

