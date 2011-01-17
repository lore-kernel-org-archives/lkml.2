Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab1AQG6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 01:58:07 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:32786 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1AQG6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 01:58:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bNLwCEnME3krRy0uDoZ3zl3gQstfvy6j/D+bq91xCOj1+g43QkRgetA+mjl3RKDbkj
         6pqA5u1n4IctjTYReYbGthso4ZvTBLe6srwYtwWwHR8EtHJEu6VVXRaD72aE5Mg/UIyn
         CzCI5bob9gm8B3dpkRgozJFo4LvjeLalKlEXA=
Date: Mon, 17 Jan 2011 14:57:53 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: xing lin <linxingnku@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at ffff8800cf669000
Message-ID: <20110117065753.GD11358@cr0.nay.redhat.com>
References: <AANLkTin9dGAQ1fZM_8MsFr3dGwc17vGEGszY_hPMdozp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin9dGAQ1fZM_8MsFr3dGwc17vGEGszY_hPMdozp@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 04:30:51PM -0700, xing lin wrote:
>Hi,
>
>I wrote a kernel module to calculate the hash for each page frame, in
>order to see how many pages are duplicated. It works well in 32-bit
>Linux with 2GB physical memory. But when I tried to run this module in
>64-bit Linux(2.6.32-24-generic with NUMA enabled) with 12GB physical
>memory, it can calculates hashes for the first 63553 in-use pages but
>then reports a bug when the page frame number reaches 849513. This
>page frame should be in use since the count for the page instance is
>1. I do not know why sha_transform results in a page_fault(the data to
>be digested is the page which should be in memory). Would anyone give
>me some hints? Thanks.
>

Isn't this what KSM does? :) Check mm/ksm.c, it uses jhash2().

