Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0DOBbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 21:31:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37628 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab0DOBbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 21:31:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A3ayDIULRn+iSk1Gg94uZWwqAu4+CGyarlg3m/0LFIeuI50uhkR00GnbBcJ3k43gyw
         mzXd5v2eRCK7AYxZv28g+PZCrfg1yHnf+njk3nKEYlvVTrRPAwTBVZly14oAvrT0JiYB
         EIvJxAbOEl4NtlNcvkaO6bARfy3/NIlESOp0U=
MIME-Version: 1.0
In-Reply-To: <4BC65237.5080408@kernel.org>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <d5d70d4b57376bc89f178834cf0e424eaa681ab4.1271171877.git.minchan.kim@gmail.com>
	 <20100413154820.GC25756@csn.ul.ie> <4BC65237.5080408@kernel.org>
Date: Thu, 15 Apr 2010 10:31:23 +0900
Message-ID: <v2j28c262361004141831h8f2110d5pa7a1e3063438cbf8@mail.gmail.com>
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun.

On Thu, Apr 15, 2010 at 8:39 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 04/14/2010 12:48 AM, Mel Gorman wrote:
>> and the mapping table on x86 at least is based on possible CPUs in
>> init_cpu_to_node() leaves the mapping as 0 if the APIC is bad or the numa
>> node is reported in apicid_to_node as -1. It would appear on power that
>> the node will be 0 for possible CPUs as well.
>>
>> Hence, I believe this to be safe but a confirmation from Tejun would be
>> nice. I would continue digging but this looks like an initialisation path
>> so I'll move on to the next patch rather than spending more time.
>
> This being a pretty cold path, I don't really see much benefit in
> converting it to alloc_pages_node_exact().  It ain't gonna make any
> difference.  I'd rather stay with the safer / boring one unless
> there's a pressing reason to convert.

Actually, It's to weed out not-good API usage as well as some performance gain.
But I don't think to need it strongly.
Okay. Please keep in mind about this and correct it if you confirms it
in future. :)

>
> Thanks.
>
> --
> tejun
>



-- 
Kind regards,
Minchan Kim
