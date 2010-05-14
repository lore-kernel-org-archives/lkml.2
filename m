Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0ENGXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:23:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37629 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab0ENGXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:23:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mBX+3xULuHNNeValdSkPuWJgpSZF1CUrTPN6M6/Alont/Bf06RIpf9wP6BoPvGgmNx
         EijfEaWFujfrFmWhEtoE9RuOELq1x+mWuDceCHr8VYrCjZy8cPoXnnxJxuUVxcQr0tok
         EE6lWwbAj1t9v+kok/hluxi66D0vg2BgasmwQ=
Date: Fri, 14 May 2010 14:27:34 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: /proc/<pid>/maps question....why aren't adjacent memory chunks
 merged?
Message-ID: <20100514062734.GA5612@cr0.nay.redhat.com>
References: <4BEC704C.9000709@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEC704C.9000709@nortel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 03:34:04PM -0600, Chris Friesen wrote:
>Hi,
>
>I've got a system running a somewhat-modified 2.6.27 on 64-bit x86.
>
>While investigating a userspace memory leak issue I noticed that
>/proc/<pid>/maps showed a bunch of adjacent anonymous memory chunks with
>identical permissions:
>
>7fd048000000-7fd04c000000 rw-p 00000000 00:00 0
>7fd04c000000-7fd050000000 rw-p 00000000 00:00 0
>7fd050000000-7fd054000000 rw-p 00000000 00:00 0
>7fd054000000-7fd058000000 rw-p 00000000 00:00 0
>7fd058000000-7fd05c000000 rw-p 00000000 00:00 0
>7fd05c000000-7fd060000000 rw-p 00000000 00:00 0
>7fd060000000-7fd064000000 rw-p 00000000 00:00 0
>7fd064000000-7fd068000000 rw-p 00000000 00:00 0
>7fd068000000-7fd06c000000 rw-p 00000000 00:00 0
>7fd06c000000-7fd070000000 rw-p 00000000 00:00 0
>7fd070000000-7fd074000000 rw-p 00000000 00:00 0
>7fd074000000-7fd078000000 rw-p 00000000 00:00 0
>7fd078000000-7fd07c000000 rw-p 00000000 00:00 0
>7fd07c000000-7fd07fffe000 rw-p 00000000 00:00 0
>
>I was under the impression that the kernel would merge areas together in
>this circumstance.  Does anyone have an idea about what's going on here?
>

Well, that is not so simple, there are other considerations,
you need to check vma_merge(), especially can_vma_merge_{after,before}().

Thanks.

